%% Start
clear;
clc;

%% Device Settings
device      = "Scarlett 4i4 USB"; % Name of the audio device
fs          = 48000; % Sample rate (Hz)
L           = 1024;     % Samples per frame (number of samples)
overlap     = 256;      % Length of overlap (number of samples)
recChMap    = 1;        % Channel mapping for recording
playChMap   = 1;        % Channel mapping for playback
nbPlayCh    = 2;        % Total number of playback channels
nbRecCh     = 2;        % Total number of recording channels
cal_reference = 0.015;    % 15 mV/Pa manufacturer specification Behringer ECM8000 

%% Step 1: Generate simulated signals
fs = 48000; % Sample rate
duration = 4; % Duration for simulation
t = 0:1/fs:4; % Time vector
freq = 1000; % Frequency of sine wave
simulatedSignal =  sin(2 * pi * freq * t(:)) + 0.1; % Sine wave
nbRecCh = 2; % Number of recording channels
simulatedSignals = repmat(simulatedSignal, 1, nbRecCh); % 2-channel

%% Method Settings (Sine Sweep)
nbRunsTotal     = 2; % Number of runs and averages (sweeps)
durationPerRun  = 4; % Duration per run (s)
outputLevel     = -6; % Excitation level (dBFS)
sweepRange      = [20 20000]; % Sweep start/stop frequency (Hz)
sweepDur        = 3; % Sweep duration (s)
irDur           = durationPerRun - sweepDur; % Measurement duration of the impulse response after sweep end

%% Generation of the Measurement Signal
exc = sweeptone( ...
    sweepDur, irDur, fs, ...
    'ExcitationLevel', outputLevel, ...
    'SweepFrequencyRange', sweepRange);

% Normalize excitation signal
exc = exc / max(abs(exc)); % Ensure the excitation signal is normalized

% Add excitation repetitions
excSequence = repmat(exc, 1, nbPlayCh);

% Track which parts correspond to the excitation (all are excitation signals)
recIdx = true(size(excSequence, 1), 1);

% Assign input/output buffers
sequenceLength  = size(excSequence, 1);
bufExc = dsp.AsyncBuffer('Capacity', sequenceLength + L);
bufRec = dsp.AsyncBuffer('Capacity', sequenceLength + 2 * L);

% Copy the excitation into the output buffer
write(bufExc, excSequence);
write(bufExc, zeros(L, nbPlayCh));

%% Setup of the Recording Device
% apr = audioPlayerRecorder( ...
%     fs, 'Device', device, ...
%     'PlayerChannelMapping', playChMap, ...
%     'RecorderChannelMapping', recChMap);
% setup(apr, zeros(L, nbPlayCh));

% Memory for all recordings
allRecordings = zeros(sequenceLength, nbRecCh, nbRunsTotal);

for run = 1:nbRunsTotal
    % Playback and recording loop
%     while bufExc.NumUnreadSamples > 0
%         x = read(bufExc, L);
%         [y, under, over] = apr(x);
%         write(bufRec, y);
%         if under > 0 || over > 0
%             error("Underrun or Overrun occurred. Stopping measurement");
%         end
%     end

    % Read recording for all channels
%     read(bufRec, L); % Discard first frame to only use stable data
%     rec = read(bufRec);

    % Instead of recording, directly use simulated signals
    rec = simulatedSignals; % Use simulated signals as your recording


    % Ensure the recording has the expected length
    recLength = size(rec, 1);
    if recLength > sequenceLength
        rec = rec(1:sequenceLength, :); % Trim if too long
    elseif recLength < sequenceLength
        rec = [rec; zeros(sequenceLength - recLength, nbRecCh)];
    end

    % Save the current recording
    allRecordings(:, :, run) = rec;

    % Reset buffers for the next repetition
    reset(bufExc);
    reset(bufRec);
    write(bufExc, excSequence);
    write(bufExc, zeros(L, nbPlayCh));
end

% Release the audio device
% release(apr);

%% Averaging the Recordings
averageRecording = mean(allRecordings, 3);

