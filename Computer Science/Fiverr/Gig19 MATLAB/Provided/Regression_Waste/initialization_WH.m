% This function initializes the first population of search agents
function Positions = initialization_WH(SearchAgents_no, dim, ub, lb)

    % Number of boundaries
    Boundary_no = size(ub, 2); 

    % Initialize Positions matrix
    Positions = zeros(SearchAgents_no, dim);

    % If the boundaries of all variables are equal and user enters a single
    % number for both `ub` and `lb`
    if Boundary_no == 1
        Positions = rand(SearchAgents_no, dim) .* (ub - lb) + lb;
    end

    % If each variable has a different lower bound (lb) and upper bound (ub)
    if Boundary_no > 1
        for i = 1:dim
            ub_i = ub(i);   % Upper bound for variable i
            lb_i = lb(i);   % Lower bound for variable i
            Positions(:, i) = rand(SearchAgents_no, 1) .* (ub_i - lb_i) + lb_i;
        end
    end
end
