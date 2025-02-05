% Customized GWO Implementation for Waste Heat Recovery Efficiency Maximization
clear;
clc;

% Define problem parameters
SearchAgents_no = 30; % Number of search agents
Max_iteration = 5000;  % Maximum number of iterations

% Define problem-specific details
dim = 10; % Number of decision variables
lb = [65, 22, 10, 0.8, 0.8, 0.2, 0.8, 2000, 2000, 10000]; % Lower bounds
ub = [95, 36, 20, 2.2, 2.2, 1.4, 2.2, 10000, 10000, 10000]; % Upper bounds

% Define objective function (maximize waste heat recovery efficiency)
fobj = @F_eta;

% Run the Grey Wolf Optimizer
[Best_score, Best_pos, GWO_cg_curve] = GWO_WH(SearchAgents_no, Max_iteration, lb, ub, dim, fobj);

% Convert results for maximization
Maximized_score = -Best_score; % Convert back to positive value
Real_pos = lb + Best_pos .* (ub - lb); % Scale Best_pos to real-world values

% Plot the convergence curve
figure('Position', [500 500 660 290]);
semilogy(-GWO_cg_curve, 'Color', 'r', 'LineWidth', 2); % Convert to positive values
title('Convergence Curve (Maximization)', 'FontSize', 14);
xlabel('Iteration', 'FontSize', 12);
ylabel('Best Score Obtained So Far', 'FontSize', 12);
axis tight;
grid on;
box on;

% Display results
disp('The best solution (real-world values) obtained by GWO is:');
disp(Real_pos);
disp('The maximum efficiency value found by GWO is:');
disp(Maximized_score);

% Plot Waste Heat Efficiency Surface
func_plot_WH_with_optimal('F_eta', Real_pos, Maximized_score);
