for i=1:arms
    set(arm(i),'Visible','off');
end

index = index + 1;
sumX1 = 0;
sumY1 = 0;
for i=1:arms
    x(i,2) = rad(i)*cos(2*pi*speed(i)*time);
    y(i,2) = rad(i)*sin(2*pi*speed(i)*time);
    armF(i)=plot([sumX1+x(i,1) sumX1+x(i,2)],[sumY1+y(i,1) sumY1+y(i,2)],'color',color{i},'LineWidth',5);
    arm(i)=plot([sumX1+x(i,1) sumX1+x(i,2)],[sumY1+y(i,1) sumY1+y(i,2)],'color',[0 0 0],'LineWidth',5);
    sumX1 = sumX1 + x(i,2);
    sumY1 = sumY1 + y(i,2);
    set(arm(i),'Visible','on');
end
saveas(gcf,['Plot' num2str(index) '.png'])
pause(0.000001);

time = time + 0.001;