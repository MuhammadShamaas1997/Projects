clc; clear all;

% Set the parameters
width = 800;
height = 800;
max_iter = 100;

% Set the region of interest
xmin = -2;
xmax = 2;
ymin = -2;
ymax = 2;

% Create a grid in the complex plane
[x, y] = meshgrid(linspace(xmin, xmax, width), linspace(ymin, ymax, height));
c = x + 1i*y;

% Initialize the matrix for the fractal
z = zeros(size(c));

% Create the Mandelbrot set
% for iter = 1:max_iter
%     z = z.^2 + c;
% end

iters = zeros(size(z));
escapeTime = zeros(size(z));

for k = 1:max_iter
    z = z.^2 + x + 1i * y;
    mask = abs(z) <= 100;
    iters = iters + mask;
    escapeTime = escapeTime + mask .* (k - 1);
end

% Define the colormap
colormap(cool);

% Display the initial Mandelbrot set
figure;
axis off;
set(gcf, 'color', [1 1 1]);
imagesc(x(1, :), y(:, 1), escapeTime);
axis equal;
title('Mandelbrot Set');

% Zoom into a specific region
for zoom_factor = 1:0.1:100;
x_center = 0.32;
y_center = -0.43971;

xmin = x_center - (xmax - xmin) / (2 * zoom_factor);
xmax = x_center + (xmax - xmin) / (2 * zoom_factor);
ymin = y_center - (ymax - ymin) / (2 * zoom_factor);
ymax = y_center + (ymax - ymin) / (2 * zoom_factor);

% Create a new grid for the zoomed region
[x, y] = meshgrid(linspace(xmin, xmax, width), linspace(ymin, ymax, height));
c = x + 1i*y;

% Initialize the matrix for the zoomed fractal
z = zeros(size(c));

% Create the zoomed Mandelbrot set
iters = zeros(size(z));
escapeTime = zeros(size(z));

for k = 1:max_iter
    z = z.^2 + x + 1i * y;
    mask = abs(z) <= 100;
    iters = iters + mask;
    escapeTime = escapeTime + mask .* (k - 1);
end

% Display the zoomed Mandelbrot set
% figure;
colormap(summer);
imagesc(x(1, :), y(:, 1), escapeTime);
axis equal;
axis off;
title('Zoomed Mandelbrot Set');
pause(1)
end