function DisIRS2UE=caldisirsue(IRSloca,UElocation,U)

         DisIRS2UE=zeros(U,1);
         for i=1:2
             DisIRS2UE(i)=norm(IRSloca-UElocation(i,:));
         end

         