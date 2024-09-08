function Julia_plot(c,k,Xr,Yr)
% Julia_plot(c,k,Xr,Yr)
%
% function plots Julia set for given parameter c
%
% c - parameter in equation z = z^2 + c
% k - number of iterations
% Xr - range of values on the x axis, Xr(1,1) - min value, Xr(1,2) - max
% value
% Yr - range of values on the y axis, Yr(1,1) - min value, Yr(1,2) - max
% value
%
%
% example:
% Julia_plot(i,100,[-2 2],[-2 2])

n = 512/2;
x = linspace(Xr(1,1),Xr(1,2),n);
y = linspace(Yr(1,1),Yr(1,2),n);
[X,Y] = meshgrid(x,y);
W = zeros(length(X),length(Y));
for m = 1:size(X,2)
    for j = 1:size(Y,2)
        [w,iter] = Julia(X(m,j)+Y(m,j)*i,c,k);
        W(m,j) = W(m,j) + iter;
    end
end
hold on;
%axis off;

colormap(jet);
pcolor(W);
shading interp;

hold off;

%**********************

function [pri,it] = Julia(z,c,k)

R = max(abs(c),2);
i = 0;
while i < k
    if abs(z) > R
        pri = 1;
        it = i;
        return;
    end
    
    z = z^2 + c;
    i = i + 1;
end
pri = 0;
it = i;