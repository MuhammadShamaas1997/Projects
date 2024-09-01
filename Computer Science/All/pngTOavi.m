% Define parameters
outputVideo = 'output_video.avi';  % Name of the output video file
fps = 10;                           % Frames per second

% Create VideoWriter object
writerObj = avifile(outputVideo, 'fps', fps);

% Specify the directory where your PNG images are stored
imageDir = './';

% Get a list of all PNG files in the directory
pngFiles = dir(fullfile(imageDir, '*.png'));

% Sort the files alphabetically
fileNames = {pngFiles.name};
[a, order] = sort(cellfun(@(x) sscanf(x, 'Plot%d.png'), fileNames));
pngFiles = pngFiles(order);

% Loop through each PNG file and add it to the video
for j=1:1
for i = 1:numel(pngFiles)
    % Read the PNG image
    img = imread(fullfile(imageDir, pngFiles(i).name));
   
    % Add the image as a frame to the AVI file
    writerObj = addframe(writerObj, img);
end
end

% Close the AVI file
writerObj = close(writerObj);