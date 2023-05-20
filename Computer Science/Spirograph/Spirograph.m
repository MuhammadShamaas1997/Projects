r=10;
f=0.0001;
dis = 1;
coordinates = [0,(1+dis)*r];
newcoordinates = [0,(1+dis)*r];
Ccoordinates = [0,(1+dis)*r];
Ccoordinatesnew = [0,(1+dis)*r];
c = [0 r/2];
hold on;
%axis([-40,40,0,40])
R = 40;
 
for t=0:360
    newcoordinates(1) = r*(t/(2*pi)) + (dis*r)*sin(t/(2*pi));
    newcoordinates(2) = r+(dis*r)*cos(t/(2*pi));
    %plot([coordinates(1),newcoordinates(1)],[coordinates(2),newcoordinates(2)]);
    coordinates = newcoordinates;
    
    theta = newcoordinates(1)/(R);
    Ccoordinatesnew(1) = R*sin(theta)-newcoordinates(2)*sin(theta);
    Ccoordinatesnew(2) = R-R*cos(theta)+newcoordinates(2)*cos(theta);
    plot([Ccoordinates(1),Ccoordinatesnew(1)],[Ccoordinates(2),Ccoordinatesnew(2)],'o');
    Ccoordinatesnew = Ccoordinates;
    %c(1) = c(1) + r*sin(2*pi*f*t);
    %pos = [c(1)-r/2 0 r r];
    %rectangle('Position',pos,'Curvature',[1 1])
    %pause(1)
end