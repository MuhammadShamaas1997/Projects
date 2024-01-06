clc; clear all;
hold on;
pause(3)
x=-50:0.0001:50;
y=2.*x.*x.*x-x-500;
plot(x,y,'lineWidth',2)
xlim([-20 10]);
ylim([-7e3 2e3]);
plot([-20 10],[0 0])
title('Halley''s method');
text(-16,1000,'x_n_+_1 = x_n - 2 * y_n * y''_n / 2 * y''_n^2 -y_n y_n''''')
xlabel('x');ylabel('y = 2x^3-x-500');
%estXp = 9;
%yp = 2*estXp*estXp*estXp+500;
estXold = -4;

for i=1:10
    yold = 2*estXold*estXold*estXold-estXold-500;
    ydold = 6*estXold*estXold-1;
    yddold = 12*estXold;
    estXnew = estXold-2*yold*ydold/(2*ydold*ydold-yold*yddold);
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
    yold = ynew;
    pause(1);
end

figure;
hold on;
xlabel('Iteration');ylabel('x')
title('Independent variable x')
plot([1 10],[6.3261 6.3261])
ylim([-15 10])
for i=1:9
plot(i:i+1,[xValues(i) xValues(i+1)],'r-o','lineWidth',2);
pause(1)
end

figure;
hold on;
xlabel('Iteration');ylabel('y = 2x^3-x-500')
title('Dependent variable y')
plot([1 10],[0 0])
ylim([-6000 2000]);
for i=1:9
plot(i:i+1,[yValues(i) yValues(i+1)],'r-o','lineWidth',2);
pause(1)
end