clc; clear all;
hold on;
pause(3)
x=-50:0.0001:50;
y=2.*x.*x.*x-x-500;
plot(x,y,'lineWidth',2)
xlim([-20 10]);
ylim([-7e3 2e3]);
plot([-20 10],[0 0])
title('Steffensen''s method');
text(-16,1000,'x_n_+_1 = x_n - y(x_n)^2 / (y(x_n+y_n) - y(x_n)) ')
xlabel('x');ylabel('y = 2x^3-x-500');
%estXp = 9;
%yp = 2*estXp*estXp*estXp+500;
estXold = -10;
iterations = 25000;
for i=1:iterations
    yold = 2*estXold*estXold*estXold-estXold-500;
    ydold = 2*(estXold+yold)*(estXold+yold)*(estXold+yold)-(estXold+yold)-500;
    estXnew = estXold-(yold*yold)/(ydold-yold);
    ynew = 2*estXnew*estXnew*estXnew-estXnew-500;
    yValues(i) = ynew;
    xValues(i) = estXnew;
    hLine(i) = plot([estXold,estXnew],[yold,ynew],'-ro','lineWidth',2);
%     if (ynew * yold <0)
%         estXp = estXold;
%         yp = yold;
%     end    
    estXold = estXnew;
    yold = ynew;
    if (rem(i,100)==0)
        pause(0.0001);
    end
end

figure;
hold on;
xlabel('Iteration');ylabel('x')
title('Independent variable x')
plot([1 iterations],[6.3261 6.3261])
ylim([-15 10])
for i=1:(iterations-1)
plot(i:i+1,[xValues(i) xValues(i+1)],'r-o','lineWidth',2);
if (rem(i,100)==0)
    pause(0.0001);
end
end

figure;
hold on;
xlabel('Iteration');ylabel('y = 2x^3-x-500')
title('Dependent variable y')
plot([1 iterations],[0 0])
ylim([-3000 2000]);
for i=1:(iterations-1)
plot(i:i+1,[yValues(i) yValues(i+1)],'r-o','lineWidth',2);
if (rem(i,100)==0)
    pause(0.0001);
end
end