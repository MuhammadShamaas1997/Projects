clc; clear all;
hold on;
pause(3)
x=-50:0.0001:50;
y=2.*x.*x.*x+500;
plot(x,y,'lineWidth',2)
xlim([-20 10]);
ylim([-5e3 2e3]);
plot([-20 10],[0 0])
title('False position method');
text(-16,1000,'x_n_+_1 = x_n - f(x_n) * (x_n - x_n_-_1) / (f(x_n) - f(x_n_-_1))')
xlabel('x');ylabel('y = 2x^3+500');
estXp = 5;
estXold = -13;
yold = 2*estXold*estXold*estXold+500;

for i=1:10
    estXnew = estXold - (2*estXold*estXold*estXold+500)*(estXold-estXp)/(2*estXold*estXold*estXold+500-2*(estXp)*(estXp)*(estXp)-500);
    ynew = 2*estXnew*estXnew*estXnew+500;
    yValues(i) = ynew;
    xValues(i) = estXnew;
    hLine(i) = plot([estXold,estXnew],[yold,ynew],'-ro','lineWidth',2);
    if (ynew * yold <0)
    estXp = estXold;
    end
    estXold = estXnew;
    yold = ynew;
    pause(1);
end

figure;
hold on;
xlabel('Iteration');ylabel('x')
title('Independent variable x')
plot([1 10],[-6.2996 -6.2996])
% ylim([-6 4])
for i=1:9
plot(i:i+1,[xValues(i) xValues(i+1)],'r-o','lineWidth',2);
pause(1)
end

figure;
hold on;
xlabel('Iteration');ylabel('y = 2x^3+500')
title('Dependent variable y')
plot([1 10],[0 0])
% ylim([-6000 2000]);
for i=1:9
plot(i:i+1,[yValues(i) yValues(i+1)],'r-o','lineWidth',2);
pause(1)
end
