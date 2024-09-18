clc;
clear all;
% Define the problem struct
problem.A = [1, 2, 3];          % Linear constraint coefficients
problem.b = 1;                  % Right-hand side of the constraint
problem.x0 = [0.5, 0.5, 0.5];   % Initial guess for x
problem.lb = [0, 0, 0];         % Lower bounds for x
problem.ub = [5, 5, 5];         % Upper bounds for x
problem.num_blocks = 3;         % Number of blocks (one for each variable x1, x2, x3)
problem.options = optimoptions('fmincon', 'Algorithm', 'active-set', 'Display', 'off'); % Optimization options

% Call the ADMM filter algorithm
[x_opt, fval, exitflag, output] = admm_filter_optimization(problem);

% Display the final results
disp('--- Test Results ---');
disp('Optimal solution:');
disp(x_opt);

disp('Objective function value at optimum:');
disp(fval);

disp('Exit flag:');
disp(exitflag);

disp('Output details:');
disp(output);
