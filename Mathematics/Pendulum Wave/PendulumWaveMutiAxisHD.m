R = 25;
figure;
pause(2);
axis('equal');
axis([-R,R,-R,R])
axis off;
set(gcf,'Color',[1 1 1]);
hold on;

arms = 5;
color = [rand() rand() 1];
for i=1:arms
    x(i,1) = 0;
    y(i,1) = 0;
    rad(i) = 20/arms;
    x(i,2) = 0;
    y(i,2) = rad(i);
    speed(i) = 0.5*(i-0.5)*arms;
    if (rem(i,2)~=0)
        speed(i)=-speed(i);
    end
end

index = 0;
for time=1:0.001:1000
    index = index + 1;
    sumX1 = 0;
    sumY1 = 0;
    for i=1:arms
        x(i,2) = rad(i)*cos(2*pi*speed(i)*time);
        y(i,2) = rad(i)*sin(2*pi*speed(i)*time);
        arm(i)=plot([sumX1+x(i,1) sumX1+x(i,2)],[sumY1+y(i,1) sumY1+y(i,2)],'color',color,'LineWidth',5);
        sumX1 = sumX1 + x(i,2);
        sumY1 = sumY1 + y(i,2);
    end
    armL=plot([sumX1+x(i,1) sumX1+x(i,2)],[sumY1+y(i,1) sumY1+y(i,2)],'color',color/2,'LineWidth',5);
    saveas(gcf,['Plot' num2str(index) '.png'])
    pause(0.000001);
    for i=1:arms
        set(arm(i),'Visible','off');
    end
end