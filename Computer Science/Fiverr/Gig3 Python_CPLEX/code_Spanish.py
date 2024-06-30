'''
import cplex

# Create a new model
model = cplex.Cplex()

# Set problem type to linear programming
model.set_problem_type(cplex.Cplex.problem_type.LP)

# Set objective to maximize
model.objective.set_sense(model.objective.sense.maximize)

# Add variables
model.variables.add(names=["x", "y"], obj=[3.0, 4.0], lb=[0.0, 0.0])

# Add constraints
constraints = [
    [["x", "y"], [2.0, 1.0]],  # 2x + y
    [["x", "y"], [4.0, 3.0]]   # 4x + 3y
]
rhs = [20.0, 36.0]
senses = ["L", "L"]  # 'L' for less-than-or-equal
model.linear_constraints.add(lin_expr=constraints, senses=senses, rhs=rhs)

# Optimize model
model.solve()

# Print results
solution_values = model.solution.get_values()
variable_names = model.variables.get_names()
for name, value in zip(variable_names, solution_values):
    print(f'{name} = {value}')
print(f'Objective value: {model.solution.get_objective_value()}')
'''


import pandas as pd
import numpy as np
import random as rd
import matplotlib.pyplot as plt
from gurobipy import *

# Participation des Clients à la Gestion des Charges Électriques sur le Marché Québécois
T = list(range(0, 35040)) # lo cambien, revisar luego 
Delta_t = 0.25 # 15 min

# Tabla Inicial
# Definir el rango de fechas con un intervalo de 15 minutos
fecha_inicio = pd.Timestamp('2023-01-01 00:00:00')
fecha_fin = pd.Timestamp('2024-01-01 00:00:00')
rango_fechas = pd.date_range(start=fecha_inicio, end=fecha_fin, freq='15T', closed='left')

# Crear una matriz con las filas necesarias
num_filas = len(rango_fechas)
num_columnas = 7  # Aumentar el número de columnas para incluir la fecha y hora pico
matriz_datos = np.zeros((num_filas, num_columnas))

# Crear un DataFrame con la matriz y añadir las fechas como una columna
dataframe = pd.DataFrame(matriz_datos, index=rango_fechas, columns=['Fecha', 'Année', 'Mois', 'Jour', 'Jour de la semaine', 'Heure', 'Saison'])

# Llenar la columna 'Fecha' con las fechas
dataframe['Fecha'] = rango_fechas

# Llenar las columnas con los valores extraídos de las fechas
dataframe['Année'] = rango_fechas.year
dataframe['Mois'] = rango_fechas.month
dataframe['Jour'] = rango_fechas.day

# Crear una nueva columna 'Jour de la semaine' con los días de la semana en letras
dias_semana = {0: 'lundi', 1: 'mardi', 2: 'mercredi', 3: 'jeudi', 4: 'vendredi', 5: 'samedi', 6: 'dimanche'}
dataframe['Jour de la semaine'] = rango_fechas.dayofweek.map(dias_semana)

dataframe['Heure'] = rango_fechas.strftime('%H:%M')

# Definir una función para determinar la estación del año
def obtener_estacion(fecha):
    mes = fecha.month
    if mes in [12, 1, 2, 3]:
        return 'Hiver'  # Hiver incluye diciembre, enero, febrero y marzo
    else:
        return ''  # Los otros meses

# Aplicar la función a cada fecha para obtener la estación correspondiente
dataframe['Saison'] = rango_fechas.to_series().apply(obtener_estacion)

# Definir una función para determinar las horas pico
def es_hora_pico(fecha):
    hora = fecha.hour
    minuto = fecha.minute
    dia_semana = fecha.dayofweek

    if dia_semana < 5:  # De lunes a viernes
        if fecha.month in [12, 1, 2, 3]:  # Hiver
            if (hora == 6 and minuto >= 15) or (hora >= 7 and hora < 9) or (hora == 9 and minuto == 0):
                return 'HP'
            if (hora == 16 and minuto >= 15) or (hora >= 17 and hora < 20) or (hora == 20 and minuto == 0):
                return 'HP'
    return ''

