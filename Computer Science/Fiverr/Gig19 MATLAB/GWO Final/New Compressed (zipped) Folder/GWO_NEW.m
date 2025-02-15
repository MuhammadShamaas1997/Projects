% Customized Grey Wolf Optimizer
function [Alpha_score, Alpha_pos, Convergence_curve] = GWO_NEW(SearchAgents_no, Max_iter, lb, ub, dim, fobj)

    % Initialize Alpha, Beta, and Delta positions
    Alpha_pos = zeros(1, dim);
    Alpha_score = -inf; % For minimization problems; use -inf for maximization
    
    Beta_pos = zeros(1, dim);
    Beta_score = -inf;
    
    Delta_pos = zeros(1, dim);
    Delta_score = -inf;

    % Initialize the positions of search agents
    Positions = initialization_NEW(SearchAgents_no, dim, ub, lb);

    % Store convergence history
    Convergence_curve = zeros(1, Max_iter);

    l = 0; % Loop counter

    % Main optimization loop
    while l < Max_iter
        for i = 1:size(Positions, 1)

            % Bound the search agents to stay within variable limits
            Flag4ub = Positions(i, :) > ub;
            Flag4lb = Positions(i, :) < lb;
            Positions(i, :) = (Positions(i, :) .* ~(Flag4ub + Flag4lb)) + ub .* Flag4ub + lb .* Flag4lb;

            % Calculate the objective function value
            fitness = fobj(Positions(i, :));

            % Update Alpha, Beta, and Delta based on fitness
            if fitness > Alpha_score
                Alpha_score = fitness;
                Alpha_pos = Positions(i, :);
            end
            if fitness < Alpha_score && fitness > Beta_score
                Beta_score = fitness;
                Beta_pos = Positions(i, :);
                
            if fitness < Alpha_score && fitness < Beta_score && fitness > Delta_score
                Delta_score = fitness;
                Delta_pos = Positions(i, :);
            end
        end

        % Update the control parameter `a`, which decreases linearly from 2 to 0
        a = 2 - l * ((2) / Max_iter);

        % Update positions of search agents
        for i = 1:size(Positions, 1)
            for j = 1:dim
                % Calculate positions influenced by Alpha, Beta, and Delta wolves
                r1 = rand();
                r2 = rand();
                A1 = 2 * a * r1 - a;
                C1 = 2 * r2;

                D_alpha = abs(C1 * Alpha_pos(j) - Positions(i, j));
                X1 = Alpha_pos(j) - A1 * D_alpha;

                r1 = rand();
                r2 = rand();
                A2 = 2 * a * r1 - a;
                C2 = 2 * r2;

                D_beta = abs(C2 * Beta_pos(j) - Positions(i, j));
                X2 = Beta_pos(j) - A2 * D_beta;

                r1 = rand();
                r2 = rand();
                A3 = 2 * a * r1 - a;
                C3 = 2 * r2;

                D_delta = abs(C3 * Delta_pos(j) - Positions(i, j));
                X3 = Delta_pos(j) - A3 * D_delta;

                % Final position update using Equation (3.7)
                Positions(i, j) = (X1 + X2 + X3) / 3;
            end
        end

        % Increment loop counter and store convergence curve
        l = l + 1;
        Convergence_curve(l) = Alpha_score;
    end
end

 % ENTER disp('Optimal COP (Alpha Score):');disp(Alpha_score);disp('Optimal Decision Variables (Alpha Position):');disp(Alpha_pos);