% cec09.m - In the cec09.m file, the objective functions to be optimized are correctly stated.
% The Matlab version of the test instances for CEC 2009 Multiobjective
% Optimization Competition.
% 
% Usage: fobj = cec09(problem_name), the handle of the function will be
% with fobj
% 
% Please refer to the report for correct one if the source codes are not
% consist with the report.
% History:
% v1 Sept.08 2008
% v2 Nov.18 2008
% v3 Nov.26 2008
function fobj = cec09(name)
 switch name
 case 'UF1'
 fobj = @UF1;
 case 'UF2'
 fobj = @UF2; 
 case 'UF3'
 fobj = @UF3; 
 case 'UF4'
 fobj = @UF4;
 end
end