# Aplicar la función a cada fecha para marcar las horas pico
dataframe['Heure_Pointe'] = rango_fechas.to_series().apply(es_hora_pico)

# Ordenar las columnas para que 'Fecha' sea la primera
dataframe = dataframe[['Fecha', 'Année', 'Mois', 'Jour', 'Jour de la semaine', 'Heure', 'Saison', 'Heure_Pointe']]

# Exportar el DataFrame a un archivo Excel
dataframe.to_excel('Tabla.xlsx', index=False)

# print(dataframe)
# Leer el archivo Excel externo
M_HPH = pd.read_excel('00. Heures  hivernales.xlsx', sheet_name="2023")
# print(M_HPH)
# Combinar los DataFrames por la columna 'Fecha'
dataframe = pd.merge(dataframe, M_HPH, on='Fecha', how='outer')
# Exportar el DataFrame combinado a un archivo Excel
print(dataframe)
# dataframe.to_excel('Tabla.xlsx', index=False)
# print("DataFrame combinado exportado a 'Tabla.xlsx'")


# 01. Production Solaire
G_ps_STC = 1000 # Irradiation solaire a condition STC (W/m2)
k_ps = -0.38 # Coefficient de température 
P_ps_STC = 327 # Puissance nominale des panneaux solaires à condition STC (W)
T_ps_STC = 25 # Température à condition STC (°C)
T_ps_NOCT = 45 # Température d’opération de la cellule à condition STC (°C)
η_ps = 20 # Rendement - Efficacité des panneaux solaires (%)
n_ps = 5 # Nombre des panneaux solaires
# Leer un archivo Excel
data_pv = pd.read_excel('01. Donnes PV.xlsx')

# print(data_pv)
# Combinar los DataFrames por la columna 'Fecha'
dataframe = pd.merge(dataframe, data_pv, on='Fecha', how='outer')
# print(dataframe)
# Añadir una nueva columna Temperature Cellule con ceros
dataframe['Temperature Cellule (°C)'] = 0.00

for t in dataframe.index:
    T_c = dataframe.at[t, 'Temperature Cellule (°C)']
    G_ps = dataframe.at[t, 'Radiation (W/m2)']
    T_a = dataframe.at[t, 'Température Ambiante (°C)']
    # calculo de T_c
    T_c = T_a + (T_ps_NOCT - T_ps_STC) / G_ps_STC * G_ps
    # Asignar T_c calculado al DataFrame en la columna 'Temperature Cellule (°C)'
    dataframe.at[t, 'Temperature Cellule (°C)'] = T_c
# print(dataframe)
# Añadir una nueva columna Temperature Cellule con ceros
dataframe['Puissance PV (W)'] = 0.00
for t in dataframe.index:
    P_ps = dataframe.at[t, 'Puissance PV (W)']
    T_c = dataframe.at[t, 'Temperature Cellule (°C)']
    G_ps = dataframe.at[t, 'Radiation (W/m2)']
    # calculo de T_c
    P_ps = n_ps * P_ps_STC * G_ps / G_ps_STC * (1 + k_ps * (T_c - T_ps_STC))
    # Asignar T_c calculado al DataFrame en la columna 'Temperature Cellule (°C)'
    dataframe.at[t, 'Puissance PV (W)'] = P_ps
# print(dataframe)