% Remove pauses
recWithoutPauses = averageRecording(recIdx, :);

% Trim signals to the same length
minLength        = min(length(exc), length(recWithoutPauses));
exc              = exc(1:minLength, :);
recWithoutPauses = recWithoutPauses(1:minLength, :);

% Initialize latency arrays
latencySamples = zeros(nbRecCh, 1);
latencyTime = zeros(nbRecCh, 1);

% Loop through each channel
for ch = 1:nbRecCh
    latencySamples(ch) = computeLatency(exc(:, 1), recWithoutPauses(:, ch), L);
    latencyTime(ch) = latencySamples(ch) / fs;
end

% Correct the latency in the recordings for each channel
for ch = 1:nbRecCh
    if latencySamples(ch) > 0
        % Determine how much data is left after latency adjustment
        remainingLength = size(recWithoutPauses, 1) - latencySamples(ch);
        if remainingLength > 0
            % Adjust recWithoutPauses by removing the first latencySamples(ch) samples
            recWithoutPauses = recWithoutPauses(latencySamples(ch)+1:end, :);
            % Truncate exc to match the adjusted recWithoutPauses length
            exc = exc(1:min(size(recWithoutPauses, 1), size(exc, 1)), :);
        else
            error('Latency adjustment exceeds the available data length.');
        end
    elseif latencySamples(ch) < 0
        % Pad recWithoutPauses with zeros if latency is negative
        padding = zeros(-latencySamples(ch), size(recWithoutPauses, 2));  % Match column size
        recWithoutPauses = [padding; recWithoutPauses];  % Concatenate vertically

        % Ensure recWithoutPauses and exc have the same length
        recWithoutPauses = recWithoutPauses(1:minLength, :);
        exc = exc(1:min(size(recWithoutPauses, 1), size(exc, 1)), :);
    end
end

% Display latency time correctly
latencyTime = latencySamples / fs; % Assuming fs is the sampling frequency
disp(['Latency Time: ', num2str(latencyTime(ch)), ' seconds']);

% Calculate the impulse response of the recording
ir    = impzest(exc, recWithoutPauses);
t_sec = (0:length(ir) - 1).' / fs; % Time vector

% Apply calibration factor
ir_calibrated = zeros(length(ir), nbRecCh);
for ch = 1:nbRecCh
    ir_calibrated(:, ch) = impzest(exc(:, 1), recWithoutPauses(:, ch));
end

% Output setup
capture = struct(zeros(0, nbRecCh));
for ii  = 1:nbRecCh
    capture(ii).ImpulseResponse.Time = t_sec;
    capture(ii).ImpulseResponse.Amplitude = ir_calibrated(:, ii);
end

% Plot the Cross-Correlation Function for each channel
figure;
hold on;

for ch = 1:nbRecCh
    crossCorrelation = xcorr(recWithoutPauses(:, ch), exc(:, 1));
    normExc = norm(exc(:, 1));
    normRecWithoutPauses = norm(recWithoutPauses(:, ch));
    crossCorrelationNorm = crossCorrelation / (normExc * normRecWithoutPauses);
    
    % Change the X-axis to time instead of samples
    samplesDelay = -(length(exc(:, 1))-1):(length(exc(:, 1))-1);
    timeDelay = samplesDelay / fs;

    % Increase the resolution of the time axis through interpolation
    timeDelayHighRes = linspace(min(timeDelay), max(timeDelay), numel(timeDelay) * 10);
    crossCorrelationNormHighRes = interp1(timeDelay, crossCorrelationNorm, timeDelayHighRes, 'spline');
    
    plot(timeDelayHighRes, crossCorrelationNormHighRes, 'DisplayName', ['Channel ' num2str(ch)]);
end

xlabel('Time (s)');
ylabel('Correlation Degree');
title('Cross-Correlation Function for Multiple Channels');
xlim([-3, 3]);
legend show;
hold off;

% Plot the Impulse Response for each channel
figure;
hold on;

for ch = 1:nbRecCh
    plot(t_sec, ir_calibrated(:, ch), 'DisplayName', ['Channel ' num2str(ch)]);
