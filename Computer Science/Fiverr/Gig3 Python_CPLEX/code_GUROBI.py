import pandas as pd
import numpy as np
import random as rd
import matplotlib.pyplot as plt
from gurobipy import *

# Client Participation in Electrical Load Management in the Quebec Market
T = list(range(0, 35040))  # Changed it, review later
Delta_t = 0.25  # 15 minutes

# Initial Table
# Define the date range with a 15-minute interval
start_date = pd.Timestamp('2023-01-01 00:00:00')
end_date = pd.Timestamp('2024-01-01 00:00:00')
date_range = pd.date_range(start=start_date, end=end_date, freq='15T', closed='left')

# Create a matrix with the necessary rows
num_rows = len(date_range)
num_columns = 7  # Increase the number of columns to include the date and peak hour
data_matrix = np.zeros((num_rows, num_columns))

# Create a DataFrame with the matrix and add the dates as a column
dataframe = pd.DataFrame(data_matrix, index=date_range, columns=['Date', 'Year', 'Month', 'Day', 'Day of the Week', 'Hour', 'Season'])

# Fill the 'Date' column with the dates
dataframe['Date'] = date_range

# Fill the columns with values extracted from the dates
dataframe['Year'] = date_range.year
dataframe['Month'] = date_range.month
dataframe['Day'] = date_range.day

# Create a new column 'Day of the Week' with the days of the week in letters
days_of_week = {0: 'Monday', 1: 'Tuesday', 2: 'Wednesday', 3: 'Thursday', 4: 'Friday', 5: 'Saturday', 6: 'Sunday'}
dataframe['Day of the Week'] = date_range.dayofweek.map(days_of_week)

dataframe['Hour'] = date_range.strftime('%H:%M')

# Define a function to determine the season of the year
def get_season(date):
    month = date.month
    if month in [12, 1, 2, 3]:
        return 'Winter'  # Winter includes December, January, February, and March
    else:
        return ''  # Other months

# Apply the function to each date to get the corresponding season
dataframe['Season'] = date_range.to_series().apply(get_season)

# Define a function to determine peak hours
def is_peak_hour(date):
    hour = date.hour
    minute = date.minute
    day_of_week = date.dayofweek

    if day_of_week < 5:  # Monday to Friday
        if date.month in [12, 1, 2, 3]:  # Winter
            if (hour == 6 and minute >= 15) or (hour >= 7 and hour < 9) or (hour == 9 and minute == 0):
                return 'PH'
            if (hour == 16 and minute >= 15) or (hour >= 17 and hour < 20) or (hour == 20 and minute == 0):
                return 'PH'
    return ''

# Apply the function to each date to mark peak hours
dataframe['Peak_Hour'] = date_range.to_series().apply(is_peak_hour)

# Arrange columns so 'Date' is first
dataframe = dataframe[['Date', 'Year', 'Month', 'Day', 'Day of the Week', 'Hour', 'Season', 'Peak_Hour']]

# Export the DataFrame to an Excel file
dataframe.to_excel('Table.xlsx', index=False)

# print(dataframe)
# Read the external Excel file
M_HPH = pd.read_excel('00. Heures hivernales.xlsx', sheet_name="2023")
# print(M_HPH)
# Combine DataFrames by the 'Date' column
dataframe = pd.merge(dataframe, M_HPH, on='Date', how='outer')
# Export the combined DataFrame to an Excel file
print(dataframe)
# dataframe.to_excel('Table.xlsx', index=False)
# print("Combined DataFrame exported to 'Table.xlsx'")

# 01. Solar Production
G_ps_STC = 1000  # Solar irradiation at STC condition (W/m2)
k_ps = -0.38  # Temperature coefficient
P_ps_STC = 327  # Nominal power of solar panels at STC condition (W)
T_ps_STC = 25  # Temperature at STC condition (°C)
T_ps_NOCT = 45  # Operating temperature of the cell at STC condition (°C)
η_ps = 20  # Efficiency of solar panels (%)
n_ps = 5  # Number of solar panels
# Read an Excel file
data_pv = pd.read_excel('01. Donnes PV.xlsx')

# print(data_pv)
# Combine DataFrames by the 'Date' column
dataframe = pd.merge(dataframe, data_pv, on='Date', how='outer')
# print(dataframe)
# Add a new column for Cell Temperature with zeros
dataframe['Cell Temperature (°C)'] = 0.00

