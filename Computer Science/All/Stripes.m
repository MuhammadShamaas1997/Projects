clc;clear all;
number = 20;

for i = 1:number
    % Define parameters
    color{i} = [rand() 1 rand() 1]; % RGB color of the bubble (light blue)
    color1{i} = [1 rand() rand() 1];
    xO{i} = 0;
    yO{i} = i;
    wO{i} = 1;
    x1{i} = i;
    y1{i} = 0;
    w1{i} = 1;
    xV{i} = rand();
    yV{i} = 0;
    yV1{i} = rand();
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

for t=1:120
    for i=1:number
        if (rem(i,2)==0)
        bubble(i) = rectangle('Position',[xO{i},yO{i},wO{i},1], 'FaceColor', color{i}, 'EdgeColor', color{i}, 'Curvature', 1);
        wO{i} = wO{i} + xV{i};
        wO{i} = wO{i} + yV{i};
        bubble1(i) = rectangle('Position',[x1{i},y1{i},1,w1{i}], 'FaceColor', color1{i}, 'EdgeColor', color1{i}, 'Curvature', 1);
        w1{i} = w1{i} + xV1{i};
        w1{i} = w1{i} + yV1{i};

        else
        bubble(i) = rectangle('Position',[xO{i},yO{i},wO{i},1], 'FaceColor', color{i}, 'EdgeColor', color{i}, 'Curvature', 1);
        wO{i} = wO{i} + xV{i};
        wO{i} = wO{i} + yV{i};
        
        bubble1(i) = rectangle('Position',[x1{i},y1{i},1,w1{i}], 'FaceColor', color1{i}, 'EdgeColor', color1{i}, 'Curvature', 1);
        w1{i} = w1{i} + xV1{i};
        w1{i} = w1{i} + yV1{i};
        end
                
%         if (xO{i}<xMin)
%             xV{i}=-xV{i};
%             xO{i} = xO{i}-(xO{i}-xMin);
%         end
%         if ((xO{i}+1)>xMax)
%             xV{i}=-xV{i};
%             xO{i} = xO{i}-((xO{i}+1)-xMax);
%         end

        
%         if (y1{i}<yMin)
%             yV1{i}=-yV1{i};
%             y1{i} = y1{i}-(y1{i}-yMin);
%         end
%         if ((y1{i}+1)>yMax)
%             yV1{i}=-yV1{i};
%             y1{i} = y1{i}-((y1{i}+1)-yMax);
%         end
    end
    
    saveas(gcf,['Plot' num2str(t) '.png']);
    fclose('all');
    pause(1);
    for i = 1:number
        delete(bubble(i));
        delete(bubble1(i));
    end
end