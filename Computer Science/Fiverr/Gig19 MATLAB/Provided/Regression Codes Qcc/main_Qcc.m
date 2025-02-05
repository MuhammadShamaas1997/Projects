% Clear and Initialize
clc;
clear;

% Parameters
SearchAgents_no = 30; % Number of search agents
Function_name = 'Qcc'; % Function to optimize
Max_iteration = 20000; % Maximum number of iterations

% Load function details
[lb, ub, dim, fobj] = Get_Functions_details_Qcc(Function_name);

% Run GWO
[Best_score, Best_pos, GWO_cg_curve] = GWO_Qcc(SearchAgents_no, Max_iteration, lb, ub, dim, fobj);

% Display Results
disp(['The best solution obtained by GWO is : ', num2str(Best_pos)]);
disp(['The best optimal value of the objective function found by GWO is : ', num2str(Best_score)]);

% Visualization
figure('Position', [500 500 660 290]);

% Convergence Curve Plot
figure;
plot(GWO_cg_curve, 'Color', 'r', 'LineWidth', 2);
title('Convergence Curve');
xlabel('Iteration');
ylabel('Best Score (Cooling Capacity)');
grid on;
box on;

% Add and manually position the legend
lgd = legend('GWO'); % Add legend
lgd.Location = 'northeast'; % Set general location inside the plot
lgd.Position = [0.75, 0.78, 0.1, 0.1]; % Fine-tune [x, y, width, height] to move it slightly down
