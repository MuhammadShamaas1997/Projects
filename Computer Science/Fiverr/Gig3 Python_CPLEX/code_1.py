
import pandas as pd
import numpy as np
import random as rd
import matplotlib.pyplot as plt
from gurobipy import *

#Sets (Solar Production):
n_ps = 1 # Number of solar panels
T= range(1,35040) #Periods of 15 mimites for each day of the year 
dt = 0.25 # hours
N_ps = range(1,n_ps) #N: Number of solar panels
#Parameters (Solar Production):
G_ps_STC = 100 # Irradiation solaire a condition STC (W/m2)
kps = -0.38 #Temperature coefficient
P_ps_STC = 327 #Rated power of solar panels at STC condition (W)
T_ps_STC = 25 #Temperature at STC condition (°C)
T_ps_NOCT = 45 #Cell operating temperature at STC condition (°C)
𝜂_ps = 20 #Yield - Efficiency of solar panels (%)
Gps(t) #Radiation in each t ∈ T (W/m²)
T_c(t) #Cell temperature in each t ∈ T (°C)
T_a(t) #Ambient temperature in each t ∈ T (°C)
Pps(n_ps,t) #Power of the panels n_ps ∈ N_ps, during the period t ∈ T (W)
#Constraints (Solar Production):
P_ps(t) = 𝜂𝑝𝑠 * P_ps_STC * (G_ps(t)/G_ps_STC) * (1 + k_ps(T_c(t) - T_ps_STC)) #(1.5)
T_c(t) = T_a(t) + (T_ps_NOCT - T_ps_STC)/G_ps_STC * G_ps(t) #(1.6)

#Sets (Wind Production):
T = range(1,35040) #Periods of 15 minutes for each day of the year 
dt = 0.25 #h
n_wt = 1 # Number of wind turbines
N_wt = range(0,n_wt) #Number of wind generators
#Parameters (Wind Production):
CP_wt = 0.5 # Power coefficient, in the best case, CP≈ 0.59
P_wt_nom = 7000 # Nominal wind generator power (W)
S_wt = 2.35 # Airflow area, measured in a plane perpendicular to the direction of wind speed (m²)
V_wt_dem =3 # Starting speed (m/s)
V_wt_nom = 10 # Nominal wind speed (m/s)
V_wt_arr = 50 # Stop speed (m/s)
𝜂_wt = 0.8 # Yield - Efficiency of wind turbines (%)
ρ_a = 1.2 # The density of air (kg/m³)
V_wt(t) # Wind speed in the storm period T (m/s)
P_wt(n_wt,t) # Power of wind generators nwt ∈ Nwb during the period te T (W) (2.4)
#Constraints (Wind Production):
P_wt(t) = V_wt(t) < 𝑉_dem then P_wt(t)=0
P_wt(t) = V_wt_dem <= 𝑉_wt(t) <= V_wt_nom then P_wt(t)=𝜂_wt * 0.5 * ρ_a * S_wt * V_wt(t) * V_wt(t) * V_wt(t) * CP_wt  
P_wt(t) = V_wt_nom <= V_wt(t) <= V_wt_arr then P_wt(t)=P_wt_nom
P_wt(t) = V_wt_arr <= V_wt(t) then P_wt(t)=0

#Sets (Distribution Network):
T = range(1,35040) # Periods of 15 minutes for each day of the year 
dt=0.25 # hours
#Parameters (Distribution Network):
#Tarrif D
P_TD_max=50 #Maximum power that the consumer can have with tariff D (kW)
pi_TD_en1 = 0.0670 #Energy price for the first 40 kWh of a month with rate D ($CAD/kWh)
pi_TD_en2 = 0.1034 # Energy price after 40 kWh of consumption in one month with rate D ($CAD/kWh)
pi_TD_acc = 0.4481 # Network access charge for each day ($CAD/kWh)
#Winter credit
M_CH_HP(t) = 0/1 # Critical points matrix 1 indicates that HQ mentioned that it is a winter point, O that it is not
pi_CH_ene = 0.5513 # Energy price for the kilowatt hour of energy removed ($CAD/kWh), the reduction should be more than 2 kilowatt hours
P_res(t) # Power of the Distribution Network, during the period te T (W)
#Constraints (Distribution Network):
sum(t=1 to T)HP_CH(t) * dt = 100 # Maximum duration of events per winter period (hours)
0<=P_res(t)<=P_TD_max

