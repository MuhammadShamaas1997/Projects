% Function to draw the visualization of maximum waste heat efficiency
function func_plot_WH(func_name)
    % Load details of the function (bounds, dimensions, objective function)
    [lb, ub, dim, fobj] = Get_Functions_details_WH(func_name);

    % Validate that the function is 2D (for plotting purposes)
    if dim < 2
        error('Function must have at least 2 dimensions for visualization.');
    end

    % Select the first two decision variables for visualization
    x1 = linspace(lb(1), ub(1), 50); % Define 50 points for the first variable
    x2 = linspace(lb(2), ub(2), 50); % Define 50 points for the second variable

    % Initialize a grid for plotting
    f = zeros(length(x1), length(x2));

    % Evaluate the function over the grid
    for i = 1:length(x1)
        for j = 1:length(x2)
            input_vars = lb; % Initialize input vector with default lower bounds
            input_vars(1) = x1(i); % Set the first variable
            input_vars(2) = x2(j); % Set the second variable
            f(i, j) = -fobj(input_vars); % Negate for maximization
        end
    end

    % Plot the surface
    figure;
    surfc(x1, x2, f, 'LineStyle', 'none'); % Surface plot with no line styles
    colormap jet; % Use a color map for better visualization
    title(['Waste Heat Efficiency Function: ', func_name]);
    xlabel('Variable 1 (e.g., T_{hw,in})');
    ylabel('Variable 2 (e.g., T_{cw,in})');
    zlabel('Efficiency (Maximized)');
    grid on;
end
% func_plot_WH('F_eta')