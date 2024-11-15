% Bubble subdivision when hitting a wall
clc;
clear;
close all;

% Square boundaries
square_size = 10;
xlim([-square_size square_size]);
ylim([-square_size square_size]);

% Initial conditions for a single bubble
bubbles = struct();
bubbles(1).pos = [0, 0]; % Initial position
bubbles(1).vel = [1, 1]; % Initial velocity
bubbles(1).radius = 4;   % Initial radius

% Time settings
dt = 0.5;               % Time step
num_steps = 500;         % Number of simulation steps

figure;
axis equal;
hold on;
xlim([-square_size, square_size]);
ylim([-square_size, square_size]);
grid off;
axis off;


for step = 1:num_steps
    clf;
    xlim([-square_size square_size]);
    ylim([-square_size square_size]);
    grid off;
    axis off;
    
    % Loop over all bubbles
    for i = 1:length(bubbles)
        % Update positions
        bubbles(i).pos = bubbles(i).pos + bubbles(i).vel * dt;

        % Check for collisions with the walls
        if bubbles(i).pos(1) + bubbles(i).radius >= square_size || bubbles(i).pos(1) - bubbles(i).radius <= -square_size
            if bubbles(i).pos(1) + bubbles(i).radius >= square_size
            bubbles(i).pos(1) = bubbles(i).pos(1) - (bubbles(i).pos(1)+ bubbles(i).radius - square_size);
            end
            if bubbles(i).pos(1) - bubbles(i).radius <= -square_size
                bubbles(i).pos(1) = bubbles(i).pos(1) - (bubbles(i).pos(1) - bubbles(i).radius + square_size);
            end
            bubbles(i).vel(1) = -bubbles(i).vel(1); % Reverse x velocity
            bubbles(i).pos(2) = bubbles(i).pos(2)-rand();
            
            % Subdivide bubble if collision happens
            new_bubble = bubbles(i);
            new_bubble.vel(1) = new_bubble.vel(1); % Mirror velocity
            new_bubble.pos(2) = bubbles(i).pos(2)+rand();
            new_bubble.radius = bubbles(i).radius / 1.1;
            bubbles(i).radius = new_bubble.radius;  % Halve the original bubble size

            % Add the new bubble to the array
            bubbles(end+1) = new_bubble;
        end

        if bubbles(i).pos(2) + bubbles(i).radius >= square_size || bubbles(i).pos(2) - bubbles(i).radius <= -square_size
            bubbles(i).vel(2) = -bubbles(i).vel(2); % Reverse y velocity
            if bubbles(i).pos(2) + bubbles(i).radius >= square_size
            bubbles(i).pos(2) = bubbles(i).pos(2) - (bubbles(i).pos(2) + bubbles(i).radius - square_size);
            end
            if bubbles(i).pos(2) - bubbles(i).radius <= -square_size
                bubbles(i).pos(2) = bubbles(i).pos(2) - (bubbles(i).pos(2) - bubbles(i).radius + square_size);
            end
            bubbles(i).pos(1) = bubbles(i).pos(1)-rand();

            % Subdivide bubble if collision happens
            new_bubble = bubbles(i);
            new_bubble.vel(2) = new_bubble.vel(2); % Mirror velocity
            new_bubble.pos(1) = bubbles(i).pos(1)+rand();
            new_bubble.radius = bubbles(i).radius / 1.1;
            bubbles(i).radius = new_bubble.radius;  % Halve the original bubble size

            % Add the new bubble to the array
            bubbles(end+1) = new_bubble;
        end

        % Plot the bubbles
        rectangle('Position',[...
            bubbles(i).pos(1)-bubbles(i).radius,...
            bubbles(i).pos(2)-bubbles(i).radius,...
            bubbles(i).radius+bubbles(i).radius,...
            bubbles(i).radius+bubbles(i).radius...
            ], 'FaceColor', [0 1-bubbles(i).radius/10 1-bubbles(i).radius/10],... 
            'EdgeColor', [1 1 1],'Curvature',1);
        %viscircles(bubbles(i).pos, bubbles(i).radius, 'EdgeColor', 'b');
    end
    
    drawnow;
    saveas(gcf,['Plot' num2str(step) '.png']);
    fclose('all');
    pause(1);
%     pause(0.01);
end