#Sets (Electric Vehicles):
T = range(1,35040) # Periods of 15 minutes for each day of the year 
dt = 0.25 #hours
N_ve = range(1,n_ve) # Number of electric vehicles (which operate on a battery)
#Parameters (Electric Vehicles):
EV_ve = 40000 # Electric vehicle battery capacity (Wh)
P_ve_ch_max = 10000 # Maximum charging power of the electric vehicle battery
P_ve_dch_max = 10000 # Maximum discharge power of the electric vehicle battery (Wh)
SOC_ve_max = 80 # Maximum electric vehicle battery condition (%)
SOC_ve_min = 20 # Minimum electric vehicle battery condition (%)
SOC_ve_soh = 50 # Minimum desired state of the electric vehicle battery (%)
𝜂_ve_ch = 90 # Inverter battery charging efficiency
𝜂_ve_dch= 90 # UPS battery discharge efficiency
M_ve_con(t) # Electric vehicle connection status matrix: 1 indicates a busy state, 0 a free state.
SOC_ve(t_arrive) = zeta # State of the electric vehicle battery at the time of arrival V n_ve E N_ve (%), (Gaussian random]
SOC_ve(t_depart) = zeta # State of the electric vehicle battery at the time of departure V n_ve E N_ve (%)
delta_ve_ch(n_ve,t) = 0/1 # charging state On/off for vehicle battery charging electric to n., EN, AND SOC (departure)
delta_ve_dch(n_ve,t) = 0/1 # discharge state On/off binary parameter for discharging the electric vehicle battery to n EN, AND
#Decision Variables (Electric Vehicles):
P_ve_ch(n_ve,t) # Charging power of the battery of the electric vehicle no E N during the period te T (W)
P_ve_dch(n_ve,t) # Discharge power of the electric vehicle battery ni E N during the period t ET (W)
SOC_ve(n_ve,t) # State of charge of the battery of electric vehicle n, E N., during the period t ET (%)
# Constraints (Electric vehicles)


#Set (Batteries)
n_bat = 1 # Number of batteries
T=range(1,35040)#Periods of 15 minutes for each day of the year (At=0.25 h)
N_bat = range(1,n_bat) # Number of batteries
#Parameters (Batteries):
E_bat = 19200 #Battery capacity (Wh)
E_bat_ch_max= 10000 #Maximum battery charging power (Wh)
E_bat_dch_max = 10000 #Maximum battery discharge power (Wh)
SOC_bat_max = 80 #Maximum Battery Status (%)
SOC_bat_min = 20 #Minimum Battery Condition (%)
𝜂_bat_ch = 90 #UPS battery charging efficiency
𝜂_bat_dch = 90 #UPS battery discharge efficiency
SOC_bat(t=0) = SOC_bat_max #Battery status at moment t=0 E N_bat (%)=1 
delta_bat_ch(n_bat,t) # charge state Ootherwise: On/off binary parameter for battery charging at ENET.(batt) =(1
delta_bat_dch(n_bat,t) # discharge state 10otherwise: On/off binary parameter for batterydischarge at no ENET.
#Decision Variables (Batteries):
P_bat_ch(n_bat,t) #Battery charging power at E NET(W)
P_bat_dch(n_bat,t) #Battery discharge power at EET (W)
SOC_bat(n_bat,t) #State of charge of the battery at nour & NastET (%)

