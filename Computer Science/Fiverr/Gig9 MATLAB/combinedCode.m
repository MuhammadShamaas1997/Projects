% Combined Impulse Response Measurement Script

%% Device Settings
device = 'Scarlett 4i4 USB'; % Audio device name
fs = 48000;				% Sample rate (Hz)
L = 1024; 				% Samples per frame
recChMap = 1;			% Recorder channel mapping
latencyPlayCh = 2;		% Latency player channel
latencyRecCh = 2;		% Latency recorder channel
playChMapAll = [1 2];	% Player channel map including latency channel
recChMapAll = [1 2];	% Recorder channel map including latency channel
nbPlayChAll = 2;		% Total number of playback channels
nbRecCh = 1;			% Total number of recorder channels

%% Method Settings (Exponential Swept Sine)
nbRunsTotal = 2;		% Number of Runs
durationPerRun = 10; 	% Duration per Run (s)
outputLevel = -6;		% Excitation Level (dBFS)
% Advanced Run Settings
nbWarmUps = 0;			% Number of warm-up runs
pauseBetween = 1;		% Pause between runs (s)
% Advanced Excitation Settings
sweepRange = [10 22000]; % Sweep start/stop frequency (Hz)
sweepDur = 4;			% Sweep Duration (s)
% IR measurement duration corresponds to the silent time after the sweep
irDur = durationPerRun - sweepDur;

%% Create the excitation signal
% First, generate a short sweep for measuring latency
latencySweepLevel = outputLevel - 6;
latencySweep = sweeptone( ...
    0.5, max(1, irDur + pauseBetween), fs, ...
    'ExcitationLevel', latencySweepLevel, ...
    'SweepFrequencyRange', [fs / 2000 fs / 20]);

% Generate the main excitation sweep for the measurement
exc = sweeptone( ...
    sweepDur, irDur, fs, ...
    'ExcitationLevel', outputLevel, ...
    'SweepFrequencyRange', sweepRange);

% Add silence and create excitation repetitions
lengthPreSilence = max(ceil(1 * fs), L);
startSilenceAndLatency = zeros(lengthPreSilence + length(latencySweep), nbPlayChAll);
betweenSilence = zeros(ceil(pauseBetween * fs), 1);
excSequence = [startSilenceAndLatency; ...
    repmat([exc; betweenSilence], nbRunsTotal - 1, nbPlayChAll); ...
    repmat(exc, 1, nbPlayChAll)];

% Keep track of the parts corresponding to the excitation (not silence)
recIdx = logical([startSilenceAndLatency(:, 1); ...
    repmat([ones(size(exc)); betweenSilence], nbRunsTotal - 1, 1); ...
    ones(size(exc))]);

% Insert latency sequence
latencyCh = (playChMapAll == latencyPlayCh);
excSequence(:, latencyCh) = 0; % Remove excitation from latency channel
excSequence(lengthPreSilence + 1:lengthPreSilence + length(latencySweep), latencyCh) = latencySweep;

% Allocate input/output buffers
sequenceLength = size(excSequence, 1);
bufExc = dsp.AsyncBuffer(sequenceLength + L);
bufRec = dsp.AsyncBuffer(sequenceLength + 2 * L);

% Write the excitation to the output buffer (including one extra frame of silence)
write(bufExc, excSequence);
write(bufExc, zeros(L, nbPlayChAll));

%% Play and capture using the selected device
disp('Recording...');

% Setup the capture device
apr = audioPlayerRecorder( ...
    fs, 'Device', device, ...
    'PlayerChannelMapping', playChMapAll, ...
    'RecorderChannelMapping', recChMapAll);
setup(apr, zeros(L, nbPlayChAll));

% Playback and capture loop
while bufExc.NumUnreadSamples > 0
    x = read(bufExc, L);
    [y, under, over] = apr(x);
    write(bufRec, y);
    if under > 0 || over > 0
        error('Underrun or overrun occurred, terminating measurement');
    end
end

% Release the audio device
release(apr);

%% Compute the results
disp('Computing results...');

% Get the recording from the input buffer
read(bufRec, L);
rec = read(bufRec);

% Compute the impulse response (removing latency channel)
recWithoutPauses = rec(recIdx, recChMapAll ~= latencyRecCh);
ir = impzest(exc, recWithoutPauses, 'WarmupRuns', nbWarmUps);
t_sec = (0:length(ir) - 1).' / fs; % Time vector

