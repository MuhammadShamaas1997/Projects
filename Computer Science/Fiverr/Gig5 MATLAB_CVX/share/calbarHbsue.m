function barHbsue=calbarHbsue(Phi,Hbsue,Hbsirs,Hirsue,U,N)
         barHbsue=zeros(N,U);
                 for u=1:U
                     barHbsue(:,u)=(Hirsue(:,u)'*Phi*Hbsirs+Hbsue(:,u)')';
                 end
end

          
          
         
         