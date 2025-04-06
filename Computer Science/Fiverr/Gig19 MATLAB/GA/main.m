% main.m
% Multi-objective Genetic Algorithm Optimization with 3 Linear Objectives

% Number of decision variables
nvars = 10;

% Lower and upper bounds for variables
lb =  [65, 22, 10, 0.8, 0.8, 0.2, 0.8, 2000, 2000, 10000]; % Lower bounds
ub = [95, 36, 20, 2.2, 2.2, 1.4, 2.2, 10000, 10000, 24000]; % Upper bounds

% Define optimization options
options = optimoptions('gamultiobj', ...
    'PopulationSize', 100, ...
    'UseParallel', false, ...
    'Display', 'iter', ...
    'PlotFcn', {@gaplotpareto});

% Run genetic algorithm to solve the problem
[x, fval, exitflag, output, population, scores] = gamultiobj(@myObjectives, ...
    nvars, [], [], [], [], lb, ub, options);

% Plot the Pareto front (3D)
figure;
paretoplot(fval);
xlabel('Objective 1');
ylabel('Objective 2');
zlabel('Objective 3');
title('Pareto Front of Three Objectives');

% Display sample Pareto-optimal solution
disp('Sample solution (decision variables):');
disp(x(1,:));
disp('Corresponding objective values:');
disp(fval(1,:));

% Optionally inspect optimization values
optvals = OptimizationValues;
disp(optimvalues(optvals));

function f = myObjectives(x)
    % Coefficients for each linear objective
    A = [0.0014 -0.0085 0.0124 0.0050 0.0099 0.0793 0.0092 (5.0687e-6) (5.2952e-6) (4.6260e-7);
    0.3107 -0.8625 0.7601 0.6108 0.9944 4.4533 0.5967 0.0006 0.0003 (2.6623e-5);
    -0.0003 -0.0019 0.0026 0.0277 0.0034 0.0150 0.0019 (2.0286e-6) (1.0279e-6) (6.8084e-8)]

    % Constant offsets for each objective
    b = [-1.1469 ; -64.6199; -0.2347]; 

    % Compute the linear objectives + constant terms
    f = A * x(:) + b;
end