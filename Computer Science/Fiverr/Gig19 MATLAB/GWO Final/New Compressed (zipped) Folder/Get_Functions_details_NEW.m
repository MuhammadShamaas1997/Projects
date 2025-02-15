% Define bounds and objective function details
function [lb, ub, dim, fobj] = Get_Functions_details_NEW(F)

    % Define lower and upper bounds based on your table
    lb = [65, 22, 10, 7, 0.8, 0.8, 0.2, 2000, 2000, 10000]; % Lower bounds
    ub = [95, 36, 20, 12, 2.2, 2.2, 1.4, 10000, 10000, 10000]; % Upper bounds

    % Number of decision variables (dimensionality)
    dim = 10;

    switch F
        case 'COP'
            fobj = @COP_Objective;
        case 'Qcc'
            fobj = @Qcc_Objective;
        case 'Eta_e'
            fobj = @Eta_e_Objective;
    
        % Add other cases if needed
    end

end

% COP Objective Function
function COP = COP_Objective(x)
    % Decision variables
    T_hw_in = x(1);
    T_cw_in = x(2);
    T_chw_in = x(3);
    m_hw = x(4);
    m_cw_bed = x(5);
    m_chw = x(6);
    m_cw_cond = x(7);
    Ubed_A_bed = x(8);
    Uevap_A_evap = x(9);
    Ucond_A_cond = x(10);

    % COP equation
    COP = -(-1.1469 ...
          + 0.0014 * T_hw_in ...
          - 0.0085 * T_cw_in ...
          + 0.0124 * T_chw_in ...
          + 0.0050 * m_hw ...
          + 0.0099 * m_cw_bed ...
          + 0.0793 * m_chw ...
          + 0.0092 * m_cw_cond ...
          + 5.0687e-6 * Ubed_A_bed ...
          + 5.2952e-6 * Uevap_A_evap ...
          + 4.6260e-7 * Ucond_A_cond);

end
% [lb, ub, dim, fobj] = Get_Functions_details_NEW('COP')

% Cooling Capacity Objective Function
function Qcc = Qcc_Objective(x)
    % Decision variables
    T_hw_in = x(1);
    T_cw_in = x(2);
    T_chw_in = x(3);
    m_hw = x(4);
    m_cw_bed = x(5);
    m_chw = x(6);
    m_cw_cond = x(7);
    Ubed_A_bed = x(8);
    Uevap_A_evap = x(9);
    Ucond_A_cond = x(10);

    % Qcc equation
    Qcc = -(-64.6199 ...
          + 0.3107 * T_hw_in ...
          - 0.8625 * T_cw_in ...
          + 0.7601 * T_chw_in ...
          + 0.6108 * m_hw ...
          + 0.9944 * m_cw_bed ...
          + 4.4533 * m_chw ...
          + 0.5967 * m_cw_cond ...
          + 6e-4 * Ubed_A_bed ...
          + 3e-4 * Uevap_A_evap ...
          + 2.6623e-5 * Ucond_A_cond);
end
% [lb, ub, dim, fobj] = Get_Functions_details_NEW('Qcc')

% Waste Heat Recovery Efficiency Objective Function
function Eta_e = Eta_e_Objective(x)
    % Decision variables
    T_hw_in = x(1);
    T_cw_in = x(2);
    T_chw_in = x(3);
    m_hw = x(4);
    m_cw_bed = x(5);
    m_chw = x(6);
    m_cw_cond = x(7);
    Ubed_A_bed = x(8);
    Uevap_A_evap = x(9);
    Ucond_A_cond = x(10);

    % Eta_e equation
    Eta_e = -(-0.2347 ...
          - 0.0003 * T_hw_in ...
          - 0.0019 * T_cw_in ...
          + 0.0026 * T_chw_in ...
          + 0.0277 * m_hw ...
          + 0.0034 * m_cw_bed ...
          + 0.0150 * m_chw ...
          + 0.0019 * m_cw_cond ...
          + 2.0286e-6 * Ubed_A_bed ...
          + 1.0279e-6 * Uevap_A_evap ...
          + 6.8084e-8 * Ucond_A_cond);

end
% [lb, ub, dim, fobj] = Get_Functions_details_NEW('Eta_e')