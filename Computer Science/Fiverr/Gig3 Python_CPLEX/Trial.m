clc;clear all;

%% Sets (Solar Production):
T = 1; %Periods of 15 mimites for each day of the year 
t=1:T;
dt = 1; % hours
N_ps = 1; %N: Number of solar panels
n_ps = 1:N_ps; % Number of solar panels
%Parameters (Solar Production):
G_ps_STC = 100; % Irradiation solaire a condition STC (W/m2)
k_ps = -0.38; %Temperature coefficient
P_ps_STC = 327; %Rated power of solar panels at STC condition (W)
T_ps_STC = 25; %Temperature at STC condition (?C)
T_ps_NOCT = 45; %Cell operating temperature at STC condition (?C)
eta_ps = 20; %Yield - Efficiency of solar panels (%)
% Need data
G_ps(t) = 1; %Radiation in each t ? T (W/m?)
T_c(t) = 1; %Cell temperature in each t ? T (?C)
T_a(t) = 1; %Ambient temperature in each t ? T (?C)
%P_ps(n_ps,t); %Power of the panels n_ps ? N_ps, during the period t ? T (W)
%Constraints (Solar Production):
T_c(t) = T_a(t) + (T_ps_NOCT - T_ps_STC)/G_ps_STC * G_ps(t); %(1.6)
P_ps(t) = eta_ps * P_ps_STC * (G_ps(t)/G_ps_STC) * (1 + k_ps * (T_c(t) - T_ps_STC)); %(1.5)

%Sets (Wind Production):
N_wt = 1; %Number of wind generators
n_wt = 1:N_wt; % Number of wind turbines
%Parameters (Wind Production):
CP_wt = 0.5; % Power coefficient, in the best case, CP? 0.59
P_wt_nom = 7000; % Nominal wind generator power (W)
S_wt = 2.35; % Airflow area, measured in a plane perpendicular to the direction of wind speed (m?)
V_wt_dem =3; % Starting speed (m/s)
V_wt_nom = 10; % Nominal wind speed (m/s)
V_wt_arr = 50; % Stop speed (m/s)
eta_wt = 0.8; % Yield - Efficiency of wind turbines (%)
rho_a = 1.2; % The density of air (kg/m?)
% Need data
V_wt(t)=1; % Wind speed in the storm period T (m/s)
%P_wt(n_wt,t); % Power of wind generators nwt ? Nwb during the period te T (W) (2.4)
%Constraints (Wind Production):
if (V_wt(t) < V_wt_dem) 
    P_wt(t)=0;
elseif (V_wt_dem <= V_wt(t) <= V_wt_nom) 
    P_wt(t) = eta_wt * 0.5 * rho_a * S_wt * V_wt(t) * V_wt(t) * V_wt(t) * CP_wt;  
elseif (V_wt_nom <= V_wt(t) <= V_wt_arr) 
    P_wt(t) = P_wt_nom;
elseif (V_wt_arr <= V_wt(t)) 
    P_wt(t)=0;
end

%% Sets (Distribution Network):
%Parameters (Distribution Network):
%Tarrif D
P_TD_max = 50; %Maximum power that the consumer can have with tariff D (kW)
pi_TD_en1 = 0.0670; %Energy price for the first 40 kWh of a month with rate D ($CAD/kWh)
pi_TD_en2 = 0.1034; % Energy price after 40 kWh of consumption in one month with rate D ($CAD/kWh)
pi_TD_acc = 0.4481; % Network access charge for each day ($CAD/kWh)
%Winter credit
M_CH_HP(t) = 0/1; % Critical points matrix 1 indicates that HQ mentioned that it is a winter point, O that it is not
pi_CH_ene = 0.5513; % Energy price for the kilowatt hour of energy removed ($CAD/kWh), the reduction should be more than 2 kilowatt hours
%P_res(t) % Power of the Distribution Network, during the period te T (W)
%Constraints (Distribution Network):
%sum(t=1 to T)HP_CH(t) * dt = 100; % Maximum duration of events per winter period (hours)
%0<=P_res(t)<=P_TD_max;