end

xlabel('Time (s)');
ylabel('Amplitude');
title('Impulse Response for Multiple Channels');
xlim([0, 0.3]); % Limit the X-axis to 0 to 0.3 seconds
legend show;
hold off;

% Display latency time correctly
latencyTime = latencySamples / fs; % Assuming fs is the sampling frequency
disp(['Latency Time: ', num2str(latencyTime(ch)), ' seconds']);

%% Plot the Coherence

% Calculation of the coherence
% Loop through each channel to calculate coherence
for ch = 1:nbRecCh
    [pxx, F] = pwelch(exc(:, 1), [], [], [], fs);
    [pyy, ~] = pwelch(recWithoutPauses(:, ch), [], [], [], fs);
    [p, f]   = cpsd(exc(:, 1), recWithoutPauses(:, ch), [], [], [], fs);
    coherence(ch, :) = abs(p).^2 ./ (pxx .* pyy);
end

% Plot coherence for each channel
figure;
hold on;

for ch = 1:nbRecCh
    plot(f, coherence(ch, :), 'DisplayName', ['Channel ' num2str(ch)]);
end

xlabel('Frequency (Hz)');
ylabel('Coherence');
title('Coherence Function for Multiple Channels');
legend show;
xlim([0, 20000]); % Limit the x-axis
grid on;
hold off;

%% Calculation of the STFT for Campbell and Waterfall Diagrams
windowLength = 512; % Window length

% Set the window length and overlap length
nfft      = 2048; % FFT length
[S, F, T] = stft(ir_calibrated(:, 1), fs, 'Window', hamming(windowLength), ...
            'OverlapLength', overlap, 'FFTLength', nfft);

% Define frequency range from 20 Hz to 20000 Hz
freqRange   = F >= 20 & F <= 20000;
F_filtered  = F(freqRange);
S_filtered  = S(freqRange, :);

% Logarithmically scale frequency axis
F_log = logspace(log10(20), log10(20000), length(F_filtered));

% Interpolation on logarithmic frequency axis
S_log = interp1(F_filtered, abs(S_filtered), F_log, 'linear');

%% Schröder Backward Integration to Calculate the Reverberation Time (RT60)
% Normalize the impulse response
ir_norm = ir_calibrated(:, 1) / max(abs(ir_calibrated(:, 1)));

% Schröder backward integration
energyDecay = flipud(cumsum(flipud(ir_norm.^2)));

% Normalize the energy level to 0 dB
energyDecay_dB = 10 * log10(energyDecay / max(energyDecay));

%% Plot of the Schröder Backward Integration
figure;
plot(t_sec, energyDecay_dB);
xlabel('Time (s)');
ylabel('Energy Level (dB)');
title('Schröder Backward Integration');
grid on;

% Calculation of RT60
% Find the point where the level reaches -5 dB and -35 dB
t_5dB   = interp1(energyDecay_dB, t_sec, -5);
t_35dB  = interp1(energyDecay_dB, t_sec, -35);

% Calculate RT60 (time for a level to decay by 60 dB)
RT60 = t_35dB - t_5dB;

disp(['RT60: ', num2str(RT60), ' seconds']);

% Mark the -5 dB and -35 dB points on the plot
hold on;
plot(t_5dB, -5, 'ro', 'MarkerFaceColor', 'r');
plot(t_35dB, -35, 'ro', 'MarkerFaceColor', 'r');

% Draw a new line between the red points in dark green
plot([t_5dB, t_35dB], [-5, -35], 'Color', [0, 0.5, 0], ...
     'LineStyle', '--', 'LineWidth', 2);
legend('Energy Decay', '-5 dB Point', '-35 dB Point', 'New Line');
hold off;

