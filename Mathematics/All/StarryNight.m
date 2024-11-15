clc;
clear all;
% Create a new figure
fig = figure;
xlim([0 1])
ylim([0 1])

% Set the figure background color to white
set(fig, 'Color', [1, 1, 1]); 

% Create a new axes
ax = axes;

% Generate gradient data
[x, y] = meshgrid(linspace(0, 1, 100), linspace(0, 1, 100));
gradient_image = y; % Vertical gradient

% Display the gradient image
imagesc(gradient_image, 'Parent', ax);

% Set the colormap to the desired gradient colors
colormap(ax, [linspace(0, 1, 256)', linspace(0, 0, 256)', linspace(1, 1, 256)']); % Example: white to green

% Turn off the axis labels and ticks
set(ax, 'XTick', [], 'YTick', []);
axis off;

% Make sure the image fills the axes
set(ax, 'Layer', 'bottom', 'Color', 'none');
axis(ax, 'tight');

% Plot some data on top of the gradient background
hold on;
x = linspace(0, 2*pi, 100);
y = sin(x);
% plot(x, y, 'k', 'LineWidth', 2);

% Ensure the gradient is visible behind the plot
uistack(ax, 'bottom');


for num=1:100
    % Define the number of points for the star
    nPoints = 5;

    % Define the angles for the star points
    theta = linspace(0, 2*pi, 2*nPoints + 1);

    % Define the radii for the star points (alternating between outer and inner)
    outerRadius = 4*rand();
    innerRadius = .5;

    % Calculate the x and y coordinates for the star points
    x = zeros(1, 2*nPoints);
    y = zeros(1, 2*nPoints);

    x0 = 100*rand();
    y0 = 100*rand();
    
    for i = 1:2*nPoints
        if mod(i, 2) == 1
            r = outerRadius;
        else
            r = innerRadius;
        end
        x(i) = x0 + r * cos(theta(i));
        y(i) = y0 + r * sin(theta(i));
    end

    % Close the star shape
    x(end + 1) = x(1);
    y(end + 1) = y(1);

    % Plot the star shape
    fill(x, y, 'w','EdgeColor',[1 1 1]); 
    axis equal;
    saveas(gcf,['Plot' num2str(num) '.png'])
    pause(1);
end
