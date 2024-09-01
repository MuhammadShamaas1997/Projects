function [wc, SINR_u, tau_u,SINR_t] = feasiblecheck(U, h_u, wc, wr, M, Hirsue, Phi, G, A, beta2, sigmaz, sigma1, SINR_threshold,v_t,H_t,H_z0,H_z1,sigmat,Pbs,Pris)
    % Initialize the SINR vector
    SINR_u = zeros(1, U);
    %SINR_t() = zeros(1, 1);
    Wc=wc*wc';
    Wr=wr*wr';
    W=trace(Wc)+trace(Wr);
    count = 1;
    max_iter = 1000; % Maximum number of iterations
    iter = 0; % Iteration counter

    while count >= 1 && iter < max_iter
        count = 0;
        iter = iter + 1;
%         for m = 1:M
%             while norm(Phi(m,1 ))^2 > 1 && norm(Phi*G*W)^2+ beta2*norm(Phi*A*A'*Phi*G*W)^2+ beta2*norm(Phi*A*A'*Phi)^2*sigma1^2+norm(Phi)^2*(sigma1^2+sigma1^2)> Pris
%             Phi(m,1) = randn(1,1)+1i*randn(1,1);
%             end
%         end

        for u = 1:U
            % Calculate numerator (signal power for user u)
            num = abs(h_u(:, u)' * wc(:, u))^2;

            % Calculate denominator (interference + noise power)
            denom = 0;
            for j = 1:U
                if j ~= u
                    denom = denom + abs(h_u(:, u)' * wc(:, j))^2;
                end
            end

            % Include the interference from radar beamforming vectors
            denom = denom + abs(h_u(:, u)' * wr).^2;

            % Add noise power
            denom = denom + sigmaz^2;

            % Include the ARIS noise power term
            denom = denom + norm(Hirsue' * Phi, 'fro')^2 * sigma1^2;

            % Calculate SINR
            SINR_u(u) = num / denom;
        end

        % Calculate tau_u (minimum SINR)
        tau_u = min(SINR_u);
        num_t = abs(beta2 * v_t * H_t * wr).^2; 
       den_t = 0;
       for u = 1:U
           den_t = den_t + beta2 * norm(v_t * H_t*wc(:, u))^2;
       end
       H_z0_t = (beta2 * norm(v_t * H_z0)).^2 * sigma1; 
       H_z1_t = (norm(v_t * H_z1)).^2 * sigma1; 
       n_r_t = norm(v_t)^2 * sigmat; 
       den_t = den_t + H_z0_t + H_z1_t + n_r_t; 
       SINR_t = num_t / den_t; 

        % Check if tau_u is below the threshold
        if tau_u < SINR_threshold && W > Pbs && norm(Phi*G*W)^2+ beta2*norm(Phi*A*A'*Phi*G*W)^2+ beta2*norm(Phi*A*A'*Phi)^2*sigma1^2+norm(Phi)^2*(sigma1^2+sigma1^2)> Pris % Satisfy Base station and PRIS power constraint
            % Increment the count to indicate a reinitialization is needed
            count = count + 1;
          

            % Reinitialize beamforming vectors
            wc = randn(size(wc)) + 1i * randn(size(wc));
            wr = randn(size(wr)) + 1i * randn(size(wr));
             Wc=wc*wc';
             Wr=wr*wr';
             W=trace(Wc)+trace(Wr);
             
        else
            % If all SINRs are above the threshold, exit the loop
            disp('Feasible solution found.');
            break;
        end
    end

    % Display the iteration count if it reaches the maximum
    if iter == max_iter
        disp('Maximum iterations reached without finding a feasible solution.');
    end
end
