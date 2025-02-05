% Function to visualize Waste Heat Efficiency and include optimal points
function func_plot_WH_with_optimal(func_name, optimal_point, max_efficiency)
    % Load details of the function (bounds, dimensions, objective function)
    [lb, ub, ~, fobj] = Get_Functions_details_WH(func_name);

    % Define the ranges for the two selected decision variables
    x1 = linspace(lb(1), ub(1), 50); % Hot Water Inlet Temp (T_hw,in)
    x2 = linspace(lb(2), ub(2), 50); % Cold Water Inlet Temp (T_cw,in)

    % Initialize a grid for plotting
    f = zeros(length(x1), length(x2));

    % Evaluate the function over the grid
    for i = 1:length(x1)
        for j = 1:length(x2)
            % Create input vector with midpoint values for other variables
            input_vars = (lb + ub) / 2; % Midpoint values for fixed variables
            input_vars(1) = x1(i); % Set T_hw,in (x-axis)
            input_vars(2) = x2(j); % Set T_cw,in (y-axis)
            f(i, j) = -fobj(input_vars); % Negate for maximization
        end
    end

    % Extract optimal point details
    optimal_T_hw_in = optimal_point(1); % Optimal Hot Water Inlet Temp
    optimal_T_cw_in = optimal_point(2); % Optimal Cold Water Inlet Temp
    optimal_efficiency = max_efficiency; % Corrected efficiency

    % Plot the surface
    figure;
    surfc(x1, x2, f, 'LineStyle', 'none'); % Surface plot with no line styles
    colormap jet; % Use a color map for better visualization
    hold on;

    % Highlight the optimal point
    plot3(optimal_T_hw_in, optimal_T_cw_in, optimal_efficiency, ...
          'ro', 'MarkerSize', 10, 'LineWidth', 2);
    text(optimal_T_hw_in, optimal_T_cw_in, optimal_efficiency, ...
         sprintf('\\eta_{waste}: %.4f\n(T_{hw,in}: %.2f°C, T_{cw,in}: %.2f°C)', ...
                 optimal_efficiency, optimal_T_hw_in, optimal_T_cw_in), ...
         'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', ...
         'FontSize', 12, 'FontWeight', 'bold', 'Color', 'red');

    % Add legend
    legend({'Waste Heat Efficiency Surface', 'Optimal Point'}, ...
        'Location', 'northeast', 'FontSize', 10);

    % Add titles and labels
    title('Waste Heat Efficiency (\eta_{waste}): Effect of Inlet Temperatures', ...
          'FontSize', 14, 'FontWeight', 'bold');
    xlabel('T_{cw,in} (Cold Water Inlet Temp) [°C]', 'FontSize', 12);
    ylabel('T_{hw,in} (Hot Water Inlet Temp) [°C]', 'FontSize', 12);
    zlabel('\eta_{waste} (Waste Heat Efficiency)', 'FontSize', 12);

    % Improve visualization
    grid on;
    colorbar;
    view(120, 30); % Set a nice viewing angle
    hold off;
end

% % Define optimal values from GWO
% Real_Pos = [65.195, 22.031, 10.02, 0.816, 0.816, 0.2004, 0.816, 10000, 10000, 10000];
% Maximum_Efficiency = 0.1237;

% Plot Waste Heat Efficiency Surface
% func_plot_WH_with_optimal('F_eta', Real_Pos, Maximum_Efficiency);
