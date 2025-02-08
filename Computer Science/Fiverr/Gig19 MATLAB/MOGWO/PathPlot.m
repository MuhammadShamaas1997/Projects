% Extract x, y, and z from Archive_costs
% x = Archive_costs(1, :);
% y = Archive_costs(2, :);
% z = Archive_costs(3, :);

% Extract x, y, and z from the Cost field
x = arrayfun(@(g) g.Best.Cost(1), GreyWolves);
y = arrayfun(@(g) g.Best.Cost(2), GreyWolves);
z = arrayfun(@(g) g.Best.Cost(3), GreyWolves);

% Create a 3D line plot
figure
plot3(x, y, z, '-ok', 'LineWidth', 1.5, 'MarkerSize', 6);

% Set axis limits
% xlim([min(x) max(x)]);
% ylim([min(y) max(y)]);
% zlim([min(z) max(z)]);

% Add labels and title
xlabel('COP');
ylabel('Q_c_c');
zlabel('\eta_e');
title('Pareto Surface');

% Enable grid for better visualization
grid on;
hold on;
ParetoSurfacePlot;
