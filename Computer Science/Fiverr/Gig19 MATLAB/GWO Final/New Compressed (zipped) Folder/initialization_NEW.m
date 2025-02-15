% This function initializes the first population of search agents
function Positions = initialization_NEW(SearchAgents_no, dim, ub, lb)

    % Number of boundaries
    Boundary_no = size(ub, 2);

    % Pre-allocate positions for performance
    Positions = zeros(SearchAgents_no, dim);

    % If the boundaries of all variables are equal (single value for lb and ub)
    if Boundary_no == 1
        Positions = rand(SearchAgents_no, dim) .* (ub - lb) + lb;
    end

    % If each variable has a different lower and upper bound
    if Boundary_no > 1
        for i = 1:dim
            ub_i = ub(i); % Upper bound for variable i
            lb_i = lb(i); % Lower bound for variable i
            % Generate positions within the bounds for the current dimension
            Positions(:, i) = rand(SearchAgents_no, 1) .* (ub_i - lb_i) + lb_i;
        end
    end

    % Ensure the initial positions meet any additional constraints if needed
    % (Add constraints here if applicable for COP-specific conditions)
end
