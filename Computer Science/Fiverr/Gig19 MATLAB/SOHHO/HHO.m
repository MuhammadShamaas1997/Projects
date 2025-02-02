%HHO.m file - Equations 3.29 and 3.30 were used to obtain the Prey’s energy. Equation 3.31 was used for exploration while equations 3.33 to 3.42 were used for exploitation. These were used to obtain the optimal decision variable and objective value.
function [Rabbit_Energy,Rabbit_Location,CNVG]=HHO(N,T,lb,ub,dim,fobj)
disp('HHO is now tackling your problem')
tic
% initialize the location and Energy of the rabbit
Rabbit_Location=zeros(1,dim);
Rabbit_Energy=inf;
%Initialize the locations of Harris' hawks
X=initialization(N,dim,ub,lb);
CNVG=zeros(1,T);
t=0; % Loop counter
while t<T
 for i=1:size(X,1)
 % Check boundries
 FU=X(i,:)>ub;FL=X(i,:)<lb;X(i,:)=(X(i,:).*(~(FU+FL)))+ub.*FU+lb.*FL;
 % fitness of locations
 fitness=fobj(X(i,:));
 % Update the location of Rabbit
 if fitness<Rabbit_Energy
 Rabbit_Energy=fitness;
 Rabbit_Location=X(i,:);
 end
 end
 
 E1=2*(1-(t/T)); % factor to show the decreaing energy of rabbit (Equation 3.29)
 % Update the location of Harris' hawks
 for i=1:size(X,1)
 E0=2*rand()-1; %-1<E0<1 (Equation 3.30)
 Escaping_Energy=E1*(E0); % escaping energy of rabbit
 if abs(Escaping_Energy)>=1
 %% Exploration:
 % Harris' hawks perch randomly based on 2 strategy:
 %Equation 3.27
 q=rand();
 rand_Hawk_index = floor(N*rand()+1);
 X_rand = X(rand_Hawk_index, :);
 if q<0.5
 % perch based on other family members
 X(i,:)=X_rand-rand()*abs(X_rand-2*rand()*X(i,:));
 elseif q>=0.5
 % perch on a random tall tree (random site inside group's home range)
 X(i,:)=(Rabbit_Location(1,:)-mean(X))-rand()*((ub-lb)*rand+lb);
 end
 
 elseif abs(Escaping_Energy)<1
 %% Exploitation:(Equation 3.33 to 3.42)
 % Attacking the rabbit using 4 strategies regarding the behavior of the rabbit
 
 %% phase 1: surprise pounce (seven kills)
 % surprise pounce (seven kills): multiple, short rapid dives by different hawks
 
 r=rand(); % probablity of each event
 
 if r>=0.5 && abs(Escaping_Energy)<0.5 % Hard besiege
 X(i,:)=(Rabbit_Location)-Escaping_Energy*abs(Rabbit_Location-X(i,:));
 end
 
 if r>=0.5 && abs(Escaping_Energy)>=0.5 % Soft besiege
 Jump_strength=2*(1-rand()); % random jump strength of the rabbit
 X(i,:)=(Rabbit_Location-X(i,:))-Escaping_Energy*abs(Jump_strength*Rabbit_Location-X(i,:));
 end
 
 %% phase 2: performing team rapid dives (leapfrog movements)
 if r<0.5 && abs(Escaping_Energy)>=0.5, % Soft besiege % rabbit try to escape by many zigzag deceptive motions
 
 Jump_strength=2*(1-rand());
 X1=Rabbit_Location-Escaping_Energy*abs(Jump_strength*Rabbit_Location-X(i,:));
 
 if fobj(X1)<fobj(X(i,:)) % improved move?
 X(i,:)=X1;
 else % hawks perform levy-based short rapid dives around the rabbit
 X2=Rabbit_Location-Escaping_Energy*abs(Jump_strength*Rabbit_Location-X(i,:))+rand(1,dim).*Levy(dim);
 if (fobj(X2)<fobj(X(i,:))), % improved move?
 X(i,:)=X2;
 end
 end
 end
if r<0.5 && abs(Escaping_Energy)<0.5, % Hard besiege % rabbit try to escape by many zigzag deceptive motions
 % hawks try to decrease their average location with the rabbit
 Jump_strength=2*(1-rand());
 X1=Rabbit_Location-Escaping_Energy*abs(Jump_strength*Rabbit_Location-mean(X));
 
 if fobj(X1)<fobj(X(i,:)) % improved move?
 X(i,:)=X1;
 else % Perform levy-based short rapid dives around the rabbit
 X2=Rabbit_Location-Escaping_Energy*abs(Jump_strength*Rabbit_Location-mean(X))+rand(1,dim).*Levy(dim);
 if (fobj(X2)<fobj(X(i,:))), % improved move?
 X(i,:)=X2;
 end
 end
 end
 %%
 end
 end
 t=t+1;
 CNVG(t)=Rabbit_Energy;
% Print the progress every 100 iterations
% if mod(t,100)==0
% display(['At iteration ', num2str(t), ' the best fitness is ', num2str(Rabbit_Energy)]);
% end
end
toc
end