%% Calculation of the Reverberation Time (RT60) for Octave Bands
octave_center_frequencies = [250, 500, 1000, 2000, 4000];
RT60_octave = zeros(size(octave_center_frequencies));
for i = 1:numel(octave_center_frequencies)
 
    % Bandpass filter for the octave frequency
    [b, a]  = butter(2, [octave_center_frequencies(i)/sqrt(2), ...
              octave_center_frequencies(i)*sqrt(2)] / (fs/2), 'bandpass');
    ir_band = filter(b, a, ir_calibrated);
 
    % Schröder backward integration for the bandpass-filtered signal
    ir_norm_band        = ir_band(:, 1) / max(abs(ir_band(:, 1)));
    energyDecay_band    = flipud(cumsum(flipud(ir_norm_band.^2)));
    energyDecay_dB_band = 10 * log10(energyDecay_band / max(energyDecay_band));
 
    % Ensure points are unique
    [energyDecay_dB_band, unique_idx] = unique(energyDecay_dB_band);
    t_sec_unique = t_sec(unique_idx);
 
    % Find the point where the level reaches -5 dB and -35 dB
    t_5dB_band  = interp1(energyDecay_dB_band, t_sec_unique, -5);
    t_35dB_band = interp1(energyDecay_dB_band, t_sec_unique, -35);
 
    % Calculate RT60 for the current octave band
    RT60_octave(i) = (t_35dB_band - t_5dB_band) * (60 / 30);
end
 
% Output the reverberation times for each octave
for i = 1:numel(octave_center_frequencies)
    fprintf('Reverberation Time (RT60) for %d Hz octave: %.2f seconds\n', ...
            octave_center_frequencies(i), RT60_octave(i));
end
 
% Plot of the Reverberation Time (RT60) for different octave bands
figure;
plot(octave_center_frequencies, RT60_octave, '-o');
set(gca, 'XScale', 'log');
xlabel('Frequency (Hz)');
ylabel('RT60 (s)');
title('Reverberation Time (RT60) for Octave Bands');
xticks(octave_center_frequencies);
grid on;
 
%% Campbell Diagram (Magnitude Spectrum)
figure;
 
% Plot the magnitude spectrum of the impulse response over time
imagesc(T, F_log, 20*log10(S_log));
set(gca, 'YScale', 'log');
axis xy;
colormap(jet);
colorbar;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Campbell Diagram of the Impulse Response');
% clim([-60, 0]);   % Limit the color scale to -60 to 0 dB
xlim([0, 0.9]);   % Limit the x-axis to 0.9 sec
ylim([50, 20000]); % Limit the y-axis (fu, fo, or Delta-f)
 
%% Waterfall Plot
figure;
 
% Plot the waterfall diagram of the impulse response with
% logarithmic frequency axis
waterfall(F_log, T, 20*log10(S_log)');
view(-45, 45);
colormap(jet);
colorbar;
xlabel('Frequency (Hz)');
ylabel('Time (s)');
zlabel('Amplitude (dB)');
title('Waterfall Diagram of the Impulse Response');
set(gca, 'XScale', 'log'); % Set logarithmic scaling for the frequency axis
xlim([20, 20000]); % Limit the x-axis (fu, fo, or Delta-f)
 
%% Plot of the Level-Time Course of the Reverberation Time
figure;
 
% Calculation of the energy level course of the impulse response
energyLevel_dB = 20 * log10(abs(ir_norm));
 
% Plotting the level-time course
plot(t_sec, energyLevel_dB, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Energy Level (dB)');
title('Level-Time Course of the Reverberation Time (RT60)');
grid on;
 
% Limit the x-axis to show the relevant range
xlim([0, max(t_sec)]);

% Define the computeLatency function
function latency = computeLatency(latencySweep, sweepRec, L)
    xc = xcorr(latencySweep, sweepRec);
    Nx0 = (size(xc, 1) + 1) / 2;
    v = max(xc(1:Nx0));
    
    % Print max correlation for debugging
    disp(['Max Correlation Value: ', num2str(v)]);
    
    % Adjust the threshold for testing
    if v < 0.01 || v / rms(xc(1:Nx0)) < 1 % Change 10 to 1 for testing
        error("The sound level or SNR of the recording was too low.");
    else
        loopIR = impzest(latencySweep, sweepRec);
        [~, loopIdx] = max(abs(loopIR));
        latency = loopIdx + L - 1;
    end
end
