% % Define bounds
% lb = [65, 22, 10, 0.8, 0.8, 0.2, 0.8, 2000, 2000, 2000];
% ub = [95, 36, 20, 2.2, 2.2, 1.4, 2.2, 10000, 10000, 10000];
% 
% % Select two key variables to vary (e.g., x1 and x2)
% num_points = 100; % Number of points per variable
% x1_range = linspace(lb(1), ub(1), num_points); % Vary x1
% x2_range = linspace(lb(2), ub(2), num_points); % Vary x2
% x3_range = linspace(lb(3), ub(3), num_points); % Vary x3
% x4_range = linspace(lb(4), ub(4), num_points); % Vary x4
% x5_range = linspace(lb(5), ub(5), num_points); % Vary x5
% x6_range = linspace(lb(6), ub(6), num_points); % Vary x6
% x7_range = linspace(lb(7), ub(7), num_points); % Vary x7
% x8_range = linspace(lb(8), ub(8), num_points); % Vary x8
% x9_range = linspace(lb(9), ub(9), num_points); % Vary x9
% x10_range = linspace(lb(10), ub(10), num_points); % Vary x10
% [X1, X2] = meshgrid(x1_range, x2_range); % Create 2D grid
% [X3, X4] = meshgrid(x3_range, x4_range); % Create 2D grid
% [X5, X6] = meshgrid(x5_range, x6_range); % Create 2D grid
% [X7, X8] = meshgrid(x7_range, x8_range); % Create 2D grid
% [X9, X10] = meshgrid(x9_range, x10_range); % Create 2D grid
% 
% % Fix the other 8 variables at their mean values
% x_fixed = (ub);
% 
% % Initialize output matrices for Y1, Y2, Y3
% Y1 = zeros(size(X1));
% Y2 = zeros(size(X1));
% Y3 = zeros(size(X1));
% 
% % Compute Y1, Y2, Y3 for each (X1, X2) combination
% for i = 1:numel(X1)
%     x_temp = x_fixed;  % Use fixed values for other variables
%     x_temp(1) = X1(i); % Vary x1
%     x_temp(2) = X2(i); % Vary x2
%     x_temp(3) = X3(i); % Vary x3
%     x_temp(4) = X4(i); % Vary x4
%     x_temp(5) = X5(i); % Vary x5
%     x_temp(6) = X6(i); % Vary x6
%     x_temp(7) = X7(i); % Vary x8
%     x_temp(8) = X8(i); % Vary x8
%     x_temp(9) = X9(i); % Vary x9
%     x_temp(10) = X10(i); % Vary x10
%     y = UF1(x_temp);
%     Y1(i) = y(1);
%     Y2(i) = y(2);
%     Y3(i) = y(3);
% end
% 
% % Plot Surface: y(1) vs y(2) vs y(3)
% %figure;
% surf(Y1, Y2, Y3, 'EdgeColor', 'none'); % Smooth surface
% grid on;



% Number of samples
num_samples = 5000;

% Generate random values of x within the bounds
X = rand(num_samples, 10) .* (ub - lb) + lb;

% Evaluate the function UF1 for all samples
Y = zeros(num_samples, 3);
for i = 1:num_samples
    Y(i, :) = UF1(X(i, :));
end

% Compute the convex hull
K = convhull(Y(:,1), Y(:,2), Y(:,3));

% Plot the convex hull as an outer surface
trisurf(K, Y(:,1), Y(:,2), Y(:,3), 'FaceColor', 'red', 'EdgeColor', 'none', 'FaceAlpha', 0.5);

% Scatter the original points for reference
% scatter3(Y(:,1), Y(:,2), Y(:,3), 5, Y(:,3), 'filled');