%% Sets (Electric Vehicles):
N_ve = 1; % Number of electric vehicles (which operate on a battery)
n_ve = 1:N_ve;
%Parameters (Electric Vehicles):
EV_ve = 40000; % Electric vehicle battery capacity (Wh)
P_ve_ch_max = 10000; % Maximum charging power of the electric vehicle battery
P_ve_dch_max = 10000; % Maximum discharge power of the electric vehicle battery (Wh)
SOC_ve_max = 80; % Maximum electric vehicle battery condition (%)
SOC_ve_min = 20; % Minimum electric vehicle battery condition (%)
SOC_ve_soh = 50; % Minimum desired state of the electric vehicle battery (%)
eta_ve_ch = 90; % Inverter battery charging efficiency
eta_ve_dch= 90; % UPS battery discharge efficiency
%M_ve_con(t); % Electric vehicle connection status matrix: 1 indicates a busy state, 0 a free state.
t_arrive = 1; % Need data
t_depart = 1; % Need data
zeta = 1; % Need data
SOC_ve(t_arrive) = zeta; % State of the electric vehicle battery at the time of arrival V n_ve E N_ve (%), (Gaussian random]
SOC_ve(t_depart) = zeta; % State of the electric vehicle battery at the time of departure V n_ve E N_ve (%)
delta_ve_ch(t) = 1; % charging state On/off for vehicle battery charging electric to n., EN, AND SOC (departure)
delta_ve_dch(t) = 1; % discharge state On/off binary parameter for discharging the electric vehicle battery to n EN, AND
%Decision Variables (Electric Vehicles):
%P_ve_ch(n_ve,t); % Charging power of the battery of the electric vehicle no E N during the period te T (W)
%P_ve_dch(n_ve,t); % Discharge power of the electric vehicle battery ni E N during the period t ET (W)
%SOC_ve(n_ve,t); % State of charge of the battery of electric vehicle n, E N., during the period t ET (%)
% Constraints (Electric vehicles)
M_ve_con(t) = 1;
delta_ve_dch(t) = 1 - delta_ve_dch(t);
P_ve_ch(t) = (P_ve_ch_max/eta_ve_ch) * delta_ve_ch(t);
P_ve_dch(t) = (P_ve_dch_max * eta_ve_dch) * delta_ve_dch(t);
SOC_ve(t) = SOC_ve_max;
SOC_ve(t_arrive) = SOC_ve_max;
SOC_ve(t_depart) = SOC_ve_max;
if (M_CH_HP(t) == 0)
    delta_ve_ch(t) = 1;
elseif (M_CH_HP(t) == 1)
    delta_ve_dch(t) = 1;
end
SOC_ve(t+dt) = SOC_ve(t) + (eta_ve_ch * P_ve_ch(t) - P_ve_dch(t) / eta_ve_dch) * dt; 

