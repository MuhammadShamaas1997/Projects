function [Hbsirs,Hbsue,Hirsue,Hirstg]=generatechannel2(DisBS2IRS,DisBS2UE,DisIRS2UE,DisIRS2TG,U,Mt,N,IRSloca,TGloca)
         imaginary=sqrt(-1);
         Hbsirs=zeros(N,Mt);
         Hbsue=zeros(Mt,U);
         Hirsue=zeros(N,U);
         Hirstg=zeros(N,N);
%% Calculate the pathloss between BS and RIS
             PL_LoS=-10*2.0*log10(DisBS2IRS)-31.4-10*2.1*log10(2.7)-2.9;% Sun Shu Umi SC
             Pathloss_LoS=10^(PL_LoS/10);
             n=0:Mt-1;
             theta=2*pi*rand;
             aAoDbsirs=exp(imaginary*n*pi*sin(2*pi*theta));%Random AoD
             n=0:N-1;
             theta=2*pi*rand;
             aAoAbsirs=exp(imaginary*n*pi*sin(2*pi*theta));
             Los=sqrt(Pathloss_LoS)*aAoAbsirs'*aAoDbsirs;
             Nlos=sqrt(1/2)*randn(N,Mt)+imaginary*sqrt(1/2)*randn(N,Mt); 
             PL_NLoS=-10*3.5*log10(DisBS2IRS)-24.4-10*1.9*log10(2.7)-8;% Sun Shu Umi SC
             Pathloss_NLoS=10^(PL_NLoS/10);
             Nlos=Nlos*sqrt(Pathloss_NLoS);
             Hbsirs=Los+Nlos; 
%% 计算BS和UE间的路损         
             for u=1:U
                    PL_NLoS=-10*3.5*log10(DisBS2UE(u))-24.4-10*1.9*log10(2.7)-8;% Sun Shu Umi SC
                    Pathloss_NLoS=10^(PL_NLoS/10);
                    Hbsue(:,u)=sqrt(Pathloss_NLoS)*(sqrt(1/2)*randn(1,Mt)+imaginary*sqrt(1/2)*randn(1,Mt));
             end
         
%% 计算IRS和UE间的信道
             for u=1:U
                    PL_NLoS=-10*3.5*log10(DisIRS2UE(u))-24.4-10*1.9*log10(2.7)-8;% Sun Shu Umi SC
                    Pathloss_NLoS=10^(PL_NLoS/10);
                    Hirsue(:,u)=sqrt(Pathloss_NLoS)*(sqrt(1/2)*randn(1,N)+imaginary*sqrt(1/2)*randn(1,N));
             end
%% 计算IRS和TG间的信道 点目标
             n=0:N-1;
             theta=atan(IRSloca(1)/(100-IRSloca(2)));
             aAoDbsirs=exp(imaginary*n*pi*sin(theta));
             aAoAbsirs=exp(imaginary*n*pi*sin(theta));
             Los=aAoAbsirs'*aAoDbsirs; %Toeplitz Matrix
             beta=sqrt(calbeta(DisIRS2TG));
             Hirstg=beta*Los;
end
         