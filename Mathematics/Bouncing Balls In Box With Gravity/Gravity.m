figure;pause(2);axis('equal');
axis([-10,1000,-10,1000])
hold on;
axis off;
set(gcf, 'color', [1 1 1])

R=200;
radius = R;
center = [0 R];
plot([-10 1000],[0 0])
plot([-10 -10],[0 1000])
plot([1000 1000],[0 1000])
plot([-100 1000],[1000 1000])

Number=100;
for index=1:Number
    scale= rand();
    radi(index) = radius*scale;
    pos{index} = [200+100*rand() 600-100*rand() 2*radius*scale 2*radius*scale];
    complete(index)=1;
    color{index}=[rand() rand() rand()];
    vH(index)=-10*rand();
    vV(index)=0;
    loss(index)= 0.8+rand()/100;
end

dt=0.1;

for time = 1:dt:1000
    for index=1:Number
        if ((pos{index}(2)+2*radi(index)+vV(index)*dt)>1000)
            vV(index) = -vV(index);
        end
        if ((pos{index}(2)+vV(index)*dt)<0)
            vV(index) = -vV(index);
        end
        if ((pos{index}(1)+2*radi(index))>1000)
            vH(index) = -vH(index);
        end
        if ((pos{index}(1))<-10)
            vH(index) = -vH(index);
        end
        pos{index}(1)=pos{index}(1)+vH(index)*dt;
        pos{index}(2)=pos{index}(2)+vV(index)*dt;
        vV(index) = vV(index)-18.81*dt;

       circle(index) = rectangle('Position',pos{index},'Curvature',[1 1],'FaceColor',color{index},'EdgeColor',color{index},'LineWidth',3);
    end
    pause(0.01)
    for index = 1:Number
       set(circle(index),'Visible','off');
    end
end