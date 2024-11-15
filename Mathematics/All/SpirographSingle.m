R = 100;
figure;pause(2);axis('equal');
axis([-R-100,R+100,-10,2*R+10])
hold on;

radius = R;
center = [0 R];
pos = [center-radius 2*radius 2*radius];
rectangle('Position',pos,'Curvature',[1 1]);

for iter=1
%R = rand()*50;
r=rand()*R; %8.9117
f=0.0001;
dis = rand(); %0.6463
coordinates = [0,(1+dis)*r];
newcoordinates = [0,(1+dis)*r];
Ccoordinates = [0,(1+dis)*r];
Ccoordinatesnew = [0,(1+dis)*r];
c = [0 r/2];
color = [rand() rand() rand()];
offsetX = 0;%(rand()-0.5)*200;
offsetY = 0;%(rand())*200;
for t=0:(pi/10):(100*pi)
    newcoordinates(1) = r*(t) + (dis*r)*sin(t);
    newcoordinates(2) = r+(dis*r)*cos(t);
    coordinates = newcoordinates;
    
    theta = (r*t)/R;
    center = [(R-r)*sin(theta) R-(R-r)*cos(theta)];
    Ccoordinatesnew(1) = center(1)+dis*r*sin(t-theta);
    Ccoordinatesnew(2) = center(2)+dis*r*cos(t-theta);
    if (t~=0)
        plot([offsetX,offsetX]+[Ccoordinates(1),Ccoordinatesnew(1)],[offsetY,offsetY]+[Ccoordinates(2),Ccoordinatesnew(2)],'color',color,'LineWidth',2);
    end
    
    if (rem(t,pi/10)==0)
        radius = r;
        theta = r*t/R;
        center = [(R-r)*sin(theta) R-(R-r)*cos(theta)];
        pos = [center-radius 2*radius 2*radius];
        circle = rectangle('Position',pos,'Curvature',[1 1]);

        line = plot([Ccoordinatesnew(1), (R-r)*sin(theta)],[Ccoordinatesnew(2), R-(R-r)*cos(theta)],'k-o');
        pause(0.000001);
    end

    set(circle,'Visible','off');
    set(line,'Visible','off');
    Ccoordinates = Ccoordinatesnew;
end
pause(1);
end