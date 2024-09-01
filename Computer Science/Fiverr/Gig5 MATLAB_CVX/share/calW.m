function [W,tau,mu,SINR]=calW(barHbsue,Pbs,G,Phi,A,d,e,N,U,mu_u,epsilon,W_t,J_t,B,D,E,tau_u,Wu)
   S=Phi'*A*Phi*G;
   T=Phi*G;
   %%%% Adjust the input scale of CVX to ensure its performance
   barHbsue=barHbsue*1e4;
   d=d*1e8;
   S=S*1e3;
   T=T*1e3;
   e=e*1e6;
   mu = ones(U, 1);
   cvx_clear;
   cvx_begin 
        variable W(N,N+U) complex
        variable tau nonnegative
        variable mu(U, 1) nonnegative
        %variable tau_min
        maximize (tau)
        subject to
         square_pos(norm(W,'fro'))<=Pbs;
        (square_pos(norm(S*W,'fro')))+(square_pos(norm(T*W,'fro')))<=e;
        
       for j = 1:U
                denom = 0;
                for u = 1:U
                    if u ~= j
                        W_diff = W(:, u) - W_t(:, u);  

                        % Ensure quadratic form is scalar
                        quad_form = W_diff' * barHbsue(:, j);
                        denom = denom + real(trace(quad_form * quad_form'));
                    
                    end
                    denom=denom+d(j);
                    mu(j) >= denom;
%                   (tau_u * mu(j)^2) * (1 / (2 * mu_u(j))) + (mu_u(j) * tau.^2) * (1 / (2 * tau_u)) <= real(trace(barHbsue(:, j)' * W_t(:, j)*W_t(:, j)'*barHbsue(:, j)));
                    tau_u * square_pos(mu(j))/ (2 * mu_u(j)) + mu_u(j) * square_pos(tau) / (2 * tau_u) <=  real( trace(barHbsue(:, u)' * Wu*Wu' * barHbsue(:, u)) )  ;
                    tau >= epsilon;
                end
                
       end
           
          
   cvx_end
   SINR= real( trace(barHbsue(:, u)' * Wu*Wu' * barHbsue(:, u)))/denom;
   
%     J=D+E*W*W'*E';
% %    J=1/2*(J+J');
%    (trace(J_t^(-1)*B*W_t*W_t'*B'*J^(-1)*J))-((norm(W_t'*B'/J_t*E*W_t,'fro')))^2   
%    SNR=cvx_optval-trace(J_t^(-1)*B*W_t*W_t'*B'*J^(-1)*D);
end