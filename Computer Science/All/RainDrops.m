clc;
clear all;
x=-20:.1:20;
y=-20:.1:20;
xindex = 0;
yindex = 0;

total = 1;
for id=1:total
    alpha(id) = 0.25;%rand()/10;
    beta(id) = 0.1;%rand()/10;
    xc(id) = 40*rand()-20;
    yc(id) = 40*rand()-20;
    speed(id) = 0.25;
    startTime(id) = 0;
end

for time = 1:240
    for xi=x
        xindex = xindex+1;
        yindex = 0;
        for yi=y
            yindex = yindex+1;
            z(xindex,yindex) = 0;
            for id=1:total
                dis = sqrt((xi-xc(id))*(xi-xc(id))+(yi-yc(id))*(yi-yc(id)));
                z(xindex,yindex)=z(xindex,yindex)+exp(-alpha(id)*(time-startTime(id)))*exp(-alpha(id)*abs(dis-speed(id)*(time-startTime(id))));
            end
        end
    end

    if (rand()>(1-time/120))
        newC = 4;
        total = total+newC;
        for id=(total-newC+1):total
            alpha(id) = 0.25;%rand()/10;
            beta(id) = 0.1;%rand()/10;
            xc(id) = 40*rand()-20;
            yc(id) = 40*rand()-20;
            speed(id) = 0.5;
            startTime(id) = time;
        end
    end

    
    wave=surf(x,y,z,'EdgeColor','None');
    view([180 90]);
    axis([-20 20 -20 20 -1.5 1.5]);
    set(gcf,'Color',[1 1 1]);     
%     colormap([1 1 1;0.9 0.9 0.9;0.8 0.8 0.8;0.7 0.7 0.7;0.6 0.6 0.6;0.5 0.5 0.5;0.4 0.4 0.4;0.3 0.3 0.3;0.2 0.2 0.2;0.1 0.1 0.1;0 0 0]);
%     colormap([1 1 1;1 1 1;1 1 1;1 1 1;1 1 1;1 1 1;1 1 1;1 1 1;1 1 1;1 1 1;0.8 0.8 0.8;0.9 0.9 0.9;0 0 0]);
    a=colormap('winter');
    sizeA = size(a);
%     b=(ones(sizeA)-a);
    a(60:sizeA(1),:)=ones(sizeA(1)-59,3);
    colormap(a);
    axis off;
    hold on;
%     saveas(gcf,['Plot' num2str(time) '.png'])
%     fclose('all');
    pause(0.000001);    
    set(wave,'Visible','off');
    xindex = 0;
    yindex = 0;
end