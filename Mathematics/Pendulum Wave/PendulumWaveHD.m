R = 25;
figure;
pause(2);
axis('equal');
axis([-R,R,-R,R])
axis off;
set(gcf,'Color',[1 1 1]);
hold on;

arms = 15;
color = [rand() rand() 1];
plot([0 0],[0 25],'Color',[0 0 0],'LineWidth',5);
for i=1:arms
    x(i,1) = 0;
    y(i,1) = 0;
    rad(i) = 25-i;
    x(i,2) = 0;
    y(i,2) = rad(i);
    speed(i) = 0.0005*i;
    theta(i)=3*pi/2;
end

index = 0;
for time=1:0.001:1000
    index = index + 1;
    for i=1:arms
        theta(i) = theta(i)+2*pi*speed(i)*time;
        if (theta(i)<(1.1*pi))
            speed(i) = -speed(i);
            theta(i) = 1.1*pi + (-theta(i)+1.1*pi);
        end
        if (theta(i)>(1.9*pi))
            speed(i) = -speed(i);
            theta(i) = 1.9*pi - (-1.9*pi+theta(i));
        end
        x(i,2) = rad(i)*cos(theta(i));
        y(i,2) = rad(i)*sin(theta(i));
        arm(i)=plot([x(i,1) x(i,2)],[y(i,1) y(i,2)],'color',color,'LineWidth',5);
       
        d(i) = 3;
        px(i) = x(i,2)-d(i)/2;
        py(i) = y(i,2)-d(i)/2;
        rec(i)=rectangle('Position',[px(i) py(i) d(i) d(i)], 'Curvature', [1 1],'FaceColor',color/2,'EdgeColor',color/2);
    end
    saveas(gcf,['Plot' num2str(index) '.png'])
    pause(0.000001);
    for i=1:arms
        set(arm(i),'Visible','off');
        set(rec(i),'Visible','off');
    end
end