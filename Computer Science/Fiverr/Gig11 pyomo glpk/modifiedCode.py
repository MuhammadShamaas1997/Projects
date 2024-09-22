from pyomo.environ import *
from pyomo.opt import SolverFactory
import pandas as pd
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Manual dataframe
data = {
    'Material Number': [1, 2, 3, 4, 5, 6, 7, 8, 9] * 2,
    'Week Number': [1] * 9 + [2] * 9,
    'Priority': ['A', 'E', 'A', 'B', 'C', 'C', 'D', 'A', 'E'] * 2,
    'Pieces Per Day': [3626, 6356, 5331, 5051, 3626, 5245, 5922, 5441, 6368] * 2,
    'On Hand': [1325, 62558, 889, 73117, 2132, 2877, 12488, 2342, 11454] + [0] * 9,
    'Projected Inventory': [1251, 48618, 684, 52449, 1837, -545, 13433, -1512, 11315] + [0] * 9,
    'Projected Demand': [74, 13940, 205, 20668, 295, 3422, -945, 3854, 139, 80, 14000, 220, 21000, 300, 3500, -1000, 4000, 150],
    'Inventory Target': [474, 59674, 658, 43881, 851, 5022, 2160, 9180, 1374] * 2,
    'Under Inventory Target': [-777, 10056, -26, -8568, -986, 5567, -11273, 10692, -9941] + [0] * 9
}

df = pd.DataFrame(data)

# Priority mapping
priority_mapping = {'A': 5, 'B': 4, 'C': 3, 'D': 2, 'E': 1}

# Create the model
model = ConcreteModel()

# Sets
model.SKUs = Set(initialize=df['Material Number'].unique())
model.weeks = Set(initialize=df['Week Number'].unique())
model.days = RangeSet(1, 5)

# Parameters
model.initial_on_hand = Param(model.SKUs, initialize=dict(zip(df[df['Week Number'] == 1]['Material Number'], df[df['Week Number'] == 1]['On Hand'])))
model.production_rate = Param(model.SKUs, model.weeks, initialize={(row['Material Number'], row['Week Number']): row['Pieces Per Day'] for _, row in df.iterrows()})
model.projected_demand = Param(model.SKUs, model.weeks, initialize={(row['Material Number'], row['Week Number']): row['Projected Demand'] for _, row in df.iterrows()})
model.inventory_target = Param(model.SKUs, initialize=dict(zip(df['Material Number'].unique(), df['Inventory Target'].unique())))
model.priority = Param(model.SKUs, initialize={sku: priority_mapping[p] for sku, p in zip(df['Material Number'], df['Priority'])})

# Variables
model.production = Var(model.SKUs, model.weeks, model.days, within=Binary)
model.on_hand = Var(model.SKUs, model.weeks, within=Reals)
model.under_target = Var(model.SKUs, model.weeks, within=Reals)
model.effective_under_target = Var(model.SKUs, model.weeks, within=NonNegativeReals)
model.initial_under_target = Var(model.SKUs, model.weeks, within=Reals)
model.updated_under_target = Var(model.SKUs, model.weeks, within=Reals)

# Constraints

# Only one SKU can be produced per day
def daily_constraint(model, week, day):
    return sum(model.production[sku, week, day] for sku in model.SKUs) <= 1
model.daily_constraint = Constraint(model.weeks, model.days, rule=daily_constraint)

# On-hand balance calculation
def on_hand_balance(model, sku, week):
    total_production = sum(model.production[sku, week, day] * model.production_rate[sku, week] for day in model.days)
    if week == min(model.weeks):
        return model.on_hand[sku, week] == model.initial_on_hand[sku] + total_production - model.projected_demand[sku, week]
    else:
        return model.on_hand[sku, week] == model.on_hand[sku, week - 1] + total_production - model.projected_demand[sku, week]
model.on_hand_balance = Constraint(model.SKUs, model.weeks, rule=on_hand_balance)

# Initial under-target calculation
def initial_under_target_calculation(model, sku, week):
    if week == min(model.weeks):
        return model.initial_under_target[sku, week] == model.inventory_target[sku] - model.initial_on_hand[sku]
    else:
        return model.initial_under_target[sku, week] == model.inventory_target[sku] - model.on_hand[sku, week - 1]
model.initial_under_target_calculation = Constraint(model.SKUs, model.weeks, rule=initial_under_target_calculation)

# Updated under-target calculation
def updated_under_target_calculation(model, sku, week):
    return model.updated_under_target[sku, week] == model.inventory_target[sku] - model.on_hand[sku, week]
model.updated_under_target_calculation = Constraint(model.SKUs, model.weeks, rule=updated_under_target_calculation)

# Effective under-target calculation (to penalize overproduction)
def effective_under_target_calculation(model, sku, week):
    return model.effective_under_target[sku, week] >= model.updated_under_target[sku, week]
model.effective_under_target_calculation = Constraint(model.SKUs, model.weeks, rule=effective_under_target_calculation)

def priority_constraint(model, sku, week, day):
    return sum(model.production[sku_prime, week, day] for sku_prime in model.SKUs if model.priority[sku_prime] >= model.priority[sku]) >= model.production[sku, week, day]
model.priority_constraint = Constraint(model.SKUs, model.weeks, model.days, rule=priority_constraint)

# Objective function
def objective_function(model):
    return sum(model.effective_under_target[sku, week] * model.priority[sku] for sku in model.SKUs for week in model.weeks)
model.objective = Objective(rule=objective_function, sense=minimize)

# Solver configuration
solver = SolverFactory('glpk', executable=r"C:\glpk-4.65\w64\glpsol.exe")
results = solver.solve(model, tee=False)

# Check solver status
if (results.solver.status == SolverStatus.ok) and (results.solver.termination_condition == TerminationCondition.optimal):
    logger.info("Optimal solution found.")
else:
    logger.warning(f"Solver Status: {results.solver.status}")
    logger.warning(f"Termination Condition: {results.solver.termination_condition}")
    logger.error("No optimal solution found. Check your model and solver configuration.")

# Display results
print("\nObjective Value:", value(model.objective))

for week in model.weeks:
    print(f"\nWeek {week} Production and Under Target Quantities:")
    print("SKU | On Hand | Total Production | Initial Under Target | Updated Under Target | Effective Under Target")
    for sku in model.SKUs:
        on_hand = value(model.on_hand[sku, week])
        total_production = sum(value(model.production[sku, week, day]) * model.production_rate[sku, week] for day in model.days)
        initial_under_target = value(model.initial_under_target[sku, week])
        updated_under_target = value(model.updated_under_target[sku, week])
        effective_under_target = value(model.effective_under_target[sku, week])
        print(f"{sku:3d} | {on_hand:8.2f} | {total_production:16.2f} | {initial_under_target:20.2f} | {updated_under_target:22.2f} | {effective_under_target:22.2f}")
