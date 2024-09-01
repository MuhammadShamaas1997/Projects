function [Vbar]=calVbarr2(n1,n2,M1,M2,M3,M4,K_t1,H1,M,Pris,epsilon,R1_line_1,R2_line_1,R1_line_2,R2_line_2,sigma1,sigmaz,Z,T_t1,G,R,U,tau_u,mu_u)
    %%%% Adjust the input scale of CVX to ensure its performance
    Pris=1e6*Pris;
    M3=1e3*M3;
    M4=1e3*M4;
    R=1e6*R;
    sigma1=1e3*sigma1;
    sigmaz=sigmaz*1e4;
    R1_line_1=R1_line_1*1e8;
    R2_line_1=R2_line_1*1e8;
    R1_line_2=R1_line_2*1e8;
    R2_line_2=R2_line_2*1e8;
    H1=H1*1e1;
    h1_1=H1(:,1);
    h1_2=H1(:,2);
    cvx_begin quiet
    variable Vbar(M+1,M+1) hermitian semidefinite;
    variable tau nonnegative
    variable meu(U, 1) nonnegative
    maximize (tau)
    subject to
    square_pos(norm(M3*reshape(Vbar(1:M,1:M),[],1)))+square_pos(norm(M4*reshape(Vbar(1:M,1:M),[],1)))+real(trace(G*R*G'*diag(diag(Vbar(1:M,1:M)))))+(sigma1^2+sigma1^2)*real(trace(diag(diag(Vbar(1:M,1:M)))))<=Pris;
    
    for j = 1:U
        denom = 0;
        for u = 1:U
            if u ~= j
                denom=denom+real(trace(R1_line_1*Vbar))-real(trace(R2_line_1*Vbar))+sigma1^2*real((trace(h1_1*h1_1'*diag(diag(Vbar(1:M,1:M)))))+sigmaz^2);
            end
            meu(j) >= denom;
            tau_u * square_pos(meu(j))/ (2 * mu_u(j)) + mu_u(j) * square_pos(tau) / (2 * tau_u) <= real(trace((R2_line_1+R2_line_2)*Vbar)) ;
            tau >= epsilon;
        end
    end
    (2*real(reshape(Vbar(1:M,1:M),[],1)'*n1)-square_pos(norm(M1*reshape(Vbar(1:M,1:M),[],1)))-real((n2')*reshape(Vbar(1:M,1:M),[],1))...
            -sigma1^2*real(trace(T_t1*G'*diag(diag(Vbar(1:M,1:M)))*G))/(1e6)-real(trace(K_t1*diag(diag(Vbar(1:M,1:M)))))-square_pos(norm(M2*reshape(Vbar(1:M,1:M),[],1))))>=epsilon;
    diag(Vbar)<=10^4;
    trace(Z*Vbar)==1;
    cvx_end
