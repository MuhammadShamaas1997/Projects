from docplex.mp.model import Model
import numpy as np
import math

# Sets and parameters initialization
n_ps = 1  # Number of solar panels
n_wt = 1  # Number of wind turbines
n_bat = 1  # Number of batteries
n_ve = 1  # Number of electric vehicles
n_dem = 1  # Number of homes (demand)
T = range(35040)  # Periods of 15 minutes for each day of the year
dt = 0.25  # hours

# Parameters
G_ps_STC = 100
kps = -0.38
P_ps_STC = 327
T_ps_STC = 25
T_ps_NOCT = 45
eta_ps = 0.20
CP_wt = 0.5
P_wt_nom = 7000
S_wt = 2.35
V_wt_dem = 3
V_wt_nom = 10
V_wt_arr = 50
eta_wt = 0.8
rho_a = 1.2
P_TD_max = 50000
pi_TD_en1 = 0.0670
pi_TD_en2 = 0.1034
pi_TD_acc = 0.4481
pi_CH_ene = 0.5513
SOC_ve_max = 80
SOC_ve_min = 20
SOC_ve_soh = 50
eta_ve_ch = 0.90
eta_ve_dch = 0.90
E_bat = 19200
E_bat_ch_max = 10000
E_bat_dch_max = 10000
SOC_bat_max = 80
SOC_bat_min = 20
eta_bat_ch = 0.90
eta_bat_dch = 0.90
C_it = 3.6
P_cha_nom = 3000
P_cli_nom
R_it = 4
T_cha_sou = 20
T_cli_sou = 14
Zm_tem = 2
eta_cha = 0.90
eta_cli = 0.90
C_eau = 4.2157
P_ewh_max = 3900
P_ewh_min = 1500
R_ewh = 0.3472
S_ewh = 2.28
T_eau_sou = 37
V_ewh = 0.2356
Zce_tem = 2
rho_eau = 1000
w_c = 0.8
w_it = 0.1
w_u = 0.1
pi_bat_deg = 0.1
pi_ve_deg = 0.1
P_ve_ch_max = 10000
P_ve_dch_max = 10000 
alpha_hvac = math.exp(-dt/(R_it * C_it))
D_eau(t)
G_ewh(t) = rho_eau * C_eau * D_eau(t)
E_ewh = S_ewh/R_ewh
F_ewh = 1/(G_ewh(t)+E_ewh)
C_mt = rho_eau * V_ewh * C_eau
alpha_ewh = math.exp(-dt/(F_ewh(t)*C_mt))
Q_ewh(t) = 3.4121 * 1000 * P_ewh(t)

# Model setup
mdl = Model(name="Energy Optimization")

# Decision variables
P_res = mdl.continuous_var_list(T, name="P_res", lb=0, ub=P_TD_max)
SOC_ve = mdl.continuous_var_list(T, name="SOC_ve", lb=SOC_ve_min, ub=SOC_ve_max)
P_ve_ch = mdl.continuous_var_list(T, name="P_ve_ch", lb=0, ub=P_ve_ch_max)
P_ve_dch = mdl.continuous_var_list(T, name="P_ve_dch", lb=0, ub=P_ve_dch_max)
SOC_bat = mdl.continuous_var_list(T, name="SOC_bat", lb=SOC_bat_min, ub=SOC_bat_max)
P_bat_ch = mdl.continuous_var_list(T, name="P_bat_ch", lb=0, ub=E_bat_ch_max)
P_bat_dch = mdl.continuous_var_list(T, name="P_bat_dch", lb=0, ub=E_bat_dch_max)
P_cha = mdl.continuous_var_list(T, name="P_cha", lb=0, ub=eta_cha * P_cha_nom)
P_cli = mdl.continuous_var_list(T, name="P_cli", lb=0, ub=eta_cli * P_cli_nom)
P_ewh = mdl.continuous_var_list(T, name="P_ewh", lb=P_ewh_min, ub=P_ewh_max)
T_hvac = mdl.continuous_var_list(T, name="T_hvac")
T_ewh = mdl.continuous_var_list(T, name="T_ewh")
P_dem = mdl.continuous_var_list(T, name="P_dem")
P_ps = mdl.continuous_var_list(T, name="P_ps")
P_wt = mdl.continuous_var_list(T, name="P_wt")
dP_BAL = mdl.continuous_var_list(T, name="dP_BAL", lb=0)

# Objective function
objective = w_c * (mdl.sum(pi_TD_en1 * P_res[t] for t in T) -
                   mdl.sum(pi_CH_ene * P_res[t] for t in T) +
                   pi_ve_deg * mdl.sum(P_ve_ch[t] + P_ve_dch[t] for t in T) +
                   pi_bat_deg * mdl.sum(P_bat_ch[t] + P_bat_dch[t] for t in T)) + \
            w_it * mdl.sum(T_hvac[t] for t in T) + \
            w_u * mdl.sum(T_ewh[t] for t in T)

mdl.minimize(objective)

# Constraints
for t in T:
    # Power balance constraint
    mdl.add_constraint(dP_BAL[t] == P_ps[t] + P_wt[t] + P_res[t] +
                       P_ve_dch[t] + P_bat_dch[t] - 
                       (P_ve_ch[t] + P_bat_ch[t] + P_dem[t]))
    
    # Electric vehicle constraints
    if t < len(T) - 1:
        mdl.add_constraint(SOC_ve[t+1] == SOC_ve[t] + 
                           (eta_ve_ch * P_ve_ch[t] - P_ve_dch[t] / eta_ve_dch) * dt)
    
    # Battery constraints
    if t < len(T) - 1:
        mdl.add_constraint(SOC_bat[t+1] == SOC_bat[t] + 
                           (eta_bat_ch * P_bat_ch[t] - P_bat_dch[t] / eta_bat_dch) * dt)
    
    # HVAC constraints
    if t < len(T) - 1:
        mdl.add_constraint(T_hvac[t+1] == alpha_hvac * T_hvac[t] + 
                           (1 - alpha_hvac) * (T_a[t] - (R_it * eta_cli * P_cli[t] * delta_cli[t]) + 
                                               (-R_it * eta_cha * P_cha[t] * delta_cha[t])))

    # Water heater constraints
    if t < len(T) - 1:
        mdl.add_constraint(T_ewh[t+1] == alpha_ewh * T_ewh[t] + 
                           (1 - alpha_ewh) * (E_ewh * F_ewh[t] * T_hab[t] + 
                                              G_ewh[t] * F_ewh[t] * T_eau_in[t] + 
                                              Q_ewh[t] * F_ewh[t]))

# General constraints
mdl.add_constraints(0 <= P_res[t] <= P_TD_max for t in T)

# Solve the model
solution = mdl.solve()

if solution:
    print(f"Objective value: {solution.objective_value}")
    for t in T[:10]:  # Printing first 10 time periods for brevity
        print(f"Time {t}: P_res = {solution[P_res[t]]}, SOC_ve = {solution[SOC_ve[t]]}, SOC_bat = {solution[SOC_bat[t]]}")
else:
    print("No solution found")