for t in dataframe.index:
    T_c = dataframe.at[t, 'Cell Temperature (°C)']
    G_ps = dataframe.at[t, 'Radiation (W/m2)']
    T_a = dataframe.at[t, 'Ambient Temperature (°C)']
    # Calculate T_c
    T_c = T_a + (T_ps_NOCT - T_ps_STC) / G_ps_STC * G_ps
    # Assign calculated T_c to the DataFrame in the 'Cell Temperature (°C)' column
    dataframe.at[t, 'Cell Temperature (°C)'] = T_c
# print(dataframe)
# Add a new column for PV Power with zeros
dataframe['PV Power (W)'] = 0.00
for t in dataframe.index:
    P_ps = dataframe.at[t, 'PV Power (W)']
    T_c = dataframe.at[t, 'Cell Temperature (°C)']
    G_ps = dataframe.at[t, 'Radiation (W/m2)']
    # Calculate P_ps
    P_ps = n_ps * P_ps_STC * G_ps / G_ps_STC * (1 + k_ps * (T_c - T_ps_STC))
    # Assign calculated P_ps to the DataFrame in the 'PV Power (W)' column
    dataframe.at[t, 'PV Power (W)'] = P_ps
# print(dataframe)

# 02. Wind Production
CP_wt = 0.59  # Power coefficient, in the best case, CP ≈ 0.59
P_wt_nom = 7000  # Nominal power of the wind generator (W)
S_wt = 4.35  # Surface of the airflow, measured in a plane perpendicular to the wind speed direction (m2)
V_wt_dem = 3  # Start speed (m/s)
V_wt_nom = 17.8  # Nominal wind speed (m/s)
V_wt_arr = 50  # Stop speed (m/s)
η_wt = 0.8  # Efficiency of wind turbines (%)
ρ_a = 1.293  # Air density (kg/m3)
n_wt = 1  # Number of wind generators
# Read an Excel file
data_wt = pd.read_excel('02. Donnes WT.xlsx')
# print(data_pv)
# Combine DataFrames by the 'Date' column
dataframe = pd.merge(dataframe, data_wt, on='Date', how='outer')
# print(dataframe)

# Add a new column for Wind Power with zeros
dataframe['Wind Power (W)'] = 0.00
# Function to calculate wind power
def Wind_Power(V_wt, CP_wt, P_wt_nom, S_wt, V_wt_dem, V_wt_nom, V_wt_arr, ρ_a, η_wt, n_wt):
    if V_wt < V_wt_dem:
        return 0
    elif V_wt_dem <= V_wt <= V_wt_nom:
        return n_wt * η_wt * (0.5 * ρ_a * S_wt * V_wt**3 * CP_wt)
    elif V_wt_nom < V_wt <= V_wt_arr:
        return P_wt_nom
    else:
        return 0

# Iterate over each row of the DataFrame and calculate P_wt
for t in dataframe.index:
    V_wt = dataframe.at[t, 'Wind Speed (m/s)']
    P_wt = Wind_Power(V_wt, CP_wt, P_wt_nom, S_wt, V_wt_dem, V_wt_nom, V_wt_arr, ρ_a, η_wt, n_wt)
    dataframe.at[t, 'Wind Power (W)'] = P_wt
    
# print(dataframe)
# Function to calculate wind power
def Wind_Power(V_wt, CP_wt, P_wt_nom, S_wt, V_wt_dem, V_wt_nom, V_wt_arr, ρ_a, η_wt, n_wt):
    if V_wt < V_wt_dem:
        return 0
    elif V_wt_dem <= V_wt <= V_wt_nom:
        return n_wt * η_wt * (0.5 * ρ_a * S_wt * V_wt**3 * CP_wt)
    elif V_wt_nom < V_wt <= V_wt_arr:
        return P_wt_nom
    else:
        return 0

# Iterate over each row of the DataFrame and calculate P_wt
for t in dataframe.index:
    V_wt = dataframe.at[t, 'Wind Speed (m/s)']
    P_wt = Wind_Power(V_wt, CP_wt, P_wt_nom, S_wt, V_wt_dem, V_wt_nom, V_wt_arr, ρ_a, η_wt, n_wt)
    dataframe.at[t, 'Wind Power (W)'] = P_wt

