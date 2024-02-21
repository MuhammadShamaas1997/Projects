clc;
clear all;
figure;
hold on;

pause(3)
axis([-1200 1200 -1200 1200]);
axis off;
set(gcf,'Color',[1 1 1]);
%plot([0 1200],[0 0],'LineWidth',1,'Color',[0 0 0]);
%plot([0 -250],[0 0],'LineWidth',5,'Color',[0 0 0]);

snakes = 10;
total = 100;
xMin = -1200;
xMax = 1200;
yMin = -1200;
yMax = 1200;

for n=1:snakes
    r=1;
    g=rand();
    b=rand();
    for i = 1:total
       rad(n,i) = 100;
       x(n,i) = 1;
       y(n,i) = 1;
       deltaX(n) = 100*rand()-50;
       deltaY(n) = 100*rand()-50;
       Fcolor{n,i} = [r,g,b];  
    end
end

for time=1:1
    for i=total-1:-1:2
        x(n,i) = x(n,i-1);
        y(n,i) = y(n,i-1);
        d(n,i) = rad(n,i)*2;
        px(n,i) = x(n,i)-rad(n,i);
        py(n,i) = y(n,i)-rad(n,i);
        rec(n,i)=rectangle('Position',[px(n,i) py(n,i) d(n,i) d(n,i)], 'Curvature', [1 1],'FaceColor',Fcolor{n,i},'EdgeColor',Fcolor{n,i});
    end
end

for time=1:10000
    for n=1:snakes
        x(n,1) = x(n,1)+deltaX(n);
        y(n,1) = y(n,1)+deltaY(n);
        if (x(n,1)>xMax)
            deltaX(n) = deltaX(n)*-1;
            x(n,1) = xMax- (x(n,1)-xMax);
        end
        if (x(n,1)<xMin)
            deltaX(n) = deltaX(n)*-1;
            x(n,1) = xMin + (-x(n,1)+xMin);
        end
        if (y(n,1)>yMax)
            deltaY(n) = deltaY(n)*-1;
            y(n,1) = yMax- (y(n,1)-yMax);
        end
        if (y(n,1)<yMin)
            deltaY(n) = deltaY(n)*-1;
            y(n,1) = yMin + (-y(n,1)+yMin);
        end
       
        for i=total-1:-1:2
            x(n,i) = x(n,i-1);
            y(n,i) = y(n,i-1);
            rec(n,i) = rec(n,i-1);
        end
       
        d(n,1) = rad(n,1)*2;
        px(n,1) = x(n,1)-rad(n,1);
        py(n,1) = y(n,i)-rad(n,1);
        rec(n,1)=rectangle('Position',[px(n,1) py(n,1) d(n,1) d(n,1)], 'Curvature', [1 1],'FaceColor',Fcolor{n,1},'EdgeColor',Fcolor{n,1});
    end

    pause(0.001);
    saveas(gcf,['Plot' num2str(time) '.png'])
    for n=1:snakes        
        for i=total-1:total-1
            set(rec(n,i),'Visible','off');
        end
    end
end