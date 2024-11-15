clc;clear all;
number = 20;

for i = 1:number
    % Define parameters
    color{i} = [1 rand() rand() 0.5]; % RGB color of the bubble (light blue)
    xO{i} = 0;
    yO{i} = i;
    wO{i} = 1;
    x1{i} = i;
    y1{i} = 5;
    w1{i} = 1;
    xV{i} = i/number;
    yV{i} = 0;
    yV1{i} = i/number;
    xV1{i} = 0;
end

% Create a sphere
figure;hold on;axis equal;
axis off;

%set(gcf, 'color', [0 0 0])
% light('Position', [1 0 0], 'Style', 'infinite');
% lighting gouraud;
% material shiny;
xMax = 20;xMin = 0;
yMax = 20;yMin = 0;
axis([xMin xMax+2 yMin-2 yMax+2])

for t=1:100
    for i=1:number
        bubble(i) = rectangle('Position',[xO{i},yO{i},10,wO{i}], 'FaceColor', color{i}, 'EdgeColor', color{i});
        xO{i} = xO{i} + xV{i};
        yO{i} = yO{i} + yV{i};
        
        if (xO{i}<xMin)
            xV{i}=-xV{i};
            xO{i} = xO{i}-(xO{i}-xMin);
        end
        if ((xO{i}+10)>xMax)
            xV{i}=-xV{i};
            xO{i} = xO{i}-((xO{i}+10)-xMax);
        end

        bubble1(i) = rectangle('Position',[x1{i},y1{i},w1{i},10], 'FaceColor', color{i}, 'EdgeColor', color{i});
        x1{i} = x1{i} + xV1{i};
        y1{i} = y1{i} + yV1{i};
        
        if (y1{i}<yMin)
            yV1{i}=-yV1{i};
            y1{i} = y1{i}-(y1{i}-yMin);
        end
        if ((y1{i}+10)>yMax)
            yV1{i}=-yV1{i};
            y1{i} = y1{i}-((y1{i}+10)-yMax);
        end
    end
    
    saveas(gcf,['Plot' num2str(t) '.png']);
    fclose('all');
    pause(1);
    for i = 1:number
        set(bubble(i),'Visible','off');
        set(bubble1(i),'Visible','off');
    end
end