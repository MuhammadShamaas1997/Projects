hold on;
clc;
clear all;

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
xlim([-1 1]);
ylim([-1 1]);

% Show grid
grid off;
axis off;
axis equal

t = linspace(0, 2*pi, 100); % Parameter t
R = 0.3;
for i=1:3
    x0{i}=0;
    y0{i}=0;
    xV{i}=rand()/10-0.05;
    yV{i}=rand()/10-0.05;
    if (i==1)
    color{i} = [1 0 0];
    elseif (i==2)
    color{i} = [0 1 0];
    else 
    color{i} = [0 0 1];
    end
end
for iter=1:120
xlim([-1 1]);
ylim([-1 1]);
    for i=1:3
    if (x0{i}+R>1)
        xV{i} = -xV{i};
        x0{i} = x0{i} - (x0{i}+R-1);
    end
    if (x0{i}-R<-1)
        xV{i} = -xV{i};
        x0{i} = x0{i} - (x0{i}-R+1);
    end
    if (y0{i}+R>1)
        yV{i} = -yV{i};
        y0{i} = y0{i} - (y0{i}+R-1);
    end
    if (y0{i}-R<-1)
        yV{i} = -yV{i};
        y0{i} = y0{i} - (y0{i}-R+1);
    end
    x{i} = x0{i}+R*cos(t);
    y{i} = y0{i}+R*sin(t);
    x0{i}=x0{i}+xV{i};
    y0{i}=y0{i}+yV{i};
    p{i} = fill(x{i}, y{i}, color{i}, 'FaceAlpha', 0.3, 'EdgeColor', 'none', 'LineWidth', 1);
    saveas(gcf,['Plot' num2str(iter) '.png']);
    end
    fclose('all');
    pause(1);
    for i=1:3
        delete(p{i});
    end
end