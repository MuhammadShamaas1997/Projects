function DisBS2UE=caldisbsue(UElocation,BSloca,U)
         DisBS2UE=zeros(U,1);
             for u=1:U 
                 DisBS2UE(u,1)=norm(BSloca-UElocation(u,:));
             end
end