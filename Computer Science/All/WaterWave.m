clc;
clear all;
x=-20:.1:20;
y=-20:.1:20;
xindex = 0;
yindex = 0;

harmonics = 19;
total = 4*harmonics-1;

for id=1:total
    alpha(id) = 0.25;%rand()/10;
    beta(id) = 0.1;%rand()/10;
    xc(id) = 5*floor(id/harmonics)*cos(2*id*pi/harmonics+floor(id/harmonics)*(pi/harmonics));
    yc(id) = 5*floor(id/harmonics)*sin(2*id*pi/harmonics+floor(id/harmonics)*(pi/harmonics));
end

for time = 1:64
    for xi=x
        xindex = xindex+1;
        yindex = 0;
        for yi=y
            yindex = yindex+1;
            z(xindex,yindex) = 0;
            for id=1:total
                z(xindex,yindex)=z(xindex,yindex)+exp(-alpha(id)*sqrt((xi-xc(id))*(xi-xc(id))+(yi-yc(id))*(yi-yc(id))))*cos(sqrt((xi-xc(id))*(xi-xc(id))+(yi-yc(id))*(yi-yc(id)))-beta(id)*time);
            end
        end
    end

    wave=surf(x,y,z,'EdgeColor','None');
    view([180 70]);
    axis([-20 20 -20 20 -1.5 1.5]);
    set(gcf,'Color',[1 1 1]);
    colormap('prism');
    axis off;
    hold on;
    saveas(gcf,['Plot' num2str(time) '.png'])
    fclose('all');
    pause(0.000001);    
    set(wave,'Visible','off');
    xindex = 0;
    yindex = 0;
end