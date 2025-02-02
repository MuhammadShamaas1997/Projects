%Random_walk_around_antlion.m - Random walk of the ant around the antlion used in obtaining the elite ant and antlion positions
% This function creates random walks
function [RWs]=Random_walk_around_antlion(Dim,max_iter,lb, ub,antlion,current_iter)
if size(lb,1) ==1 && size(lb,2)==1 %Check if the bounds are scalar
 lb=ones(1,Dim)*lb;
 ub=ones(1,Dim)*ub;
end
if size(lb,1) > size(lb,2) %Check if boundary vectors are horizontal or vertical
 lb=lb';
 ub=ub';
end
I=1; % I is the ratio in Equations (3.53) and (3.54)
if current_iter>max_iter/10
 I=1+100*(current_iter/max_iter);
end
if current_iter>max_iter/2
 I=1+1000*(current_iter/max_iter);
end
if current_iter>max_iter*(3/4)
 I=1+10000*(current_iter/max_iter);
end
if current_iter>max_iter*(0.9)
 I=1+100000*(current_iter/max_iter);
end
if current_iter>max_iter*(0.95)
 I=1+1000000*(current_iter/max_iter);
end
% Decrease boundaries to converge towards antlion
lb=lb/(I); % Equation (3.53) in the thesis
ub=ub/(I); % Equation (3.54) in the thesis
% Move the interval of [lb ub] around the antlion [lb+anlion ub+antlion]
if rand<0.5
 lb=lb+antlion; % Equation (3.51) in the thesis
 else
 lb=-lb+antlion;
end
if rand>=0.5
 ub=ub+antlion; % Equation (3.52) in the thesis
else
 ub=-ub+antlion;
end
% This function creates n random walks and normalize according to lb and ub
% vectors 
for i=1:Dim
 X = [0 cumsum(2*(rand(max_iter,1)>0.5)-1)']; % Equation (3.44) in the thesis
 %[a b]--->[c d]
 a=min(X);
 b=max(X);
 c=lb(i);
 d=ub(i); 
 X_norm=((X-a).*(d-c))./(b-a)+c; % Equation (3.50) in the thesis
 RWs(:,i)=X_norm;
end
end