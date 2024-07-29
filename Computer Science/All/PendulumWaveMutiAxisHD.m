clc;clear all;
R = 25;
figure;
pause(2);
axis('equal');
% axis([-R,R,-R,R])
axis off;
set(gcf,'Color',[1 1 1]);
hold on;
allX = [];
allY = [];
N = 25;
for arms = 1:1:N
    allX = [];
    allY = [];
%      clf('reset')
    set(gcf,'Color',[1 1 1]);
%     title([num2str(arms) ' harmonics'])
    hold on;
    axis([-20,20,-20,20])
    axis off;
    
    speedO = arms;
    radiusO = arms;
    for i=1:arms
        x(i,1) = 0;
        y(i,1) = 0;
        rad(i) = radiusO;
        radiusO = radiusO * 1/4;
        x(i,2) = 0;
        y(i,2) = rad(i);
        speed(i) = speedO;
        speedO = speedO * -4;
        color{i} = [0 arms/N arms/N ];
    end
    
    index = 0;
    dT = max(1e-7,(pi/180)/(2*pi*abs(speedO)));
    %  dT = 0.001;
    for time=1:dT:(1+(1/arms)+dT)
        index = index + 1;
        sumX1 = 0;
        sumY1 = 0;
        for i=1:arms
            x(i,2) = rad(i)*cos(2*pi*speed(i)*time);
            y(i,2) = rad(i)*sin(2*pi*speed(i)*time);
%             arm(i)=plot([sumX1+x(i,1) sumX1+x(i,2)],[sumY1+y(i,1) sumY1+y(i,2)],'color',color{i},'LineWidth',5);
            sumX1 = sumX1 + x(i,2);
            sumY1 = sumY1 + y(i,2);
        end
        if (index==1)
            sumX0 = sumX1;
            sumY0 = sumY1;
        end
        allX(index) = sumX0;
        allY(index) = sumY0;
%         plot([sumX0 sumX1],[sumY0 sumY1],'color',color{1},'LineWidth',5)
        sumX0 = sumX1;
        sumY0 = sumY1;
        %armL=plot([sumX1+x(i,1) sumX1+x(i,2)],[sumY1+y(i,1) sumY1+y(i,2)],'color',color/2,'LineWidth',5);
        %saveas(gcf,['Plot' num2str(index) '.png'])
        %      if time==(1+(1/arms))
        %          pause(0.001);
        %      end
        
        %     for i=1:arms
        %         set(arm(i),'Visible','off');
        %     end
    end
    plot(allX,allY,'color',color{1},'LineWidth',5);
%     saveas(gcf,['Plot' num2str(arms) '.png'])
    pause(5)
end