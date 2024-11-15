figure;pause(2);axis('equal');
axis([-10,1000,-10,1000])
hold on;

R=20;
radius = R;
center = [0 R];

Number=100;
for index=1:Number
    pos{index} = [0 900 2*radius 2*radius];
    complete(index)=1;
    color{index}=[rand() rand() rand()];
    vH(index)=10*rand();
    vV(index)=0;
    loss(index)= 0.8+rand()/10;
end

dt=0.5;

for time = 1:dt:1000
    for index=1:Number
        if ((pos{index}(2)-R)<0)
            vV(index) = -vV(index)*loss(index);
        end
        pos{index}(1)=pos{index}(1)+vH(index)*dt;
        pos{index}(2)=pos{index}(2)+vV(index)*dt;
        vV(index) = vV(index)-9.81*dt;

       circle(index) = rectangle('Position',pos{index},'Curvature',[1 1],'FaceColor',color{index},'EdgeColor',color{index},'LineWidth',3);
    end
    pause(0.01)
    for index = 1:Number
       set(circle(index),'Visible','off');
    end
end