# 02. Production Eolienne
CP_wt = 0.59 # Coefficient de puissance, dans le meilleur des cas, CP≈ 0.59
P_wt_nom = 7000 # Puissance nominale générateur éolienne (W)
S_wt = 4.35  # Surface du flux d'air, mesurée dans un plan perpendiculaire à la direction de la vitesse du vent (m2)
V_wt_dem = 3 # Vitesse de démarrage (m/s)
V_wt_nom = 17.8 # Vitesse nominale du vent (m/s)
V_wt_arr = 50 # Vitesse d'arrête (m/s)
η_wt = 0.8 # Rendement - Efficacité des turbines éolienne (%)
ρ_a = 1.293 # La masse volumique de l’air (kg/ m3)
n_wt = 1 # Nombre des générateurs éoliennes
# Leer un archivo Excel
data_wt = pd.read_excel('02. Donnes WT.xlsx')
# print(data_pv)
# Combinar los DataFrames por la columna 'Fecha'
dataframe = pd.merge(dataframe, data_wt, on='Fecha', how='outer')
# print(dataframe)

# Añadir una nueva columna Temperature Cellule con ceros
dataframe['Puissance WT (W)'] = 0.00
# Función para calcular la potencia eólica
def Puissance_WT(V_wt, CP_wt, P_wt_nom, S_wt, V_wt_dem, V_wt_nom, V_wt_arr, ρ_a, η_wt, n_wt):
    if V_wt < V_wt_dem:
        return 0
    elif V_wt_dem <= V_wt <= V_wt_nom:
        return n_wt * η_wt * (0.5 * ρ_a * S_wt * V_wt**3 * CP_wt)
    elif V_wt_nom < V_wt <= V_wt_arr:
        return P_wt_nom
    else:
        return 0

# Iterar sobre cada fila del DataFrame y calcular P_wt
for t in dataframe.index:
    V_wt = dataframe.at[t, 'Vitesse du vent m/s']
    P_wt = Puissance_WT(V_wt, CP_wt, P_wt_nom, S_wt, V_wt_dem, V_wt_nom, V_wt_arr, ρ_a, η_wt, n_wt)
    dataframe.at[t, 'Puissance WT (W)'] = P_wt
    
# print(dataframe)
# Función para calcular la potencia eólica
def Puissance_WT(V_wt, CP_wt, P_wt_nom, S_wt, V_wt_dem, V_wt_nom, V_wt_arr, ρ_a, η_wt, n_wt):
    if V_wt < V_wt_dem:
        return 0
    elif V_wt_dem <= V_wt <= V_wt_nom:
        return n_wt * η_wt * (0.5 * ρ_a * S_wt * V_wt**3 * CP_wt)
    elif V_wt_nom < V_wt <= V_wt_arr:
        return P_wt_nom
    else:
        return 0

# Iterar sobre cada fila del DataFrame y calcular P_wt
for t in dataframe.index:
    V_wt = dataframe.at[t, 'Vitesse du vent m/s']
    P_wt = Puissance_WT(V_wt, CP_wt, P_wt_nom, S_wt, V_wt_dem, V_wt_nom, V_wt_arr, ρ_a, η_wt, n_wt)
    dataframe.at[t, 'Puissance WT (W)'] = P_wt
    
# print(dataframe)


# 03. Consommation du Réseau de Distribution
P_TD_max = 50  # Puissance maximale que le consommateur peut avoir avec le tarif D (kW)
π_TD_en1 = 0.0670 # Prix de l’énergie pour les premiers 40 kWh d’un mois avec le tarif D ($CAD/kWh)
π_TD_en2 = 0.1034 # Prix de l’énergie après les 40 kWh de consommation d’un mois avec le tarif D ($CAD/kWh)
π_TD_acc = 0.4481 # Frais d’accès au réseau pour chaque jour ($CAD/kWh)
π_CH_en = 0.5513 # Prix de l’énergie pour le kilowattheure d’énergie effacée ($CAD/kWh), la diminution devrai être plus de 2 kilowattheures
# Añadir una nueva columna de precio
dataframe['Prix de l’énergie ($CAD/kWh)'] = π_TD_en1
dataframe['Disminution de l’énergie ($CAD/kWh)'] = -π_CH_en
print(dataframe)

