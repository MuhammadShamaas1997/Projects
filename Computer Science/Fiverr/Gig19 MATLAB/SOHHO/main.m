% Main.m file – This houses all other functions used for this mathematical model. In the main.m file,the number of search agents and number of iterations were defined. 
%Thereafter, this file was made to run after adding the folder to the path.
clear all %#ok<CLALL>
close all
clc
N=100; % Number of search agents
Function_name='F1'; % Name of the test function 
T=500; % Maximum number of iterations
% Load details of the selected benchmark function
[lb,ub,dim,fobj]=Get_Functions_details(Function_name);
[Rabbit_Energy,Rabbit_Location,CNVG]=HHO(N,T,lb,ub,dim,fobj);
%Draw objective space
figure,
hold on
semilogy(CNVG,'Color','b','LineWidth',4);
title('Convergence curve')
xlabel('Iteration');
ylabel('Best fitness obtained so far');
axis tight
grid off
box on
legend('HHO')
display(['The best location of HHO is: ', num2str(Rabbit_Location)]);
display(['The best fitness of HHO is: ', num2str(Rabbit_Energy)]);

