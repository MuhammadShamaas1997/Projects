clc;clear all;
R = 30;
figure;
pause(2);
axis('equal');
axis([-R,R,-R,R])
axis off;
set(gcf,'Color',[1 1 1]);
hold on;

arms = 40;
maxAngle = 0;
% plot([0 0],[0 25],'Color',[0 0 0],'LineWidth',5);
plot([0 25*cos(maxAngle-0.5*pi)],[0 25*sin(maxAngle-0.5*pi)],'Color',[0 0 0],'LineWidth',2);
plot([0 -25*cos(maxAngle-0.5*pi)],[0 25*sin(maxAngle-0.5*pi)],'Color',[0 0 0],'LineWidth',2);

rectangle('Position',[-25,-25,50,50],'Curvature',1);
for i=1:arms
    x(i,1) = 0;
    y(i,1) = 0;
    rad(i) = 20*(i/arms);
    x(i,2) = 0;
    y(i,2) = rad(i);
    d(i) = 2;
    speed(i) = i/360;
    theta(i)=1*pi/2;
    color{i} = [0.5-0.5*i/arms 0.5-0.5*i/arms 1];
end

[y, Fs] = audioread('stone.mp3');
index = 0;
dT = 10*(pi/180)/(2*pi*speed(arms));

for time=1:dT:360
    index = index + 1;
    i=arms;
    theta(i) = theta(i)+2*pi*speed(i)*dT;
    if (theta(i)<(-0.5*pi-maxAngle))
        speed(i) = -speed(i);
        theta(i) = (-0.5*pi-maxAngle) + (-theta(i)+(-0.5*pi-maxAngle));
%         sound(y,Fs);
    end
    if (theta(i)>(1.5*pi+maxAngle))
        speed(i) = -speed(i);
        theta(i) = (1.5*pi+maxAngle) - (-(1.5*pi+maxAngle)+theta(i));
%         sound(y,Fs);
    end
    for i=arms:-1:1
        x(i,2) = rad(i)*cos(theta(i));
        y(i,2) = rad(i)*sin(theta(i));
        arm(i)=plot([x(i,1) x(i,2)],[y(i,1) y(i,2)],'color',color{i},'LineWidth',1);
        px(i) = x(i,2)-d(i)/2;
        py(i) = y(i,2)-d(i)/2;
        rec(i)=rectangle('Position',[px(i) py(i) d(i) d(i)], 'Curvature', [1 1],'FaceColor',color{i},'EdgeColor',color{i});
    end 
     saveas(gcf,['Plot' num2str(index) '.png'])
     pause(0.000001);
     
     for i=1:(arms-1)
        theta(i) = theta(i+1);
    end

   
    for i=1:arms
        delete(arm(i));
        delete(rec(i));
%         set(arm(i),'Visible','off');
%         set(rec(i),'Visible','off');
    end
end