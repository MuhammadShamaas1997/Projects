% Grey Wolf Optimizer (GWO) for Maximization Problems
function [Alpha_score, Alpha_pos, Convergence_curve] = GWO_WH(SearchAgents_no, Max_iter, lb, ub, dim, fobj)

    % Initialize alpha, beta, and delta positions and scores
    Alpha_pos = zeros(1, dim);
    Alpha_score = -inf; % Change to -inf for maximization

    Beta_pos = zeros(1, dim);
    Beta_score = -inf; % Change to -inf for maximization

    Delta_pos = zeros(1, dim);
    Delta_score = -inf; % Change to -inf for maximization

    % Initialize the positions of search agents
    Positions = initialization_WH(SearchAgents_no, dim, ub, lb);

    % Initialize convergence curve
    Convergence_curve = zeros(1, Max_iter);

    l = 0; % Loop counter

    % Main optimization loop
    while l < Max_iter
        for i = 1:size(Positions, 1)
            
            % Ensure search agents remain within boundaries
            Flag4ub = Positions(i, :) > ub;
            Flag4lb = Positions(i, :) < lb;
            Positions(i, :) = (Positions(i, :) .* ~(Flag4ub + Flag4lb)) + ub .* Flag4ub + lb .* Flag4lb;

            % Evaluate objective function for each search agent
            fitness = fobj(Positions(i, :));

            % Update Alpha, Beta, and Delta for maximization
            if fitness > Alpha_score
                Alpha_score = fitness; % Update Alpha
                Alpha_pos = Positions(i, :);
            elseif fitness < Alpha_score && fitness > Beta_score
                Beta_score = fitness; % Update Beta
                Beta_pos = Positions(i, :);
            elseif fitness < Beta_score && fitness > Delta_score
                Delta_score = fitness; % Update Delta
                Delta_pos = Positions(i, :);
            end
        end

        % Update parameter `a` linearly from 2 to 0
        a = 2 - l * (2 / Max_iter);

        % Update the position of search agents
        for i = 1:size(Positions, 1)
            for j = 1:size(Positions, 2)
                % Alpha Wolf Influence
                r1 = rand();
                r2 = rand();
                A1 = 2 * a * r1 - a; % Coefficient A
                C1 = 2 * r2;         % Coefficient C
                D_alpha = abs(C1 * Alpha_pos(j) - Positions(i, j));
                X1 = Alpha_pos(j) - A1 * D_alpha;

                % Beta Wolf Influence
                r1 = rand();
                r2 = rand();
                A2 = 2 * a * r1 - a;
                C2 = 2 * r2;
                D_beta = abs(C2 * Beta_pos(j) - Positions(i, j));
                X2 = Beta_pos(j) - A2 * D_beta;

                % Delta Wolf Influence
                r1 = rand();
                r2 = rand();
                A3 = 2 * a * r1 - a;
                C3 = 2 * r2;
                D_delta = abs(C3 * Delta_pos(j) - Positions(i, j));
                X3 = Delta_pos(j) - A3 * D_delta;

                % Update position using weighted average
                Positions(i, j) = (X1 + X2 + X3) / 3;
            end
        end

        % Update loop counter
        l = l + 1;

        % Record the best fitness value so far
        Convergence_curve(l) = Alpha_score;
    end
end
