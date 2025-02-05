function [lb, ub, dim, fobj] = Get_Functions_details_Qcc(F)

switch F
    case 'Qcc'  % Cooling Capacity Optimization
        fobj = @Cooling_Capacity;
        
        % Define lower and upper bounds based on your decision variable table
        lb = [65, 22, 10, 0.8, 0.2, 0.8, 0.8, 2000, 2000, 10000];
        ub = [95, 36, 20, 2.2, 1.4, 2.2, 2.2, 10000, 10000, 10000];
        
        % Number of decision variables
        dim = length(lb);
end

end

% Objective Function: Cooling Capacity Qcc
function Qcc = Cooling_Capacity(x)
    % Extract decision variables
    T_hw_in = x(1);   % Hot water inlet temperature [°C]
    T_cw_in = x(2);   % Cold water inlet temperature [°C]
    T_chw_in = x(3);  % Chilled water inlet temperature [°C]
    m_hw = x(4);      % Hot water mass flow rate [kg/s]
    m_chw = x(5);     % Chilled water mass flow rate [kg/s]
    m_cw_bed = x(6);  % Bed cooling water mass flow rate [kg/s]
    m_cw_cond = x(7); % Condenser cooling water mass flow rate [kg/s]
    U_bed_A_bed = x(8);   % Bed heat transfer coefficient × Area [W/K]
    U_evap_A_evap = x(9); % Evaporator heat transfer coefficient × Area [W/K]
    U_cond_A_cond = x(10); % Condenser heat transfer coefficient × Area [W/K]

    % Cooling capacity equation
    Qcc = -64.6199 + ...
          0.3107 * T_hw_in - 0.8625 * T_cw_in + 0.7601 * T_chw_in + ...
          0.6108 * m_hw + 0.9944 * m_cw_bed + 4.4533 * m_chw + ...
          0.5967 * m_cw_cond + 0.0006 * U_bed_A_bed + ...
          0.0003 * U_evap_A_evap + 2.6623e-5 * U_cond_A_cond;
      Qcc = -Qcc;
end
% CALL WITH [lb, ub, dim, fobj] = Get_Functions_details_Qcc('Qcc')