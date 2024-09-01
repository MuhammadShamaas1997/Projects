function UElocation=generaUEloca(UE1cenloca,UE2cenloca,Radius,U)
         UElocation=zeros(U,2);
         for u=1:U
             if u==1
                 r=sqrt(rand)*Radius;
                 theta=2*pi*rand;
                 UElocation(u,1)=UE1cenloca(1)+r*cos(theta);
                 UElocation(u,2)=UE1cenloca(2)+r*sin(theta);               
             else
                 r=sqrt(rand)*Radius;
                 theta=2*pi*rand;
                 UElocation(u,1)=UE2cenloca(1)+r*cos(theta);
                 UElocation(u,2)=UE2cenloca(2)+r*sin(theta);
             end
         end
             
end
         