# Prix d'energie efface
π_CH_ene = 0.5513 # Prix de l’énergie pour le kilowattheure d’énergie effacée ($CAD/kWh), la diminution devrai être plus de 2 kilowattheures


# INICIO DE OPTIMIZACION
model = Model("modelo")
# es la variable mas importante
P_res = model.addVars(T,vtype=GRB.CONTINUOUS, lb=0, name="P_res")
# Agregar una nueva columna basada en un cálculo
dataframe['P_res (w)'] = 0
# print(dataframe)
# unica restriccion que no pase la potencia maxima de la tarifa
for t in T:
    R3_1 = P_res[t] <= P_TD_max

model.addConstr(R3_1)
# Leer un archivo Excel
data_dem = pd.read_excel('03. Perfil de carga - exemple ENE6301 - r1.xlsx')
# print(data_pv)
# Combinar los DataFrames por la columna 'Fecha'
dataframe = pd.merge(dataframe, data_dem, on='Fecha', how='outer')
# print(dataframe)
for t in dataframe.index:
    P_dem = dataframe.at[t, "Demande (w)"] 


# 04. Batteries
E_ba = 2400 # Capacité de la batterie (Wh)
P_bat_chmax = 600 # Puissance de charge maximale de la batterie (Wh)
P_bat_dchmax = 600 # Puissance de décharge maximale de la batterie (Wh)
SOC_bat_max = 80 # État maximal de la batterie (%) 
SOC_bat_min = 20 # État minimum de la batterie (%) 
η_bat_ch = 90 # Efficacité de la charge de la batterie de l’onduleur 
η_bat_dch = 90 # Efficacité de décharge de la batterie de l'onduleur
n_bat = 1
SOC_bat = model.addVars(T,vtype=GRB.CONTINUOUS, lb=0, name="SOC_bat") # capacité de la batterie
P_ch_bat = model.addVars(T,vtype=GRB.CONTINUOUS, lb=0, name="P_ch_bat") # énergie chargée a la période t
P_dch_bat = model.addVars(T,vtype=GRB.CONTINUOUS, lb=0, name="P_dch_bat") # énergie deschargée a la période t
# Añadir una nuevas columnas de Bateria con ceros
dataframe['SOC_bat (w)'] = 0.00
dataframe['P_ch_bat (w)'] = 0.00
dataframe['P_dch_bat (w)'] = 0.00
# Crear un diccionario para P_dem
P_dem = {t: dataframe.at[t, "Demande (w)"] for t in T}

# Añadir la restricción de suma usando quicksum
R4_1 = (quicksum(P_res[t] + P_dch_bat[t] - P_ch_bat[t] for t in T) == quicksum(P_dem[t] for t in T))
model.addConstr(R4_1)
for t in T:
    R4_2 = P_res[t] + P_dch_bat[t] - P_ch_bat[t] >= 0
    R4_3 = P_res[t] + P_dch_bat[t] - P_ch_bat[t] <= P_TD_max 
    R4_4 = SOC_bat[t] <= E_ba * SOC_bat_max / 100
    model.addConstr(R4_2)
    model.addConstr(R4_3)
    model.addConstr(R4_4)

for t in T:
    if t > 1:
        R4_5 = SOC_bat[t] == SOC_bat[t-1] + η_bat_ch * P_ch_bat[t] - P_dch_bat[t] / η_bat_dch
        model.addConstr(R4_5)

for t in T:
    R4_6 = P_ch_bat[t] <= P_bat_chmax * Delta_t
    R4_7 = P_dch_bat[t] <= P_bat_dchmax * Delta_t
    model.addConstr(R4_6)
    model.addConstr(R4_7)

# FINAL DE LA OPTIMIZACION
Z = quicksum(π[t]*P_res[t] for t in T)
model.setObjective(Z,GRB.MINIMIZE)