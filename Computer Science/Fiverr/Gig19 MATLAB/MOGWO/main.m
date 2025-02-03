%MOGWO.m - Here the initial population, archive number, number of iteration
%and other parameters are initialized. Also, the evaluation process and plotting of the pareto graph takes
%place.
%The mogwo.m file is made to run after adding the folder to the path. All files must be saved in the same folder.
% Start the timer
tic;
drawing_flag = 1;
TestProblem='UF1';
nVar=10;
fobj = cec09(TestProblem);
%xrange = xboundary(TestProblem, nVar);
% Lower bound and upper bound
%lb=xrange(:,1)';
%ub=xrange(:,2)';
%lb=10*ones(1,nVar);
%ub=1520*ones(1,nVar);
Alb = [10];
Aub = [15];
Blb = [10];
Bub = [30];
Clb = [1520];
Cub = [1520];
Dlb = [850];
Dub = [950];
%lb=[Alb Blb Clb Dlb];
%ub=[Aub Bub Cub Dub];
lb=[[65] [22] [10] [0.8] [0.8] [0.2] [0.8] [2000] [2000] [10000]];
ub=[[95] [36] [20] [2.2] [2.2] [1.4] [2.2] [10000] [10000] [10000]];

VarSize=[1 nVar];
GreyWolves_num=100;
MaxIt=10; % Maximum Number of Iterations
Archive_size=100; % Repository Size
%alpha=0.1; % Grid Inflation Parameter
alpha=0.1;
nGrid=4; % Number of Grids per each Dimension
beta=4; %=4; % Leader Selection Pressure Parameter
gamma=2;
% Initialization
GreyWolves=CreateEmptyParticle(GreyWolves_num);
for i=1:GreyWolves_num
 GreyWolves(i).Velocity=0;
 GreyWolves(i).Position=zeros(1,nVar);
 for j=1:nVar
 GreyWolves(i).Position(1,j)=unifrnd(lb(j),ub(j),1);
 end
 GreyWolves(i).Cost=fobj(GreyWolves(i).Position')';
 GreyWolves(i).Best.Position=GreyWolves(i).Position;
 GreyWolves(i).Best.Cost=GreyWolves(i).Cost;
end
GreyWolves=DetermineDomination(GreyWolves);
Archive=GetNonDominatedParticles(GreyWolves);
Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alpha);
for i=1:numel(Archive)
 [Archive(i).GridIndex Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end
% MOGWO main loop
for it=1:MaxIt
 a=2-it*((2)/MaxIt);
 for i=1:GreyWolves_num
 
 clear rep2
 clear rep3
 
 % Choose the alpha, beta, and delta grey wolves
 Delta=SelectLeader(Archive,beta);
 Beta=SelectLeader(Archive,beta);
 Alpha=SelectLeader(Archive,beta);
 
 % If there are less than three solutions in the least crowded
 % hypercube, the second least crowded hypercube is also found
 % to choose other leaders from.
 if size(Archive,1)>1
 counter=0;
 for newi=1:size(Archive,1)
 if sum(Delta.Position~=Archive(newi).Position)~=0
 counter=counter+1;
rep2(counter,1)=Archive(newi);
 end
 end
 Beta=SelectLeader(rep2,beta);
 end
 
 % This scenario is the same if the second least crowded hypercube
 % has one solution, so the delta leader should be chosen from the
 % third least crowded hypercube.
 if size(Archive,1)>2
 counter=0;
 for newi=1:size(rep2,1)
 if sum(Beta.Position~=rep2(newi).Position)~=0
 counter=counter+1;
rep3(counter,1)=rep2(newi);
 end
 end
 Alpha=SelectLeader(rep3,beta);
 end
 
 % Eq.(3.20) in the paper
 c=2.*rand(1, nVar);
 % Eq.(3.21) in the paper
 D=abs(c.*Delta.Position-GreyWolves(i).Position);
 % Eq.(3.19) in the paper
 A=2.*a.*rand(1, nVar)-a;
 % Eq.(3.24) in the paper
 X1=Delta.Position-A.*abs(D);
 % Eq.(3.20) in the paper
 c=2.*rand(1, nVar);
 % Eq.(3.22) in the paper
 D=abs(c.*Beta.Position-GreyWolves(i).Position);
 % Eq.(3.19) in the paper
 A=2.*a.*rand()-a;
 % Eq.(3.25) in the paper
 X2=Beta.Position-A.*abs(D);
 
 
 % Eq.(3.20) in the paper
 c=2.*rand(1, nVar);
 % Eq.(3.23) in the paper
 D=abs(c.*Alpha.Position-GreyWolves(i).Position);
 % Eq.(3.19) in the paper
 A=2.*a.*rand()-a;
 % Eq.(3.26) in the paper
 X3=Alpha.Position-A.*abs(D);
 
 % Eq.(3.27) in the paper
 GreyWolves(i).Position=(X1+X2+X3)./3;
 
 % Boundary checking
 GreyWolves(i).Position=min(max(GreyWolves(i).Position,lb),ub);
 
 GreyWolves(i).Cost=fobj(GreyWolves(i).Position')';
 end
 
 GreyWolves=DetermineDomination(GreyWolves);
 non_dominated_wolves=GetNonDominatedParticles(GreyWolves);
 
 Archive=[Archive
 non_dominated_wolves];
 
 Archive=DetermineDomination(Archive);
 Archive=GetNonDominatedParticles(Archive);
 
 for i=1:numel(Archive)
 [Archive(i).GridIndex Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
 end
 
 if numel(Archive)>Archive_size
 EXTRA=numel(Archive)-Archive_size;
 Archive=DeleteFromRep(Archive,EXTRA,gamma);
 
 Archive_costs=GetCosts(Archive);
 G=CreateHypercubes(Archive_costs,nGrid,alpha);
 
 end
 
 disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
 save results
 % Results
 
 costs=GetCosts(GreyWolves);
 Archive_costs=GetCosts(Archive);
 
 if drawing_flag==1
 hold off
 
 plot(costs(1,:),costs(3,:),'k.');
 hold on
 plot(Archive_costs(1,:),Archive_costs(3,:),'bd');
 legend('Grey wolves','Non-dominated solutions');
 title('COP vs Qcc')
 xlabel('COP');
 ylabel('Qcc');
 grid on
 
 
 drawnow
 end
 
end
% Stop the timer
elapsedTime = toc;
% Display the elapsed time
disp(['Elapsed time: ', num2str(elapsedTime), ' seconds']);
