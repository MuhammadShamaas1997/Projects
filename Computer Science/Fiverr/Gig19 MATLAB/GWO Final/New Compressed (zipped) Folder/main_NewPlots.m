% To run GWO: [Best_score, Best_pos, GWO_cg_curve] = GWO_NEW(SearchAgents_no, Max_iteration, lb, ub, dim, fobj)
%__________________________________________

clc;
clear all;

% Parameters
SearchAgents_no = 30; % Number of search agents
Max_iteration = 50; % Maximum number of iterations

% Load objective function details
Function_name = 'COP'; % Specify function name for optimization (COP, Qcc or Eta_e)
[lb, ub, dim, fobj] = Get_Functions_details_NEW(Function_name); % Load bounds and objective function

% Run GWO
[Best_score, Best_pos, GWO_cg_curve] = GWO_NEW(SearchAgents_no, Max_iteration, lb, ub, dim, fobj);

% Define x, y, and z values for the new plot
T_hw_in = linspace(lb(1), ub(1), 50); % Hot Water Inlet Temp
T_cw_in = linspace(lb(2), ub(2), 50); % Cold Water Inlet Temp
[T_cw_in_grid, T_hw_in_grid] = meshgrid(T_cw_in, T_hw_in);
T_chw_in = Best_pos(3); % Fixed to the optimal chilled water inlet temp
m_hw = Best_pos(4); % Fixed to the optimal hot water flow rate
m_cw_bed = Best_pos(5); % Fixed to the optimal cooling water flow rate (bed)
m_chw = Best_pos(6); % Fixed to the optimal chilled water flow rate
m_cw_cond = Best_pos(7); % Fixed to the optimal cooling water flow rate (condenser)
Ubed_A_bed = Best_pos(8); % Fixed to the optimal bed heat transfer product
Uevap_A_evap = Best_pos(9); % Fixed to the optimal evaporator heat transfer product
Ucond_A_cond = Best_pos(10); % Fixed to the optimal condenser heat transfer product

% Compute objective values for the surface plot
Objective_values = arrayfun(@(t_hw, t_cw) fobj([t_hw, t_cw, T_chw_in, m_hw, m_cw_bed, m_chw, m_cw_cond, Ubed_A_bed, Uevap_A_evap, Ucond_A_cond]), ...
    T_hw_in_grid, T_cw_in_grid);

% Plotting results
figure('Position', [500, 500, 800, 400]);

% Plot parameter space (with new surface visualization)
subplot(1, 2, 1);
func_plot_NNEW(Function_name);
%surfc(T_cw_in_grid, T_hw_in_grid, Objective_values, 'LineStyle', 'none');
colorbar;
title([Function_name ' Objective Function: Effect of T_{hw,in} and T_{cw,in}']);
xlabel('T_{cw,in} (Cold Water Inlet Temp)');
ylabel('T_{hw,in} (Hot Water Inlet Temp)');
zlabel(Function_name);
hold on;
plot3(Best_pos(2), Best_pos(1), Best_score, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % Optimal point
text(Best_pos(2), Best_pos(1), Best_score, sprintf(Function_name, Best_score), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'r');
grid on;

% Plot objective space (unchanged)
subplot(1, 2, 2);
plot(GWO_cg_curve, 'r-', 'LineWidth', 1.5);
title(['Best ' Function_name ' Value Over Iterations']);
xlabel('Number of Iterations');
ylabel(['Best ' Function_name ' Value (Maximization)']);
grid on;
box on;
legend('GWO');

% Display results
disp('Optimization Results:');
disp([['Optimal ' Function_name ' (Alpha Score): '], num2str(Best_score)]);
disp(['Optimal Decision Variables (Alpha Position): ', num2str(Best_pos)]);