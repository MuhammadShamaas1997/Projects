R = 100;
figure;pause(2);axis('equal');
axis([-R-10,R+10,-10,2*R+10])
axis off;
set(gcf,'Color',[1 1 1]);
hold on;

radius = R;
center = [0 R];
pos = [center-radius 2*radius 2*radius];
%rectangle('Position',pos,'Curvature',[1 1]);

for iter=1
r=2*rand()*R;
f=0.0001;
dis = rand();
coordinates = [0,(1+dis)*r];
newcoordinates = [0,(1+dis)*r];
Ccoordinates = [0,(1+dis)*r];
Ccoordinatesnew = [0,(1+dis)*r];
c = [0 r/2];
color = [rand() rand() 1];
offsetX = 0;
offsetY = 0;
time=0;
for t=0:(pi/100):(100*pi)
    time=time+1;
    newcoordinates(1) = r*(t) + (dis*r)*sin(t);
    newcoordinates(2) = r+(dis*r)*cos(t);
    coordinates = newcoordinates;
    
    theta = (r*t)/R;
    center = [(R-r)*sin(theta) R-(R-r)*cos(theta)];
    Ccoordinatesnew(1) = center(1)+dis*r*sin(t-theta);
    Ccoordinatesnew(2) = center(2)+dis*r*cos(t-theta);
    if (t~=0)
        %plot([offsetX,offsetX]+[Ccoordinates(1),Ccoordinatesnew(1)],[offsetY,offsetY]+[Ccoordinates(2),Ccoordinatesnew(2)],'color',color,'LineWidth',2);
    end
    
    if (rem(t,pi/50)==0)
        radius = r;
        theta = r*t/R;
        center = [(R-r)*sin(theta) R-(R-r)*cos(theta)];
        pos = [center-radius 2*radius 2*radius];
        %circle = rectangle('Position',pos,'Curvature',[1 1]);

        line1 = plot([Ccoordinatesnew(1), (R-r)*sin(theta)],[Ccoordinatesnew(2), R-(R-r)*cos(theta)],'LineWidth',5,'Color',color);
        line2 = plot([Ccoordinatesnew(1), (R-r)*sin(theta)],[Ccoordinatesnew(2), R-(R-r)*cos(theta)],'LineWidth',5,'Color',color/2);
        line3 = plot([0, (R-r)*sin(theta)],[100, R-(R-r)*cos(theta)],'LineWidth',5,'Color',color/2);
        %pause(0.000001);
        saveas(gcf,['Plot' num2str(time) '.png'])
        pause(0.000001);
    end


    %set(circle,'Visible','off');
    set(line2,'Visible','off');
    set(line3,'Visible','off');
    Ccoordinates = Ccoordinatesnew;
end
pause(1);
end
