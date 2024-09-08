R = 2;
axis('equal');
%axis([-R,R,-R,R])
axis off;
set(gcf,'Color',[1 1 1]);
hold on;

for th=1:10:360
    axis('equal');
    axis off;
    set(gcf,'Color',[1 1 1]);
    hold on;

%     theta = th*2*pi/360;
    a = rand()+i*rand();
    Julia_plot(a,10,[-R R],[-R R])
    %saveas(gcf,['Plot' num2str(th) '.png'])
    pause(5);
    %fclose('all');
    clf('reset');
end