clc;clear all;
number = 20;

for i = 1:number
    % Define parameters
    radius{i} = rand(); % Radius of the bubble
    transparency{i} = 0.5; % Transparency level of the bubble (0 to 1)
    color{i} = [1 rand() rand() transparency{i}]; % RGB color of the bubble (light blue)
    xO{i} = 10*rand();
    yO{i} = 10*rand();
    wO{i} = 3+rand();
    xV{i} = rand()-0.5;
    yV{i} = rand()-0.5;
end

% Create a sphere
figure;hold on;axis equal;
axis off;

%set(gcf, 'color', [0 0 0])
light('Position', [1 0 0], 'Style', 'infinite');
lighting gouraud;
material shiny;
view([0 270]);
xMax = 10;xMin = -2;
yMax = 10;yMin = 0;
zMax = 10;zMin = 0;
axis([xMin xMax+2 yMin-2 yMax+2 zMin-2 zMax+2])

for t=1:100
    for i=1:number
        bubble(i) = rectangle('Position',[xO{i},yO{i},wO{i},wO{i}], 'FaceColor', color{i}, 'EdgeColor', color{i},'Curvature',radius{i});
        xO{i} = xO{i} + xV{i};
        yO{i} = yO{i} + yV{i};
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