#Sets (Demand for housing):
T=range(1, 35040) # 15 minute periods for each day of the year
N_dem = range(1,n_dem) # Number of homes (demand)
N_anc # Number of non-controllable appliances (lighting, refrigerators, electric stove, television, computers and others)
N_ac # Number of controllable appliances (HVAC: Heating,ventilation and air conditioning, WH: Water heater and DCH:Shower)
# Parameters (Housing demand):
P_anc(t) # Energy consumption power of non-controllable devices (w)
P_ac(t) # Energy consumption power of controllable devices (w)
# Controllable Devices
# Heating, ventilation and air conditioning (HVAC)
#Parameters (HVAC):
C_it = 3.6 # Thermal capacity (kWh/°C)
P_cha_nom = 3000 #Rated heating power (W)
P_cha_m2 = 60 #Heating power per square meter (W/m²)
R_it = 4 #Thermal resistance (°C/kW)
T_cha_sou # Desired temperature with heating (°C)
T_cli_sou = 14 # Desired temperature with air conditioning (°C)
Zm_tem = 2 #Dead zone of the set temperature (°C)
alpha_hvac = exp(-dt/(R_it * C_it)) # HVAC thermal inertia
𝜂_cha = 90 # Yield - Heating efficiency (%) :
𝜂_cli = 90 # Yield - Cooling efficiency (%)
T_hvac(t=0) = T_a(t) # Initial temperature of homes at time t=0 VIET (°C)
S_hab(n_dem) #Surface area of ​​each dwelling (m²)
T_a(t) # Ambient temperature in each te T (°C)
Scha(ndem.t)
1 on state
otherwise:
Binary on/off parameter for heating
operation at nΕΝΕΤ
1 on state
= O otherwise:
Binary on/off parameter for air conditioning
operation at
ENET
Decision Variables (HVAC Demand):
Thoac(t):
Temperature control of homes in each te T (°C)
Pcha(ndemet)
Heating energy consumption power na E NET (w)
Peti(dem,t)
(w)
ENET air conditioning energy consumption
power
Constraints (HVAC demand):


Scha(then.1) + Sclim(then.t) ≤1
0≤Pcha(ndem.t) ≤cha-P
0≤P(dem) ≤P
T-Change STVAC(t)≤T + Change
cha
Thermostat set point in
winter

Thermostat set point in the summer

Hypotheses
(1) There is only one conditioned space air-conditioned space:
(2) no independent thermal storage is connected to the main HVAC equipment;
(3) humidity control is neglected humidity control is neglected;
(4) internal heat sources of the equipment are neglected;
(5) humidity control is neglected throughout the space
Water heater model (EWH)
Notch
= 4.2157:
The specific heat of water (kJ/kg °C)
pmax
wh
= 3900
Maximum power consumption of the EWH (w)
Pewh
= 1500:
Maximum power consumption of EWH (w)
Rewh
= 0.3472:
Thermal insulation (m². °Ch/kJ)
Sewh
= 2.28:
The surface of the tank (h=1.2 m and r=0.5 m) (m²)
water
=
37: Desired temperature with the water heater (°C)
Vewh
= 0.2356:
Capacity of the water tank (h=1.2 m and r=0.5 m) (m²)
Zcetem =
2 Dead zone of the heating-water setpoint temperature (°C)
Skin
= 1000
The density of water (kg/m³)
Water(t):
Water demand VtET (m³/Ath)
trouble (t)
: The ambient temperature of the home (°C)
T(t):
The temperature of the incoming cold water (°C)
Tewh(to) Tau(t): Initial water heater temperature at time t=0vtET(°C)
Cmt
= Skin Vewh Necks: Equivalent thermal mass (kJ/°C)
@ewh
Thermal inertia EWH



The ratio of surface area to thermal resistance of
the tank



Gewh(t) = Peau-Cenu-Dean(t)

Decision Variables (EWH Request):
Tewh(t)
The temperature of the hot water inside the tank EWH, t ET
(°C)
Pewh (ndem,t):
Water heating energy consumption power ENE
T (w)
Constraints (EWH Request):






Thermostat set point
water heater
General Sets:


15 minute periods for each day of the year

Set of all variables
General Settings:

= 0.0670:
Formula (3.3)

= 0.5513:
Formula (3.5)
you
Degradation costs associated with batteries
you
Degradation costs associated with electric vehicles ($/w)
IN
=0.8:
Cost weighting factor (1/5)



ir thermal discomfort (1/°C)
IN
start-up time discomfort
(1/h)
Decision Variables (Global):

Consumption stopped during the winter credit period (w)
You
Discomfort time due to deviation from the objective for the device at T
Time (h)

2
Discomfort temperature due to deviation from the set temperature
of the device a to te T (°C)
APRAL(t)
System power balance, t ET (w)
Bcw(Ademit) =
{1
10: Binary variable on/off for if the home accepts the winter
credit at ET
Flow conservation:





*That is to say, no energy is sold to the network.