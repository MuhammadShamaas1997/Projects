clc;clear all;

% File paths (update with actual file locations)
files = {'HC380LA_500_1_1.txt', 'HC380LA_500_1_2.txt', 'HC380LA_500_1_3.txt'};

% Initial dimensions for the tests
L0 = 20; % Initial Length (mm)
t0 = 1; % Thickness (mm)
w0 = 1; % Width (mm)
A0 = t0 .* w0; % Cross-sectional areas for the tests

% Preallocate arrays for results
strain_data = {};
stress_data = {};
real_strain_data = {};
real_stress_data = {};

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

    % Shift displacement to start at 0
%     displacement = displacement - displacement(1);
    
    % Calculate strain and stress
    strain = displacement / L0; % Strain = displacement / initial gauge length
    stress = force / A0;        % Stress = force / cross-sectional area

    % Ensure displacement starts from >= 0
    idx_displacement = find(displacement >= 0, 1)
    if ~isempty(idx_displacement)
        displacement = displacement(idx_displacement:end);
        strain = strain(idx_displacement:end);
        stress = stress(idx_displacement:end);
    end

    % Ensure the flow curve starts at the lower yield point
    % Define the lower yield point as the first noticeable stress increase
    idx_yield = find(diff(stress) > 0.0001, 1); % Change 0.1 based on your noise tolerance
    if ~isempty(idx_yield)
        strain = strain(idx_yield:end);
        stress = stress(idx_yield:end);
    end
    
    % Store results
    strain_data{i} = strain;
    stress_data{i} = stress;
    real_strain_data{i} = log(1+strain);
    real_stress_data{i} = stress .* (1+strain);
end

% Plot Stress-Strain Curves
figure;
hold on;
maxStress = 0;
for i = 1:length(files)
    maxStress = max(maxStress,max(stress_data{i}));
    plot(real_strain_data{i}, real_stress_data{i}, 'LineWidth', 2, 'DisplayName', ['Speed = ', num2str(i)]);
end
hold off;

% Format Plot
title('Real Stress-Strain Curves at temperature of 500');
xlabel('Real Strain (\epsilon)');
ylabel('Real Stress (\sigma) [MPa]');
legend('Location', 'Best');
ylim([0 5000]);
xlim([0.2 0.4]);
grid on;