# 03. Electricity Consumption
data_ec = pd.read_excel('03. Donnes EC.xlsx')
# print(data_ec)
# Combine DataFrames by the 'Date' column
dataframe = pd.merge(dataframe, data_ec, on='Date', how='outer')
# print(dataframe)

# 04. Batteries
C_b = 130  # Capacity of the battery (Ah)
V_b = 24  # Voltage of the battery (V)
SOC_min_b = 20  # Minimum State of Charge (%)
SOC_max_b = 100  # Maximum State of Charge (%)
η_b = 95  # Efficiency of the battery (%)

# Add a new column for SOC of the battery with zeros
dataframe['SOC_b (%)'] = 0.00

# Initialize SOC_b to SOC_max_b for the first row
dataframe.at[dataframe.index[0], 'SOC_b (%)'] = SOC_max_b

for t in dataframe.index[1:]:
    SOC_b_prev = dataframe.at[dataframe.index[dataframe.index.get_loc(t)-1], 'SOC_b (%)']
    P_ps = dataframe.at[t, 'PV Power (W)']
    P_wt = dataframe.at[t, 'Wind Power (W)']
    P_ec = dataframe.at[t, 'Electricity Consumption (W)']
    
    # Calculate new SOC_b
    SOC_b = SOC_b_prev + ((P_ps + P_wt - P_ec) / (C_b * V_b)) * 100 * (Delta_t / 60)
    
    # Ensure SOC_b is within the limits
    SOC_b = max(min(SOC_b, SOC_max_b), SOC_min_b)
    
    # Assign calculated SOC_b to the DataFrame in the 'SOC_b (%)' column
    dataframe.at[t, 'SOC_b (%)'] = SOC_b

# print(dataframe)

# 05. Gurobi Optimization Model

# Initialize the Gurobi model
model = Model()

# Decision Variables
# x[t] = 1 if batteries are charged at time t, 0 otherwise
x = model.addVars(dataframe.index, vtype=GRB.BINARY, name="x")

# y[t] = 1 if batteries are discharged at time t, 0 otherwise
y = model.addVars(dataframe.index, vtype=GRB.BINARY, name="y")

# P_ch_b[t] = Power for battery charging at time t (W)
P_ch_b = model.addVars(dataframe.index, vtype=GRB.CONTINUOUS, name="P_ch_b")

# P_dch_b[t] = Power for battery discharging at time t (W)
P_dch_b = model.addVars(dataframe.index, vtype=GRB.CONTINUOUS, name="P_dch_b")

# SOC_b[t] = State of charge of the battery at time t (%)
SOC_b = model.addVars(dataframe.index, vtype=GRB.CONTINUOUS, name="SOC_b")

# Constraints
for t in dataframe.index:
    # Ensure SOC_b is within the limits
    model.addConstr(SOC_b[t] >= SOC_min_b, name=f"SOC_min_b_{t}")
    model.addConstr(SOC_b[t] <= SOC_max_b, name=f"SOC_max_b_{t}")

    # Battery can only be charged or discharged, not both at the same time
    model.addConstr(x[t] + y[t] <= 1, name=f"Charge_Discharge_{t}")

    # Ensure power values are non-negative
    model.addConstr(P_ch_b[t] >= 0, name=f"P_ch_b_nonnegative_{t}")
    model.addConstr(P_dch_b[t] >= 0, name=f"P_dch_b_nonnegative_{t}")

# Initial SOC of the battery
model.addConstr(SOC_b[dataframe.index[0]] == SOC_max_b, name="Initial_SOC_b")

# Objective function
# Maximize total power used from renewable sources
total_renewable_power = sum(P_ch_b[t] + P_dch_b[t] for t in dataframe.index)
model.setObjective(total_renewable_power, GRB.MAXIMIZE)

# Solve the model
model.optimize()

# Extract the optimized SOC values and add them to the DataFrame
optimized_SOC_b = {t: SOC_b[t].X for t in dataframe.index}
dataframe['Optimized_SOC_b (%)'] = dataframe.index.map(optimized_SOC_b)

# Export the DataFrame to an Excel file
dataframe.to_excel('Optimized_Table.xlsx', index=False)
print("Optimization results exported to 'Optimized_Table.xlsx'")
