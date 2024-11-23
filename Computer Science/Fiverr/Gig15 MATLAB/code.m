clc;clear all;

% File paths (update with actual file locations)
files = {'HC380LA_500_1_1.txt', 'HC380LA_500_1_2.txt', 'HC380LA_500_1_3.txt'};

% Initial dimensions for the tests
t0 = [0.983333333, 1.004333333, 1.012666667]; % Thickness (mm)
b0 = [9.833333333, 9.76, 9.746666667]; % Width (mm)
A0 = t0 .* b0; % Cross-sectional areas for the tests

% Preallocate arrays for results
strain_data = {};
stress_data = {};

% Loop through each file and process the data
for i = 1:length(files)
    % Open the file
    fid = fopen(files{i}, 'r');
    if fid == -1
        error('Could not open file: %s', files{i});
    end
    
    % Read the file into a cell array, replacing commas with dots
    raw_lines = {};
    while ~feof(fid)
        line = fgetl(fid);
        if ischar(line)
            % Replace commas with dots for numerical parsing
            line = strrep(line, ',', '.');
            raw_lines{end+1} = line; 
        end
    end
    fclose(fid);

    % Skip the header line
    raw_lines(1) = [];

    % Parse numeric data
    data = [];
    for j = 1:length(raw_lines)
        row = sscanf(raw_lines{j}, '%f %f %f %f %f');
        if numel(row) == 5
            data = [data; row']; 
        end
    end

    % Extract relevant columns: ZwickWeg (displacement) and ZwickKraft (force)
    displacement = data(:, 2); % Assuming ZwickWeg is the 2nd column
    force = data(:, 3);        % Assuming ZwickKraft is the 3rd column

    % Calculate strain and stress
    strain = displacement / t0(i); % Strain = displacement / initial gauge length
    stress = force / A0(i);        % Stress = force / cross-sectional area

    % Store results
    strain_data{i} = strain;
    stress_data{i} = stress;
end

% Plot Stress-Strain Curves
figure;
hold on;
for i = 1:length(files)
    plot(strain_data{i}, stress_data{i}, 'LineWidth', 2, 'DisplayName', ['Speed = ', num2str(i)]);
end
hold off;

% Format Plot
title('Stress-Strain Curves at temperature = 500');
xlabel('Strain (\epsilon)');
ylabel('Stress (\sigma) [MPa]');
legend('Location', 'Best');
grid on;
