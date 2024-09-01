numFlips = 1;
% Create figure window
figure;
axis([-1.5 1.5 -1.5 1.5 -1.0 1.0]*3);

hold on;
set(gcf, 'color', [1 1 1])
% Create a coin as a circle
theta = linspace(0, 2*pi, 100);
x = cos(theta);
y = sin(theta);
% Draw the coin
for i=1:20
    fill3(x, y, (i/100)*ones(1, 100), 'y'); % Heads side (yellow)
end
axis off
ind = 1;
% Loop through each flip
for i = 1:numFlips
    
    % Animate the coin flip
    for t = linspace(-90, 90, 180)
        % Clear the current coin drawing
        view([0 t]);
        %saveas(gcf,['Plot' num2str(ind) '.png']);
        %fclose('all');
        ind = ind+1;
        
        % Pause to create animation effect
        pause(0.05);
    end
end
