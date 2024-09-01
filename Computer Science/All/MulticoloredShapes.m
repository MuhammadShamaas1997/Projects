hold on;

% Create the first polygon for the left half of the plot
x_left = [-1.5, 0, 0, -1.5]; % x coordinates for the left half
y_left = [-1.5, -1.5, 0, 0]; % y coordinates for the left half
fill(x_left, y_left, 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

% Create the first polygon for the left half of the plot
x_left = [-1.5, 0, 0, -1.5]; % x coordinates for the left half
y_left = [0, 0, 1.5, 1.5]; % y coordinates for the left half
fill(x_left, y_left, 'g', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

% Create the first polygon for the left half of the plot
x_left = [0, 1.5, 1.5, 0]; % x coordinates for the left half
y_left = [-1.5, -1.5, 0, 0]; % y coordinates for the left half
fill(x_left, y_left, 'b', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

% Create the first polygon for the left half of the plot
x_left = [0, 1.5, 1.5, 0]; % x coordinates for the left half
y_left = [0, 0, 1.5, 1.5]; % y coordinates for the left half
fill(x_left, y_left, 'k', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

% Set the axis limits
xlim([-1.5 1.5]);
ylim([-1.5 1.5]);

% Show grid
grid off;
axis off;
axis equal

t = linspace(0, 2*pi, 100); % Parameter t
x0=0;
y0=0;
xV=rand()/10;
yV=rand()/10;
for iter=1:120
    if (x0>0.5)
        xV = -xV;
        x0 = x0 - (x0-0.5);
    end
    if (x0<-0.5)
        xV = -xV;
        x0 = x0 - (x0+0.5);
    end
    if (y0>0.5)
        yV = -yV;
        y0 = y0 - (y0-0.5);
    end
    if (y0<-0.5)
        yV = -yV;
        y0 = y0 - (y0+0.5);
    end
    x = x0+cos(t);
    y = y0+sin(t);
    x0=x0+xV;
    y0=y0+yV;
    p = fill(x, y, 'k', 'FaceAlpha', 1, 'EdgeColor', 'none', 'LineWidth', 1);
    saveas(gcf,['Plot' num2str(iter) '.png']);
    fclose('all');
    pause(1);

    delete(p);
end