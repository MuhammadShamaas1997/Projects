function Mandelbrot_plot(k,Xr,Yr)
% Mandelbrot_plot(k,Xr,Yr)
%
% function plots the Mandelbrot set in given range
%
% k - number of iterations
% Xr - range of values on the x axis, Xr(1,1) - min value, Xr(1,2) - max
% value
% Yr - range of values on the y axis, Yr(1,1) - min value, Yr(1,2) - max
% value
%
%
% example:
% Mandelbrot_plot(100,[-2 2],[-2 2])

n = 400;
x = linspace(Xr(1,1),Xr(1,2),n);
y = linspace(Yr(1,1),Yr(1,2),n);
[X,Y] = meshgrid(x,y);
W = zeros(length(X),length(Y));
for m = 1:size(X,2)
    for j = 1:size(Y,2)
        [w,iter] = Mandelbrot(X(m,j)+Y(m,j)*i,k);
        W(m,j) = W(m,j) + iter;
    end
end
hold on;
%axis off;

colormap(jet);
pcolor(W);
shading interp;

hold off;

%*********************

function [pri,it] = Mandelbrot(c,m)

k = 0;
z = c;
while k < m
    if abs(z) > 2
        pri = 1;
        it = k;
        return;
    end
    
    z = z^2 + c;
    k = k + 1;
end
pri = 0;
it = k;