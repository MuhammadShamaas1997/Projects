function ranks = RankingProcess(Archive_F, ArchiveMaxSize, obj_no)
    global my_min;
    global my_max;

    % Handle empty input
    if isempty(Archive_F)
        ranks = [];
        return;
    end

    % Update global min and max values
    if size(Archive_F, 1) == 1 && size(Archive_F, 2) == obj_no
        my_min = Archive_F;
        my_max = Archive_F;
    else
        my_min = min(Archive_F, [], 1);
        my_max = max(Archive_F, [], 1);
    end

    % Avoid division by zero by replacing zeros in range with eps
    range = my_max - my_min;
    range(range == 0) = eps;

    % Normalize objectives
    normalized_F = (Archive_F - my_min) ./ range;

    % Calculate Pareto dominance ranks
    numSolutions = size(Archive_F, 1);
    ranks = zeros(numSolutions, 1);

    for i = 1:numSolutions
        count = 0;
        for j = 1:numSolutions
            if i ~= j % Avoid self-comparison
                if all(normalized_F(j, :) <= normalized_F(i, :)) && any(normalized_F(j, :) < normalized_F(i, :))
                    count = count + 1;
                end
            end
        end
        ranks(i) = count + 1; % Higher count means lower rank
    end

    % Ensure archive does not exceed max size
    if numSolutions > ArchiveMaxSize
        [~, sorted_indices] = sort(ranks, 'ascend'); % Lower ranks are better
        ranks = ranks(sorted_indices(1:ArchiveMaxSize)); % Keep only best-ranked solutions
    end
end
