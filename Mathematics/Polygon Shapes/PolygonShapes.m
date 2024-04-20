clc;clear all;
number = 20;

for i = 1:number
    % Define parameters
    radius{i} = max(1,3*rand()); % Radius of the bubble
    transparency{i} = 0.5; % Transparency level of the bubble (0 to 1)
    color{i} = [0 rem(i,2)==0 rem(i,2)==0 transparency{i}]; % RGB color of the bubble (light blue)
    vertices{i} = max(3,round(rand()*10));
    dtheta =  2*pi/vertices{i};
    thetaO = 0;
    for vI = 1:vertices{i}
        xF{i}(vI) = radius{i}*cos(thetaO);
        yF{i}(vI) = radius{i}*sin(thetaO);
        thetaO = thetaO + dtheta;
    end
    x{i} = xF{i};
    y{i} = yF{i};
    xO{i} = 10*rand();
    yO{i} = 10*rand();
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
xMax = 10;xMin = -2;
yMax = 10;yMin = 0;
zMax = 10;zMin = 0;
axis([xMin-2 xMax+2 yMin-2 yMax+2 zMin-2 zMax+2])

for t=1:100
    for i=1:number
        
        %% Darw shape
        for vI = 1:vertices{i}
            x{i}(vI) = xF{i}(vI) + xO{i};
            y{i}(vI) = yF{i}(vI) + yO{i};
        end
        bubble(i) = plot(polyshape(...
        x{i},...
        y{i}),...
        'EdgeColor', color{i},...
        'FaceColor', color{i}...
        );
    
        
        %% Update positions
        xO{i} = xO{i} + xV{i};
        yO{i} = yO{i} + yV{i};
        
        %% Update speeds
        if (xO{i}>xMax)
            xV{i} = xV{i}*-1;
            xO{i} = xO{i}-(xO{i}-xMax); 
        end
        if (xO{i}<xMin)
            xV{i} = xV{i}*-1;
            xO{i} = xO{i}+(-xO{i}+xMin); 
        end
        
        if (yO{i}>yMax)
            yV{i} = yV{i}*-1;
            yO{i} = yO{i}-(yO{i}-yMax); 
        end
        if (yO{i}<yMin)
            yV{i} = yV{i}*-1;
            yO{i} = yO{i}+(-yO{i}+yMin); 
        end
    end
    saveas(gcf,['Plot' num2str(t) '.png']);
    fclose('all');
    pause(1);
    for i = 1:number
        set(bubble(i),'Visible','off');
    end
end