function newLoc = Mutate(loc, pm, VarMin, VarMax)
    % Apply mutation to a given location
    nVar = numel(loc);  
    j = randi([1 nVar]); % Select a random variable to mutate
    delta = pm * (VarMax(j) - VarMin(j)); % Mutation range
    newLoc = loc;  
    newLoc(j) = loc(j) + delta * (randn()); % Apply mutation  
    newLoc = max(newLoc, VarMin); % Ensure within lower bound  
    newLoc = min(newLoc, VarMax); % Ensure within upper bound  
end
