R = 100;
figure;pause(2);axis('equal');
axis([-R-100,R+100,-100,2*R+100])
hold on;

radius = R;
center = [0 R];
pos = [center-radius 2*radius 2*radius];
rectangle('Position',pos,'Curvature',[1 1]);

Number=4
for index=1:Number
    complete(index)=1;
    color{index}=[rand() rand() rand()];
end

plot([0,0],[0,100],'LineWidth',3)

for thetaO = 0:(pi/10):(32*pi)
    for index=1:Number
        radius = 5;
        R = 20*index;
        theta = thetaO/(index/2);
        if (rem(theta,2*pi)==0)
            complete(index)=complete(index)*-1;
            color{index}=[rand() rand() rand()];
        end
        theta = theta*complete(index);
        pos = [(R+radius)*sin(theta)-radius 100-(R+radius)*cos(theta)-radius 2*radius 2*radius];
        circle(index) = rectangle('Position',pos,'Curvature',[1 1],'FaceColor',color{index},'EdgeColor',color{index},'LineWidth',3);
        line(index)=plot([0,pos(1)+radius],[100,pos(2)+radius],'color',color{index});
    end
%    pause(0.01);
    for index = 1:Number
        set(circle(index),'Visible','off');
        %set(line(index),'Visible','off');
    end
end