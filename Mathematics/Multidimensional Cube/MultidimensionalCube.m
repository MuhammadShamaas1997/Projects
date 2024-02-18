figure
pause(3)
for n=1:14
A=sparse([],[],[],2^n,2^n,2^(n+1));
V=[0 0];
for k=1:n
t=2^(k-1);
s=1:t;
A(t+s,t+s)=A(s,s);
A(t+s,s)=eye(t);
A(s,t+s)=eye(t);
V(t+s,1)=V(s,1)+cos(k*pi/n);
V(t+s,2)=V(s,2)+sin(k*pi/n);
end;
gplot(A,V,'b');
set(gcf, 'color', [1 1 1])
axis('equal','off');
title([int2str(n) ' -dimensional cube'], ...
   'HorizontalAlignment','center');
pause(1)
clc; clear all;
end