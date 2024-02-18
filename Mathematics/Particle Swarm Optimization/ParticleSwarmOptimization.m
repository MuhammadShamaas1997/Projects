clear
clc
iterations = 100;
inertia = 1;
correction_factor = 0.5;
N = 100;
swarm_size = N*N;
figure
pause(3)
% ---- initial swarm position -----
index = 1;
for i = 1 : N
    for j = 1 : N
        swarm(index, 1, 1) = i;
        swarm(index, 1, 2) = j;
        index = index + 1;
    end
end

swarm(:, 4, 1) = 1000;          % best value so far
swarm(:, 2, :) = 0;             % initial velocity

for iter = 1 : iterations
    bestX = 30;
    bestY = 30;

    %-- evaluating position & quality ---
    for i = 1 : swarm_size
        swarm(i, 1, 1) = swarm(i, 1, 1) + swarm(i, 2, 1);     %update x position
        swarm(i, 1, 2) = swarm(i, 1, 2) + swarm(i, 2, 2);     %update y position
        x = swarm(i, 1, 1);
        y = swarm(i, 1, 2);

        val = ((x - 15)^2 + (y - 15)^2) ;          % fitness evaluation (you may replace this objective function with any function having a global minima)
            
        if val < swarm(i, 4, 1)                 % if new position is better
            swarm(i, 3, 1) = swarm(i, 1, 1);    % update best x,
            swarm(i, 3, 2) = swarm(i, 1, 2);    % best y postions
            swarm(i, 4, 1) = val;               % and best value
        end
    end

    [temp, gbest] = min(swarm(:, 4, 1));        % global best position

    %--- updating velocity vectors
    for i = 1 : swarm_size
        swarm(i, 2, 1) = rand*inertia*swarm(i, 2, 1) + correction_factor*rand*(swarm(i, 3, 1) - swarm(i, 1, 1)) + correction_factor*rand*(swarm(gbest, 3, 1) - swarm(i, 1, 1));   %x velocity component
        swarm(i, 2, 2) = rand*inertia*swarm(i, 2, 2) + correction_factor*rand*(swarm(i, 3, 2) - swarm(i, 1, 2)) + correction_factor*rand*(swarm(gbest, 3, 2) - swarm(i, 1, 2));   %y velocity component
    end

    %% Plotting the swarm
    clf
    x=1:30;
    for i=x
        for j=x
            z(i,j)=((i-15)^2+(j-15)^2);
        end
    end
    surf(x,x,z, 'EdgeColor', 'none');
    view([-30 -10])
    title('Particle swarm optimization');
    xlabel('x')
    ylabel('y')
    zlabel('(x-15)^2+(y-15)^2')
    colormap cool
    hold on
    for i=1:1000
        plot3(swarm(i, 1, 1), swarm(i, 1, 2),(swarm(i, 1, 1)-15)^2+(swarm(i, 1, 2)-15)^2, 'rx')   % drawing swarm movements
    end
    
    axis([1 30 1 30]);
pause(.2)
end