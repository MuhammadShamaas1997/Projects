function plot_all_decision_variables_Qcc(func_name)
    % Load bounds, dimensions, and objective function
    [lb, ub, dim, fobj] = Get_Functions_details_Qcc(func_name);

    % Ensure at least 2 dimensions are available
    if dim < 2
        error('At least 2 dimensions are required for visualization.');
    end

    % Total number of combinations of two variables
    num_plots = nchoosek(dim, 2);

    % Initialize figure with larger size
    figure('Position', [100, 100, 1400, 800]); % [left, bottom, width, height]
    plot_idx = 1; % Subplot index

    % Generate all combinations of dimensions
    combos = nchoosek(1:dim, 2);

    % Iterate through each pair of dimensions
    for k = 1:size(combos, 1)
        dim_x = combos(k, 1); % First dimension
        dim_y = combos(k, 2); % Second dimension

        % Fix all other dimensions to the middle of their range
        fixed_values = (lb + ub) / 2;

        % Define x and y ranges for the selected dimensions
        x = linspace(lb(dim_x), ub(dim_x), 50); % x-axis range
        y = linspace(lb(dim_y), ub(dim_y), 50); % y-axis range

        % Initialize the function value matrix
        f = zeros(length(x), length(y));

        % Compute function values for the selected dimensions
        for i = 1:length(x)
            for j = 1:length(y)
                % Assign x and y values to the selected dimensions
                input_values = fixed_values; % Start with fixed values for all variables
                input_values(dim_x) = x(i); % Assign the current x value
                input_values(dim_y) = y(j); % Assign the current y value

                % Evaluate the function for the current input values
                f(i, j) = fobj(input_values);
            end
        end

        % Plot the function as a surface in a subplot
        num_cols = 3; % Number of subplots per row
        num_rows = ceil(num_plots / num_cols); % Number of rows
        subplot(num_rows, num_cols, plot_idx);
        surfc(x, y, f, 'LineStyle', 'none'); % Surface plot without grid lines
        colormap jet; % Use a colorful colormap

        % Add plot labels and title
        title(['Dim ', num2str(dim_x), ' vs Dim ', num2str(dim_y)], 'FontSize', 10);
        xlabel(['Dim ', num2str(dim_x)], 'FontSize', 8);
        ylabel(['Dim ', num2str(dim_y)], 'FontSize', 8);
        zlabel('Cooling Capacity (Qcc)', 'FontSize', 8);
        grid on; % Enable grid

        % Increment subplot index
        plot_idx = plot_idx + 1;
    end

    % Add a title for the whole figure
    sgtitle('All Decision Variables vs Each Other (with Qcc as Output)', 'FontSize', 14, 'FontWeight', 'bold');
end
% plot_all_decision_variables_Qcc('Qcc');
