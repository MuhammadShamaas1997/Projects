function [barHbsue,B,C,D,E,d,e]=parafor_BS(Phi,Hbsue,Hbsirs,Hirsue,U,N,G,A,sigma1,sigmaz,sigmar,cancel_f,Pris)
        barHbsue=calbarHbsue(Phi,Hbsue,Hbsirs,Hirsue,U,N);
        B=G'*Phi'*A*Phi*G;
        C=G'*Phi'*A*Phi;
        D=sigma1^2*(C*C')+2*sigma1^2*G'*(Phi'*Phi)*G+sigmar^2*eye(N)+sigma1^2*(G'*Phi*Phi'*A*Phi*G+G'*Phi'*A*Phi*Phi'*G);
        E=cancel_f*G'*Phi*G;
        for u=1:U
            d(u)=Hirsue(:,u)'*(Phi*Phi')*Hirsue(:,u)*sigma1^2+sigmaz^2;
        end
        d=real(d);
        e=Pris-trace(Phi*Phi')*(sigma1^2+sigma1^2)-trace(Phi'*A*Phi*Phi'*A*Phi)*sigma1^2;
        e=real(e); 
end