clc;clear all;
number = 20;

for i = 1:number
    % Define parameters
    radius{i} = 0.5+rand(); % Radius of the bubble
    transparency{i} = 0.5; % Transparency level of the bubble (0 to 1)
    shine_strength{i} = 1; % Strength of the shine effect (0 to 1)
    bubble_color{i} = [rand() rand() 1]; % RGB color of the bubble (light blue)
    xO{i} = 10*rand();
    yO{i} = 10*rand();
    zO{i} = 10*rand();
    xV{i} = rand()/3;
    yV{i} = rand()/3;
    zV{i} = 0;
end

% Create a sphere
figure;hold on;axis equal;
axis off;

%set(gcf, 'color', [0 0 0])
light('Position', [1 0 0], 'Style', 'infinite');
lighting gouraud;
material shiny;
view([0 270]);
xMax = 10;xMin = 0;
yMax = 10;yMin = 0;
zMax = 10;zMin = 0;
axis([xMin-2 xMax+2 yMin-2 yMax+2 zMin-2 zMax+2])

for t=1:100
    for i=1:number
        [x, y, z] = sphere(100); % Generate sphere coordinates
        x = x * radius{i};
        y = y * radius{i};
        z = z * radius{i};
        bubble(i) = surf(x+xO{i}, y+yO{i}, z+zO{i}, 'FaceColor', bubble_color{i}, 'EdgeColor', 'none', 'FaceAlpha', transparency{i});
        xO{i} = xO{i} + xV{i};
        yO{i} = yO{i} + yV{i};
        zO{i} = zO{i} + zV{i};
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
        
        if (zO{i}>zMax)
            zV{i} = zV{i}*-1;
            zO{i} = zO{i}-(zO{i}-zMax); 
        end
        if (zO{i}<zMin)
            zV{i} = zV{i}*-1;
            zO{i} = zO{i}+(-zO{i}+zMin); 
        end
        
    end
    saveas(gcf,['Plot' num2str(t) '.png']);
    fclose('all');
    pause(1);
    for i = 1:number
        set(bubble(i),'Visible','off');
    end
end