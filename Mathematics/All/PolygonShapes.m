clc;clear all;
number = 15;

for i = 1:number
    % Define parameters
    radius{i} = 8; % Radius of the bubble
    transparency{i} = 0.5; % Transparency level of the bubble (0 to 1)
    color{i} = [rand() 1 rand() transparency{i}]; % RGB color of the bubble (light blue)
    vertices{i} = 3+round(3*rand());
    dtheta =  2*pi/vertices{i};
    thetaO = 0;
    for vI = 1:vertices{i}
        angle{i}(vI) = thetaO;
        xF{i}(vI) = (radius{i})*cos(thetaO);
        yF{i}(vI) = (radius{i})*sin(thetaO);
        thetaO = thetaO + dtheta;
    end
    x{i} = xF{i};
    y{i} = yF{i};
    xO{i} = 20*rand()-10;
    yO{i} = 20*rand()-10;
    wO{i} = 3+rand();
    xV{i} = rand()-0.5;
    yV{i} = rand()-0.5;
end

% Create a sphere
figure;hold on;axis equal;
axis off;

set(gcf, 'color', [1 1 1])
light('Position', [1 0 0], 'Style', 'infinite');
lighting gouraud;
material shiny;
view([0 270]);
xMax = 20;xMin = -20;
yMax = 20;yMin = -20;
zMax = 10;zMin = 0;
axis([xMin-5 xMax+5 yMin-5 yMax+5 zMin-5 zMax+5])

for t=1:100
    for i=number:-1:1
        
        % Update speeds
        if (xO{i}>xMax)
            xV{i} = xV{i}*-1;
            xO{i} = xMax-(xO{i}-xMax); 
        end
        if (xO{i}<xMin)
            xV{i} = xV{i}*-1;
            xO{i} = xMin+(-xO{i}+xMin); 
        end
        
        if (yO{i}>yMax)
            yV{i} = yV{i}*-1;
            yO{i} = yMax-(yO{i}-yMax); 
        end
        if (yO{i}<yMin)
            yV{i} = yV{i}*-1;
            yO{i} = yMin+(-yO{i}+yMin); 
        end
        
        %% Darw shape
        bubble(i) = plot(polyshape(...
        x{i},...
        y{i}),...
        'EdgeColor', color{i},...
        'FaceColor', color{i}...
        );

        
        %% Update positions
        for vI = 1:vertices{i}
            x{i}(vI) = xO{i} + xF{i}(vI);
            y{i}(vI) = yO{i} + yF{i}(vI);
        end

        %% Update positions
        xO{i} = xO{i} + xV{i};
        yO{i} = yO{i} + yV{i};

        
    end
    saveas(gcf,['Plot' num2str(t) '.png']);
    fclose('all');
    pause(1);
    for i = 1:number
        delete(bubble(i));
    end
end