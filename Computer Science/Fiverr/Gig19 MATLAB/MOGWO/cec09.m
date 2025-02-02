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
function y = UF1(x)
y(1)=62.19 + 0.4573.*x(1) + 0.0259 .*x(2) - 0.02421 .*x(3) + 0.03638 .*x(4) -0.010867 .*x(1).^2 ...
 - 0.000029 .*x(2).^2 + 0.000005 .*x(3).^2 - 0.000009 .*x(4).^2 - 0.0003 .*x(1).*x(2) + 0.00022 .*x(1).*x(3) ...
 - 0.00042 .*x(1).*x(4) - 0.000005 .*x(2).*x(3) - 0.000005 .*x(2).*x(4) -0.000003 .*x(3).*x(4);
 
 y(2)= 13.1 + 3.722.*x(1) + 0.2003 .*x(2) - 0.0122 .*x(3) + 0.0451 .*x(4) -0.03047 .*x(1).^2 ...
 + 0.000296 .*x(2).^2 + 0.00004 .*x(3).^2 + 0.000052 .*x(4).^2 + 0.0049 .*x(1).*x(2) - 0.002940 .*x(1).*x(3) ...
 + 0.00286 .*x(1).*x(4) - 0.000285 .*x(2).*x(3) + 0.000285 .*x(2).*x(4) -0.000099 .*x(3).*x(4);
 y(3) = -29.0 - 0.36.*x(1) + 0.287 .*x(2) + 0.0659 .*x(3) + 0.0133 .*x(4) -0.01807 .*x(1).^2 ...
 - 0.000029 .*x(2).^2 - 0.000011 .*x(3).^2 - 0.000009 .*x(4).^2 - 0.0125 .*x(1).*x(2) + 0.0003 .*x(1).*x(3) ...
 + 0.00086 .*x(1).*x(4) - 0.000205 .*x(2).*x(3) + 0.000195 .*x(2).*x(4) -0.000009 .*x(3).*x(4);
end
