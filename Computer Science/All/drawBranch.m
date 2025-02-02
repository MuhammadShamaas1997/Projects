function drawBranch(x, y, angle, length, depth, factor)
    % Recursive function to draw each branch of the snowflake
    if depth == 0
        return;
    end

    % Calculate end of branch
    xEnd = x + length * cos(angle);
    yEnd = y + length * sin(angle);

    % Draw the main line segment
    plot([x, xEnd], [y, yEnd], 'b', 'LineWidth', 5);

    % Set parameters for smaller branches
    newLength = length * factor; % Shrinking factor for each recursion level
    angleOffset = pi / 6; % Offset for branching, to add detail

    % Draw two new branches at symmetrical angles
    drawBranch(xEnd, yEnd, angle + angleOffset, newLength, depth - 1, factor);
    drawBranch(xEnd, yEnd, angle - angleOffset, newLength, depth - 1, factor);
end