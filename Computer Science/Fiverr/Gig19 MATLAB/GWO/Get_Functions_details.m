% Get_functions_details.m - In the Get_functions_details.m file, the lower and upper 
%boundary values of the constraints were defined. Also, the objective function to be 
%maximized or minimized was correctly stated.
function [lb,ub,dim,fobj] = Get_Functions_details(F)
switch F 
 case 'F1'
 fobj = @F1;
 lb=[[65] [22] [10] [0.8] [0.8] [0.2] [0.8] [2000] [2000] [10000]];
 ub=[[95] [36] [20] [2.2] [2.2] [1.4] [2.2] [10000] [10000] [10000]];
 dim=10; 
end
end