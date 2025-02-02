% Define parameters
outputVideo = 'output_video.avi';  % Name of the output video file
fps = 15;                           % Frames per second

% Create VideoWriter object
writerObj = VideoWriter(outputVideo, 'Motion JPEG AVI');
writerObj.FrameRate = fps;
open(writerObj);

% Specify the directory where PNG images are stored
imageDir = './';

% Get a list of all PNG files in the directory
pngFiles = dir(fullfile(imageDir, '*.png'));

% Extract filenames and sort them numerically
fileNames = {pngFiles.name};

% Extract numbers from filenames like 'Plot1.png', 'Plot2.png', etc.
numList = zeros(size(fileNames)); % Preallocate array for numbers
for i = 1:numel(fileNames)
    num = sscanf(fileNames{i}, 'Plot%d.png'); % Extract the number
    if ~isempty(num)
        numList(i) = num;
    else
        numList(i) = Inf; % Assign a large number to avoid sorting errors
    end
end

% Sort filenames based on extracted numbers
[~, order] = sort(numList);
pngFiles = pngFiles(order);

% Loop through each PNG file and add it to the video
for i = 1:numel(pngFiles)
    % Read the PNG image
    img = imread(fullfile(imageDir, pngFiles(i).name));
   
    % Write the frame to the AVI file
    writeVideo(writerObj, img);
end

% Close the AVI file
close(writerObj);
