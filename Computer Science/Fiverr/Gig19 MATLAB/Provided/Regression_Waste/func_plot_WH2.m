% Function to visualize maximum waste heat efficiency
function func_plot_WH2(func_name)
    % Load details of the waste heat efficiency function
    [lb, ub, dim, fobj] = Get_Functions_details_WH(func_name);

    % Validate that the function is suitable for 2D visualization
    if dim < 2
        error('Function must have at least 2 dimensions for 2D visualization.');
    end

    % Define x (e.g., T_hw_in) and y (e.g., T_cw_in) ranges within bounds
    x = linspace(lb(1), ub(1), 50); % Hot water inlet temperature
    y = linspace(lb(2), ub(2), 50); % Cold water inlet temperature

    % Initialize the function values for plotting
    f = zeros(length(x), length(y));

    % Calculate the function values for varying x and y while keeping others constant
    for i = 1:length(x)
        for j = 1:length(y)
            % Define a default vector with constant values for all variables
            vars = (lb + ub) / 2; % Use mid-point for constants
            vars(1) = x(i); % Set T_hw_in
            vars(2) = y(j); % Set T_cw_in

            % Evaluate the objective function
            f(i, j) = -fobj(vars); % Negate for maximization
        end
    end

    % Plot the surface
    figure;
    surfc(x, y, f, 'LineStyle', 'none'); % Surface plot without lines
    colormap jet; % Use a jet colormap for visualization
    title('Maximum Waste Heat Efficiency Visualization');
    xlabel('Hot Water Inlet Temp (T_{hw,in}) [°C]');
    ylabel('Cold Water Inlet Temp (T_{cw,in}) [°C]');
    zlabel('Waste Heat Efficiency');
    grid on;
end

% func_plot_WH('F_eta')