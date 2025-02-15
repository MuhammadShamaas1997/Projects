% Function to plot the COP objective function with real values for non-plotted variables
function func_plot_NNEW(func_name)
    % Load function details
    [lb, ub, ~, fobj] = Get_Functions_details_NEW(func_name);

    % Define x and y ranges for plotting
    % Hot Water Inlet Temp (x-axis) and Cold Water Inlet Temp (y-axis)
    T_hw_in_range = lb(1):((ub(1) - lb(1)) / 50):ub(1);
    T_cw_in_range = lb(2):((ub(2) - lb(2)) / 50):ub(2);

    % Initialize the size of the function values matrix
    L = length(T_hw_in_range);
    Objective_values = zeros(L, L);

    % Use realistic fixed values for the remaining decision variables
    % Fixed values correspond to: 
    % [T_chw_in, m_hw, m_cw_bed, m_chw, m_cw_cond, Ubed_A_bed, Uevap_A_evap, Ucond_A_cond]
    fixed_values = [15, 9, 1.0, 1.0, 0.5, 5000, 5000, 15000];

    % Compute objective values for each pair of (T_hw_in, T_cw_in)
    for i = 1:L
        for j = 1:L
            % Combine the varying variables (T_hw_in, T_cw_in) with fixed values
            decision_vars = [T_hw_in_range(i), T_cw_in_range(j), fixed_values];
            Objective_values(i, j) = -fobj(decision_vars); % Negate for correct maximization visualization
        end
    end

    % Plot the surface of the COP function
    %figure;
    surfc(T_hw_in_range, T_cw_in_range, Objective_values, 'LineStyle', 'none');
    
    % Add title and labels with clear descriptions
    title([func_name ' Objective Function: Effect of Inlet Temperatures'], 'FontSize', 14, 'FontWeight', 'bold');
    xlabel('T_{hw,in} (Hot Water Inlet Temp)', 'FontSize', 12);
    ylabel('T_{cw,in} (Cold Water Inlet Temp)', 'FontSize', 12);
    zlabel(func_name, 'FontSize', 12);
    
    % Add colorbar for better interpretation of COP values
    colorbar;
    
    % Set view angle for better visualization
    view(120, 30);
    
    % Add grid for readability
    grid on;

    % Improve axis limits and scaling for better focus
    xlim([lb(1), ub(1)]);
    ylim([lb(2), ub(2)]);
end
% func_plot_NNEW('COP') then enter