%% Set (Batteries)
N_bat = 1; % Number of batteries
n_bat = 1:N_bat; % Number of batteries
%Parameters (Batteries):
E_bat = 19200; %Battery capacity (Wh)
E_bat_ch_max= 10000; %Maximum battery charging power (Wh)
E_bat_dch_max = 10000; %Maximum battery discharge power (Wh)
P_bat_ch_max= 1; %Need data
P_bat_dch_max = 1; %Need data
SOC_bat_max = 80; %Maximum Battery Status (%)
SOC_bat_min = 20; %Minimum Battery Condition (%)
eta_bat_ch = 90; %UPS battery charging efficiency
eta_bat_dch = 90; %UPS battery discharge efficiency
SOC_bat(1) = SOC_bat_max; %Battery status at moment t=0 E N_bat (%)=1 
delta_bat_ch(t) = 1; % charge state Ootherwise: On/off binary parameter for battery charging at ENET.(batt) =(1
delta_bat_dch(t) = 0; % discharge state 10otherwise: On/off binary parameter for batterydischarge at no ENET.
%Decision Variables (Batteries):
%P_bat_ch(n_bat,t); %Battery charging power at E NET(W)
%P_bat_dch(n_bat,t); %Battery discharge power at EET (W)
%SOC_bat(n_bat,t); %State of charge of the battery at nour & NastET (%)
%Constraints (Batteries)
if (M_CH_HP(t) == 0)
    delta_bat_ch(t) = 1; 
end
if (M_CH_HP(t) == 0)
    delta_bat_dch(t) = 1;
end
delta_bat_dch(t) = 1 - delta_bat_dch(t);
P_bat_ch(t) = (P_bat_ch_max / eta_bat_ch) * delta_bat_ch(t);
P_bat_dch(t) = (P_bat_dch_max * eta_bat_dch) * delta_bat_dch(t);
SOC_bat(t) = SOC_bat_max;
SOC_bat(t+dt) = SOC_bat(t) + (eta_bat_ch * P_bat_ch(t) - P_bat_dch(t)/eta_bat_dch) * dt;

%% Sets (Demand for housing):
N_dem = 1; % Number of homes (demand)
n_dem = 1:N_dem;
N_anc = 1; % Number of non-controllable appliances (lighting, refrigerators, electric stove, television, computers and others)
N_ac = 1; % Number of controllable appliances (HVAC: Heating,ventilation and air conditioning, WH: Water heater and DCH:Shower)
% Parameters (Housing demand):
P_anc(t) = 1; % Need data Energy consumption power of non-controllable devices (w)
P_ac(t) = 1; % Need data Energy consumption power of controllable devices (w)
% Controllable Devices
% Heating, ventilation and air conditioning (HVAC)
%Parameters (HVAC):
C_it = 3.6; % Thermal capacity (kWh/?C)
P_cha_nom = 3000; %Rated heating power (W)
P_cli_nom = 3000; %Need data Rated heating power (W)
P_cha_m2 = 60; %Heating power per square meter (W/m?)
R_it = 4; %Thermal resistance (?C/kW)
T_cha_sou = 1; % Need data Desired temperature with heating (?C)
T_cli_sou = 14; % Desired temperature with air conditioning (?C)
Zm_tem = 2; %Dead zone of the set temperature (?C)
alpha_hvac = exp(-dt/(R_it * C_it)); % HVAC thermal inertia
eta_cha = 90; % Yield - Heating efficiency (%) :
eta_cli = 90; % Yield - Cooling efficiency (%)
T_hvac(1) = 1; % Need data Initial temperature of homes at time t=0 VIET (?C)
S_hab(n_dem) = 1; %Need data Surface area of ??each dwelling (m?)
T_a(t)= 1; % Need dataAmbient temperature in each te T (?C)
delta_cha(t) = 1; % 1 on state otherwise: Binary on/off parameter for heating operation at n_dem ? ?_dem t ? ?
delta_cli(t) = 1; % 1 on state = O otherwise: Binary on/off parameter for air conditioning operation at n_dem E N_dem t E T
%Decision Variables (HVAC Demand):
%T_hvac(t) % Temperature control of homes in each te T (?C)
%P_cha(n_dem,t) % Heating energy consumption power na E NET (w)
%P_cli(n_dem,t) % ENET air conditioning energy consumption power(w)
% Constraints (HVAC demand):
delta_cha(t) = 1 - delta_cli(t);
P_cha(t) = eta_cha * P_cha_nom;
P_cli(t) = eta_cli * P_cli_nom;  
T_HVAC(t) = T_cha_sou + Zm_tem;
T_HVAC(t) = T_cli_sou + Zm_tem;
T_hvac(t+dt) = alpha_hvac * T_hvac(t) + (1-alpha_hvac) * (T_a(t) - (R_it*eta_cli*P_cli(t))*delta_cli(t) + (-R_it*eta_cha*P_cha(t))*delta_cha(t));

%Water heater model (EWH)
C_eau = 4.2157; % The specific heat of water (kJ/kg ?C)
P_ewh_max = 3900; % Maximum power consumption of the EWH (w)
P_ewh_min = 1500; % Maximum power consumption of EWH (w)
R_ewh = 0.3472; %Thermal insulation (m?. ?Ch/kJ)
S_ewh = 2.28; % The surface of the tank (h=1.2 m and r=0.5 m) (m?)
T_eau_sou = 37; % Desired temperature with the water heater (?C)
V_ewh = 0.2356; % Capacity of the water tank (h=1.2 m and r=0.5 m) (m?)
Zce_tem = 2; % Dead zone of the heating-water setpoint temperature (?C)
rho_eau = 1000; % The density of water (kg/m?)
D_eau(t) = 1; % Need data Water demand VtET (m?/Ath)
T_hab(t) = 1; % Need data The ambient temperature of the home (?C)
T_eau_in(t) = 1; % Need data The temperature of the incoming cold water (?C)
T_ewh(1) = T_eau_in(t); % Initial water heater temperature at time t=0vtET(?C)
G_ewh = 1; %Need data
C_mt = rho_eau * V_ewh * C_eau; % Equivalent thermal mass (kJ/?C)
E_ewh = S_ewh/R_ewh; % The ratio of surface area to thermal resistance of the tank
F_ewh = 1/(G_ewh(t)+E_ewh); % Need data
alpha_ewh = exp(-dt/(F_ewh*C_mt)); %Thermal inertia EWH
P_ewh(t) = P_ewh_max;
G_ewh(t) = rho_eau * C_eau * D_eau(t);
Q_ewh(t) = 3.4121 * 1000 * P_ewh(t);
%Decision Variables (EWH Request):
%T_ewh(t) %The temperature of the hot water inside the tank EWH, t ET (?C)
%P_ewh(n_dem,t) % Water heating energy consumption power ENE T (w)
%Constraints (EWH Demand):
T_ewh(t) = T_eau_sou + Zce_tem;  % Thermostat set point water heater
T_ewh(t) = alpha_ewh * T_ewh(2*t-dt) + (1-alpha_ewh) *  (E_ewh * F_ewh(t) * T_hab(t) + G_ewh(t)*F_ewh(t)*T_eau_in(t) + Q_ewh(t)*F_ewh(t));
