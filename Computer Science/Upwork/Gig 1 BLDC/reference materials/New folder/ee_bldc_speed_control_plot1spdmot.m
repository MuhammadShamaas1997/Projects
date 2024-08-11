% Code to plot simulation results from ee_bldc_speed_control
%% Plot Description:
%
% The plot below shows the requested and measured speed for the
% test and the phase currents in the electric drive.

% Copyright 2017-2018 The MathWorks, Inc.

% Generate simulation results if they don't exist
if ~exist('simlog_ee_bldc_speed_control', 'var') || ...
        simlogNeedsUpdate(simlog_ee_bldc_speed_control, 'ee_bldc_speed_control') 
    sim('ee_bldc_speed_control')
    % Model StopFcn callback adds a timestamp to the Simscape simulation data log
end


% Reuse figure if it exists, else create new figure
if ~exist('h1_ee_bldc_speed_control', 'var') || ...
        ~isgraphics(h1_ee_bldc_speed_control, 'figure')
    h1_ee_bldc_speed_control = figure('Name', 'ee_bldc_speed_control');
end
figure(h1_ee_bldc_speed_control)
clf(h1_ee_bldc_speed_control)

% Get simulation results
simlog_t = simlog_ee_bldc_speed_control.BLDC.R.w.series.time;
simlog_wMot = simlog_ee_bldc_speed_control.BLDC.R.w.series.values('rpm');
simlog_wRef = logsout_ee_bldc_speed_control.get('speed_request');
simlog_iMot = simlog_ee_bldc_speed_control.Sensing_iabc.Current_Sensor.I.series.values('A');

% Plot results
simlog_handles(1) = subplot(2, 1, 1);
plot(simlog_t, simlog_wMot, 'LineWidth', 1)
hold on
plot(simlog_wRef.Values.Time, simlog_wRef.Values.Data, 'LineWidth', 1)
hold off
grid on
title('Motor Speed')
ylabel('Speed (RPM)')
legend({'Measured','Reference'},'Location','Best');

simlog_handles(2) = subplot(2, 1, 2);
plot(simlog_t, simlog_iMot(1:3:end))
hold on
plot(simlog_t, simlog_iMot(2:3:end))
plot(simlog_t, simlog_iMot(3:3:end))
hold off
grid on
title('Phase Currents')
ylabel('Current (A)')
xlabel('Time (s)')

linkaxes(simlog_handles, 'x')

% Remove temporary variables
clear simlog_t simlog_handles temp_colororder
clear simlog_wRef simlog_wMot simlog_iMot

% Function to check if simlog needs to be updated
function output = simlogNeedsUpdate(simlog, modelName)
    if ~simlog.hasTag('timestamp')
        output = true;
    else
        time_stamp = simlog.getTag('timestamp');
        if get_param(modelName,'RTWModifiedTimeStamp')==str2double(time_stamp{1,2})
            output = false;
        else
            output = true;
        end
    end
end

