% Define parameters
outputVideo = 'output_video.avi';  % Name of the output video file
fps = 15;                          % Frames per second

% Create VideoWriter object
writerObj = VideoWriter(outputVideo, 'Motion JPEG AVI');
writerObj.FrameRate = fps;

% Open the video file for writing
open(writerObj);

ms = 1 ;
mt = 1 ;
mj = 1 ;
G = 1 ;
CI = [0 -0.1 2 2 5 0 0 0 0 0 0 0];
to = 0;
tf = 120;

% Define the function F
F = @(t,Y) [Y(7);Y(8);Y(9);Y(10);Y(11);Y(12);G*(mt*(Y(3)-Y(1))/((Y(3)-Y(1))^2+(Y(4)-Y(2))^2)^(3/2)+mj*(Y(5)-Y(1))/((Y(5)-Y(1))^2+(Y(6)-Y(2))^2)^(3/2));G*(mt*(Y(4)-Y(2))/((Y(3)-Y(1))^2+(Y(4)-Y(2))^2)^(3/2)+mj*(Y(6)-Y(2))/((Y(5)-Y(1))^2+(Y(6)-Y(2))^2)^(3/2));G*(ms*(Y(1)-Y(3))/((Y(3)-Y(1))^2+(Y(4)-Y(2))^2)^(3/2)+mj*(Y(5)-Y(3))/((Y(5)-Y(3))^2+(Y(6)-Y(4))^2)^(3/2));G*(ms*(Y(2)-Y(4))/((Y(3)-Y(1))^2+(Y(4)-Y(2))^2)^(3/2)+mj*(Y(6)-Y(4))/((Y(5)-Y(3))^2+(Y(6)-Y(4))^2)^(3/2));G*(ms*(Y(1)-Y(5))/((Y(1)-Y(5))^2+(Y(6)-Y(2))^2)^(3/2)+mt*(Y(3)-Y(5))/((Y(5)-Y(3))^2+(Y(6)-Y(4))^2)^(3/2));G*(ms*(Y(2)-Y(6))/((Y(5)-Y(1))^2+(Y(6)-Y(2))^2)^(3/2)+mt*(Y(4)-Y(6))/((Y(5)-Y(3))^2+(Y(6)-Y(4))^2)^(3/2))];

[t,Y] = ode45(F, [to, tf], CI);

% Initialize parameters
yo = Y(1) ;
dto = 0.3 ;
plotmax = 100 ;
T = to ;

xmin = min([Y(:,1);Y(:,3);Y(:,5)]);
xmax = max([Y(:,1);Y(:,3);Y(:,5)]);
ymin = min([Y(:,2);Y(:,4);Y(:,6)]);
ymax = max([Y(:,2);Y(:,4);Y(:,6)]);

% Create the figure
figure;
pl = 0;
for i = 1:length(Y(:,1))    
    clf;
    dt = abs(Y(i,1)-yo)/abs(Y(i,7));
    if dt >= dto
        % Create plot and update frame
        if i > plotmax
            pl = plot(Y(i-plotmax:i,1), Y(i-plotmax:i,2), 'r', ...
                      Y(i,1), Y(i,2), '-or', ...
                      Y(i-plotmax:i,3), Y(i-plotmax:i,4), 'g', ...
                      Y(i,3), Y(i,4), '-og', ...
                      Y(i-plotmax:i,5), Y(i-plotmax:i,6), 'b', ...
                      Y(i,5), Y(i,6), '-ob', 'LineWidth', 3);
            T = [T; t(i)];
        else
            pl = plot(Y(1:i,1), Y(1:i,2), 'r', ...
                      Y(i,1), Y(i,2), '-or', ...
                      Y(1:i,3), Y(1:i,4), 'g', ...
                      Y(i,3), Y(i,4), '-og', ...
                      Y(1:i,5), Y(1:i,6), 'b', ...
                      Y(i,5), Y(i,6), '-ob', 'LineWidth', 3);
            T = [T; t(i)];
        end

        % Set axis limits
        xlim([xmin xmax]);
        ylim([ymin ymax]);
        axis off;
        grid off;

        % Write the current frame to the video
        frame = getframe(gcf); % Capture the frame
        writeVideo(writerObj, frame); % Add frame to video
    end
end

% Close the video file
close(writerObj);
