function func_plot_WH_new(func_name, dim_x, dim_y)
    % Load bounds, dimensions, and objective function
    [lb, ub, dim, fobj] = Get_Functions_details_WH(func_name);

    % Check valid dimensions
    if dim_x > dim || dim_y > dim
        error('Invalid dimensions. Please check the variable mapping.');
    end

    % Variable mapping for labels
    variable_names = { ...
        'T_{hw,in} [°C]', ...
        'T_{cw,in} [°C]', ...
        'T_{chw,in} [°C]', ...
        'm_{hw} [kg/s]', ...
        'm_{chw} [kg/s]', ...
        'm_{cw,bed} [kg/s]', ...
        'm_{cw,cond} [kg/s]', ...
        'U_{bed}A_{bed} [W/K]', ...
        'U_{evap}A_{evap} [W/K]', ...
        'U_{cond}A_{cond} [W/K]' ...
    };

    % Define x and y ranges for the selected dimensions
    x = linspace(lb(dim_x), ub(dim_x), 50); % x-axis range
    y = linspace(lb(dim_y), ub(dim_y), 50); % y-axis range

    % Initialize the function value matrix
    f = zeros(length(x), length(y));

    % Fix all other dimensions to the middle of their range
    fixed_values = (lb + ub) / 2;

    % Compute function values
    for i = 1:length(x)
        for j = 1:length(y)
            input_values = fixed_values; % Start with fixed values
            input_values(dim_x) = x(i);
            input_values(dim_y) = y(j);
            f(i, j) = fobj(input_values);
        end
    end

    % Plot
    figure;
    surfc(x, y, f, 'LineStyle', 'none');
    colormap jet;
    title(['Waste Heat Efficiency: ', variable_names{dim_x}, ' vs ', variable_names{dim_y}], 'FontSize', 14, 'FontWeight', 'bold');
    xlabel(variable_names{dim_x}, 'FontSize', 12);
    ylabel(variable_names{dim_y}, 'FontSize', 12);
    zlabel('Waste Heat Efficiency (F_{eta})', 'FontSize', 12);
    grid on;
end

% func_plot_WH_new('F-eta', 1, 3);
% func_plot_WH_new('F-eta', 1, 2);
% func_plot_WH_new('F-eta', 1, 4);
% func_plot_WH_new('F-eta', 1, 5);