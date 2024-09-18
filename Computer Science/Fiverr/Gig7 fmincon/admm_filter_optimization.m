function [xStar, fval, exitflag, output] = admm_filter_optimization(problem)

    % Initialization
    max_outer_iter = 100; % Maximum outer iterations
    max_inner_iter = 50;  % Maximum inner filter iterations
    rho = 1;              % Penalty parameter
    tol = 1e-6;           % Tolerance for convergence
    p = problem.num_blocks; % Number of blocks in the optimization problem
    x = problem.x0;        % Initial guess
    y = zeros(size(problem.A, 1), 1); % Dual variable (Lagrange multiplier)
    
    % Initialize filter
    filter = [];  % Store (eta, omega) pairs in filter
    penalty_factor = 1.1;  % Factor to increase penalty parameter

    for k = 1:max_outer_iter
        % Outer loop for ADMM and filter
        fprintf('Outer iteration: %d\n', k);
        filter_accepted = false;

        % Inner loop: filter iterations
        for j = 1:max_inner_iter
            % Block descent for each block i
            for i = 1:p
                % Optimize each block using fmincon
                x = minimize_block(x, y, rho, i, problem);
            end
            
            % Compute feasibility (eta) and first-order optimality error (omega)
            eta = compute_eta(x, problem);
            omega = compute_omega(x, y, rho, problem);
            
            % Check if (eta, omega) is acceptable to filter
            if is_filter_acceptable(eta, omega, filter)
                filter_accepted = true;
                break;
            end
        end
        
        if ~filter_accepted
            % Feasibility restoration step: update penalty and try again
            rho = rho * penalty_factor;
            fprintf('Feasibility restoration: increasing penalty to %.2f\n', rho);
        end
        
        % Check convergence
        if eta < tol && omega < tol
            fprintf('Converged at iteration %d\n', k);
            break;
        end
    end

    % Return the optimized solution
    x_opt = x;

    % Call fmincon one more time to get final objective function value, exit flag, and output details
    [xStar, fval, exitflag, output] = fmincon(@(x) objective(x, problem), x_opt, [], [], [], [], problem.lb, problem.ub, @(x) constraints(x, problem), problem.options);

    % Display the results
    disp('Optimal solution:');
    disp(xStar);

    disp('Objective function value at optimum:');
    disp(fval); % Ensure it's a scalar by summing the contributions

    disp('Exit flag:');
    %disp(exitflag);  % Display the exit flag correctly

    disp('Output details:');
    disp(output);  % Display output structure
end

% Function to minimize each block using fmincon
function x = minimize_block(x, y, rho, i, problem)
    options = optimoptions('fmincon');
    obj = @(xi) augmented_lagrangian(x, y, rho, i, problem);
    
    % Update only the i-th block
    x(i) = fmincon(obj, x(i), [], [], [], [], problem.lb(i), problem.ub(i), @(xi) constraints(xi, problem), options);
end

% Augmented Lagrangian for block i
function L = augmented_lagrangian(x, y, rho, i, problem)
    f = objective(x, problem); % Objective function
    c = problem.A*x(:) - problem.b; % Adjust x as column vector to ensure proper dimensions
    L = f + y'*c + (rho/2)*norm(c)^2;
end

% Feasibility function (eta)
function eta = compute_eta(x, problem)
    c = problem.A*x(:) - problem.b; % Ensure x is treated as a column vector
    eta = norm(c);
end

% Custom function to compute the gradient (omega)
function omega = compute_omega(x, y, rho, problem)
    % Gradient of the objective function
    grad_f = 2 * x(:);  % Gradient of sum(x.^2) is 2*x, ensure x is a column vector

    % Gradient of the constraint part of the augmented Lagrangian
    c = problem.A * x(:) - problem.b;  % Ensure c is a column vector
    grad_L_c = problem.A' * (y + rho * c);  % Ensure gradient dimensions match

    % Total gradient of the augmented Lagrangian
    grad_L = grad_f + grad_L_c;

    % Compute omega as the norm of the gradient
    omega = norm(grad_L);
end

% Filter acceptance criteria
function accept = is_filter_acceptable(eta, omega, filter)
    % Check if (eta, omega) dominates any existing filter entry
    accept = true;
    for k = 1:length(filter)
        if eta >= filter(k).eta && omega >= filter(k).omega
            accept = false;
            break;
        end
    end
end

% Define your objective function here
function f = objective(x, problem)
    % Example objective: simple quadratic
    f = sum(x.^2);  % Ensure this returns a single scalar
end

% Define constraints here, passing the problem struct as an input argument
function [c, ceq] = constraints(x, problem)
    ceq = problem.A*x(:) - problem.b; % Ensure x is treated as a column vector
    c = []; % No inequality constraints
end
