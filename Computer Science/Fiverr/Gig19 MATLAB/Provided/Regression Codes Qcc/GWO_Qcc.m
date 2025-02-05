% Grey Wolf Optimizer for Maximizing Qcc
function [Alpha_score, Alpha_pos, Convergence_curve] = GWO_Qcc(SearchAgents_no, Max_iter, lb, ub, dim, fobj)

    % Initialize alpha, beta, and delta positions and scores for maximization
    Alpha_pos = zeros(1, dim);
    Alpha_score = -inf; % Set to -inf for maximization problems

    Beta_pos = zeros(1, dim);
    Beta_score = -inf; % Set to -inf for maximization problems

    Delta_pos = zeros(1, dim);
    Delta_score = -inf; % Set to -inf for maximization problems

    % Initialize the positions of search agents
    Positions = initialization_Qcc(SearchAgents_no, dim, ub, lb);

    % Initialize convergence curve
    Convergence_curve = zeros(1, Max_iter);

    % Main optimization loop
    l = 0; % Loop counter

    while l < Max_iter
        for i = 1:size(Positions, 1)
            
            % Ensure search agents remain within boundaries
            Flag4ub = Positions(i, :) > ub;
            Flag4lb = Positions(i, :) < lb;
            Positions(i, :) = (Positions(i, :) .* (~(Flag4ub + Flag4lb))) + ub .* Flag4ub + lb .* Flag4lb;

            % Evaluate the fitness of the current search agent
            fitness = fobj(Positions(i, :));

            % Update Alpha, Beta, and Delta (for maximization)
            if fitness > Alpha_score
                Alpha_score = fitness; % Update alpha
                Alpha_pos = Positions(i, :);
            end

            if fitness < Alpha_score && fitness > Beta_score
                Beta_score = fitness; % Update beta
                Beta_pos = Positions(i, :);
            end

            if fitness < Beta_score && fitness > Delta_score
                Delta_score = fitness; % Update delta
                Delta_pos = Positions(i, :);
            end
        end

        % Update the control parameter "a", decreasing linearly from 2 to 0
        a = 2 - l * (2 / Max_iter);

        % Update the positions of search agents
        for i = 1:size(Positions, 1)
            for j = 1:size(Positions, 2)

                % Calculate position updates relative to Alpha, Beta, and Delta
                r1 = rand();
                r2 = rand();

                A1 = 2 * a * r1 - a; % Equation (3.3)
                C1 = 2 * r2; % Equation (3.4)

                D_alpha = abs(C1 * Alpha_pos(j) - Positions(i, j)); % Equation (3.5) - part 1
                X1 = Alpha_pos(j) - A1 * D_alpha; % Equation (3.6) - part 1

                r1 = rand();
                r2 = rand();

                A2 = 2 * a * r1 - a; % Equation (3.3)
                C2 = 2 * r2; % Equation (3.4)

                D_beta = abs(C2 * Beta_pos(j) - Positions(i, j)); % Equation (3.5) - part 2
                X2 = Beta_pos(j) - A2 * D_beta; % Equation (3.6) - part 2

                r1 = rand();
                r2 = rand();

                A3 = 2 * a * r1 - a; % Equation (3.3)
                C3 = 2 * r2; % Equation (3.4)

                D_delta = abs(C3 * Delta_pos(j) - Positions(i, j)); % Equation (3.5) - part 3
                X3 = Delta_pos(j) - A3 * D_delta; % Equation (3.6) - part 3

                % Update position based on the three leaders (Equation 3.7)
                Positions(i, j) = (X1 + X2 + X3) / 3;

            end
        end

        % Increment iteration counter
        l = l + 1;

        % Store the best fitness score at the current iteration
        Convergence_curve(l) = Alpha_score;
    end
end
%  % ENTER disp('Optimal @Cooling_Capacity (Alpha Score):');disp(Alpha_score);disp('Optimal Decision Variables (Alpha Position):');disp(Alpha_pos);