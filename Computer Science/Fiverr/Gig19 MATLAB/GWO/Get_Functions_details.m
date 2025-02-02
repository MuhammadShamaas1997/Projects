% Get_functions_details.m - In the Get_functions_details.m file, the lower and upper 
%boundary values of the constraints were defined. Also, the objective function to be 
%maximized or minimized was correctly stated.
function [lb,ub,dim,fobj] = Get_Functions_details(F)
switch F 
 case 'F1'
 fobj = @F1;
 lb=[10 10 1420 850];
 ub=[15 30 1520 950];
 dim=4; 
end
end