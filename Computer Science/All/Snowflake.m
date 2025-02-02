iter = 1;
for factor=0.01:0.01:1
% Main function to draw the snowflake
clf;
axis equal;
hold on;
axis off;

% Define parameters for the snowflake
numBranches = 6; % Six-fold symmetry
initialLength = 1; % Initial length of the branches
maxDepth = 9; % Maximum recursion depth

% Draw branches at different angles
for k = 0:numBranches - 1
    angle = k * (2 * pi / numBranches);
    drawBranch(0, 0, angle, initialLength, maxDepth, factor);
end

saveas(gcf,['Plot' num2str(iter) '.png']);
fclose('all');
pause(1);
iter = iter + 1;
end