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
