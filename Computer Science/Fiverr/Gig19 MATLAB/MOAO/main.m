%MALO.m � Here, the constraints were defined. All other functions are called to yield the Pareto optimal solutions.
clc;
clear;
close all;
% Change these details with respect to your problem%%%%%%%%%%%%%%
ObjectiveFunction=@ZDT1;
dim=4;
%Alb = [10];
%Aub = [15];
%Blb = [10];
%Bub = [30];
%Clb = [1420];
%Cub = [1520];
%Dlb = [850];
%Dub = [950];
%lb=[Alb Blb Clb Dlb];
%ub=[Aub Bub Cub Dub];
lb= [10 10 1420 850];
ub= [15 30 1520 950];
%lb=0;
%ub=1;
obj_no=3;
if size(ub,2)==1
 ub=ones(1,dim).*ub;
 lb=ones(1,dim).*lb;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial parameters of the MODA algorithm
max_iter=100;
N=100;
ArchiveMaxSize=6;
Archive_X=zeros(100,dim);
Archive_F=ones(100,obj_no)*inf;
Archive_member_no=0;
r=(ub-lb)/2;
V_max=(ub(1)-lb(1))/10;
Elite_fitness=inf*ones(1,obj_no);
Elite_position=zeros(dim,1);
Ant_Position=initialization(N,dim,ub,lb);
fitness=zeros(N,2);
V=initialization(N,dim,ub,lb);
iter=0;
position_history=zeros(N,max_iter,dim);
for iter=1:max_iter
 
 for i=1:N %Calculate all the objective values first
 Particles_F(i,:)=ObjectiveFunction(Ant_Position(:,i)');
 if dominates(Particles_F(i,:),Elite_fitness)
 Elite_fitness=Particles_F(i,:);
 Elite_position=Ant_Position(:,i);
 end
 end
 
 [Archive_X, Archive_F, Archive_member_no]=UpdateArchive(Archive_X, Archive_F, Ant_Position, Particles_F, Archive_member_no);
 
 if Archive_member_no>ArchiveMaxSize
 Archive_mem_ranks=RankingProcess(Archive_F, ArchiveMaxSize, obj_no);
 [Archive_X, Archive_F, Archive_mem_ranks, Archive_member_no]=HandleFullArchive(Archive_X, Archive_F, Archive_member_no, Archive_mem_ranks, ArchiveMaxSize);
 else
 Archive_mem_ranks=RankingProcess(Archive_F, ArchiveMaxSize, obj_no);
 end
 
 Archive_mem_ranks=RankingProcess(Archive_F, ArchiveMaxSize, obj_no);
 
 % Chose the archive member in the least population area as arrtactor
 % to improve coverage
 index=RouletteWheelSelection(1./Archive_mem_ranks);
 if index==-1
index=1;
 end
 Elite_fitness=Archive_F(index,:);
 Elite_position=Archive_X(index,:)';
 
 Random_antlion_fitness=Archive_F(1,:);
 Random_antlion_position=Archive_X(1,:)';
 
 for i=1:N
 
 index=0;
 neighbours_no=0;
 
 RA=Random_walk_around_antlion(dim,max_iter,lb,ub, Random_antlion_position',iter);
 
 [RE]=Random_walk_around_antlion(dim,max_iter,lb,ub, Elite_position',iter);
 
 Ant_Position(:,i)=(RE(iter,:)'+RA(iter,:)')/2;
 
 
 
 Flag4ub=Ant_Position(:,i)>ub';
 Flag4lb=Ant_Position(:,i)<lb';
 
Ant_Position(:,i)=(Ant_Position(:,i).*(~(Flag4ub+Flag4lb)))+ub'.*Flag4ub+lb'.*Flag4lb;
 
 end
 display(['At the iteration ', num2str(iter), ' there are ', num2str(Archive_member_no), ' non-dominated solutions in the archive']);
end
figure
plot(Archive_F(:,2),Archive_F(:,3),'ko','MarkerSize',8,'markerfacecolor','k');
%legend('True PF','Obtained PF');
%xlabel('Net power (MW)')
ylabel('Exergy Efficiency (%)')
xlabel('C02 Emmission (gr/MJ)')
title('MOALO Pareto Front for Exergy Efficiency vs CO2 Emission');
set(gcf, 'pos', [403 466 230 200])