% Frequency and magnitude responses
nbPoints = 2 ^ 14;
IR = zeros(nbPoints, nbRecCh, 'like', complex(ir(1)));
for ii = 1:nbRecCh
    [IR(:, ii), f_Hz] = freqz(ir(:, ii), 1, nbPoints, fs);
end
IRdB = 20 * log10(max(abs(IR), realmin));

% Phase response
phase = unwrap(angle(IR));

%% Latency Calculation (from second script)
latencyIdx = (recChMapAll == latencyRecCh);
sweepRec = rec(lengthPreSilence + 1:lengthPreSilence + length(latencySweep), latencyIdx);

% Compute latency using cross-correlation
latency = computeLatency(latencySweep, sweepRec, L);

% Apply latency correction to the phase response
latency_data = latency - L;
phaseLatencyRemoved = phase + 2 * pi * latency_data * f_Hz / fs;
irLatencyRemoved = ir(latency_data + 1:end, :);
tSecLatencyRemoved = t_sec(1:end - latency_data);

% Create output structure
capture = struct(zeros(0, nbRecCh));
for ii = 1:nbRecCh
    capture(ii).ImpulseResponse.Time = t_sec;
    capture(ii).ImpulseResponse.Amplitude = ir(:, ii);
    capture(ii).MagnitudeResponse.MagnitudeDB = IRdB(:, ii);
    capture(ii).MagnitudeResponse.Frequency = f_Hz;
    capture(ii).PhaseResponse.Phase = phase(:, ii);
    capture(ii).PhaseResponse.Frequency = f_Hz;
    capture(ii).ImpulseResponse.TimeLatencyRemoved = tSecLatencyRemoved;
    capture(ii).ImpulseResponse.AmplitudeLatencyRemoved = irLatencyRemoved(:, ii);
    capture(ii).PhaseResponse.PhaseLatencyRemoved = phaseLatencyRemoved(:, ii);
    capture(ii).PhaseResponse.Frequency = f_Hz;
    capture(ii).Latency.Samples = latency;
    capture(ii).Latency.Seconds = latency / fs;
end

%% Display results
f = clf; % Clear and reuse figure
tl = tiledlayout(f, 2, 1);
title(tl, 'Impulse Response Measurement');
ax1 = plotTile(tl, tSecLatencyRemoved, irLatencyRemoved, [1 1], 'linear', 'Impulse Response', 'Amplitude', 'Time (s)');
plotTile(tl, f_Hz, IRdB, [1 1], 'log', 'Magnitude Response', 'Magnitude (dB)', 'Frequency (Hz)');
leg = legend(ax1, compose('Ch. %d', recChMap), 'Orientation', 'horizontal');
leg.Layout.Tile = 'south';


%% Plot one tile in the figure
function ax = plotTile(tile, x, y, tilespan, xScale, titlelbl, ylbl, xlbl)
    ax = nexttile(tile, tilespan);
    plot(ax, x, y);
    title(ax, titlelbl);
    ylabel(ax, ylbl);
    xlabel(ax, xlbl);
    ymin = min(y, [], 'all');
    ymax = max(y, [], 'all');
    yspan = ymax - ymin;
    ax.YLim = [ymin - 0.1 * yspan ymax + 0.1 * yspan];
    if strcmp(xScale, 'log')
        ax.XLim = [x(find(x > 0, 1)) x(end)];
        ax.XScale = 'log';
    else
        ax.XLim = [0 x(end)];
    end
end

%% Compute latency using a sweep recording (from second script)
function latency = computeLatency(latencySweep, sweepRec, L)
    xc = xcorr(latencySweep, sweepRec);
    Nx0 = (size(xc, 1) + 1) / 2;
    v = max(xc(1:Nx0));
    if v < 0.01 || v / rms(xc(1:Nx0)) < 10
        error('The sound level or SNR of the recording was too low. ' + ...
              'Verify that the loopback is connected to the selected channels and that any hardware gains are set correctly.');
    else
        loopIR = impzest(latencySweep, sweepRec);
        [~, loopIdx] = max(abs(loopIR));
        latency = loopIdx + L - 1;
    end
end
