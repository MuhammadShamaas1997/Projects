function func_plot_with_optimal_Qcc(func_name, optimal_point, optimal_Qcc)
    % Load function details
    [lb, ub, ~, fobj] = Get_Functions_details_Qcc(func_name);

    % Define x and y ranges for plotting (e.g., T_hw_in vs T_cw_in)
    switch func_name 
        case 'Qcc'
            x = linspace(lb(1), ub(1), 50); % T_hw_in (Hot Water Inlet Temp)
            y = linspace(lb(2), ub(2), 50); % T_cw_in (Cold Water Inlet Temp)
        otherwise
            error('Invalid function name. Use ''Qcc'' to plot Cooling Capacity.');
    end    

    % Initialize function values matrix
    L = length(x);
    f = zeros(L, L);

    % Calculate Qcc values for plotting
    for i = 1:L
        for j = 1:L
            real_vars = [x(i), y(j), optimal_point(3:end)]; % Use optimal values for other variables
            f(i, j) = fobj(real_vars);
        end
    end

    % Plot the function surface
    figure;
    surfc(x, y, f, 'LineStyle', 'none');
    title('Cooling Capacity (Q_{cc}): Effect of Inlet Temperatures', 'FontSize', 14, 'FontWeight', 'bold');
    xlabel('T_{hw,in} (Hot Water Inlet Temp) [°C]', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('T_{cw,in} (Cold Water Inlet Temp) [°C]', 'FontSize', 12, 'FontWeight', 'bold');
    zlabel('Cooling Capacity (Q_{cc}) [kW]', 'FontSize', 12, 'FontWeight', 'bold');
    colorbar;
    c = colorbar;
    c.Label.String = 'Cooling Capacity (Q_{cc}) [kW]';
    c.Label.FontSize = 12;
    view(135, 35); % Adjust view angle
    grid on;
    hold on;

    % Overlay the optimal point
    plot3(optimal_point(1), optimal_point(2), optimal_Qcc, 'ro', 'MarkerSize', 12, 'MarkerFaceColor', 'r');

    % Add a text label for the optimal Qcc
    text(optimal_point(1), optimal_point(2), optimal_Qcc, ...
         ['Q_{cc}: ', num2str(optimal_Qcc, '%.2f'), ' kW'], ...
         'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', 'FontSize', 10, 'Color', 'r');

    % Add legend
    legend('Cooling Capacity Surface', 'Optimal Point', 'Location', 'northwest', 'FontSize', 10);

    % Make plot interactive
    hold off;
end

% optimal_point = [95, 22, 20, 12, 2.2, 2.2, 1.4, 10000, 10000, 10000]; % Replaced with actual optimal points
% optimal_COP = 0.5755; % Replaced with actual optimal COP 
% func_plot_with_optimal('COP', optimal_point, optimal_COP);