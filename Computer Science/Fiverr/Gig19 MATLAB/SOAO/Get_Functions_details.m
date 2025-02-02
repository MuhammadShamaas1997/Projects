% Get_Function_details.m – for defining the constraints and objective function
function [lb,ub,dim,fobj] = Get_Functions_details(F)
switch F
case 'F1'
fobj = @F1;
lb=[10 10 1420 850];
ub=[15 30 1520 950];
dim=4; 
end
end