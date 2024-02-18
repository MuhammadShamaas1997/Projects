clc;clear all;
figure;pause(2);axis('equal');
axis off;
set(gcf, 'color', [1 1 1])
axis([-500,600,-100,500])
hold on;
l=500;
R=20;
radius = R;
center = [0 R];

Number=10;
for index=1:Number
    theta{index} = pi/4;
    pos{index} = [l*sin(theta{index}) l-l*cos(theta{index}) 2*radius 2*radius];
    color{index}=[rand() rand() rand()];
    loss(index)= 0.8+rand()/10;
    maxtheta{index} = (pi/4) + index*(pi/64);
    f(index) = 0.01;
    sign{index}=-1;
end

dt=0.1;

for time = 1:dt:1000
    for index=1:Number

        if (theta{index}>maxtheta{index}) || (theta{index}<-maxtheta{index})
            sign{index} = sign{index}*-1;
        end
        theta{index} = theta{index}+sign{index}*2*pi*f(index)*dt;
       pos{index}(1)=l*sin(theta{index});
       pos{index}(2)=l-l*cos(theta{index});

       circle(index) = rectangle('Position',pos{index},'Curvature',[1 1],'FaceColor',color{index},'EdgeColor',color{index},'LineWidth',3);
        line(index) = plot([0,pos{index}(1)+R],[500,pos{index}(2)+2*R],'k');
    end
    pause(0.001)
    for index = 1:Number
       set(circle(index),'Visible','off');
       set(line(index),'Visible','off');
    end
end