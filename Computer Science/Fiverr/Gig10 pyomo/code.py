from pyomo.environ import *

# Define the model
model = ConcreteModel()

# Set of days
model.D = Set(initialize=['D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'D7'])

# Set of student events
model.E = Set(initialize=['E' + str(i) for i in range(1, 259)])  # E1 to E258

# Set of instructors
model.I = Set(initialize=['I' + str(i) for i in range(1, 39)])  # I1 to I38

# Set of stages
model.J = Set(initialize=['J' + str(i) for i in range(1, 25)])  # J1 to J24

# Set of periods
model.P = Set(initialize=['P' + str(i) for i in range(1, 169)])  # P1 to P168

# Set of students
model.S = Set(initialize=['S' + str(i) for i in range(1, 74)])  # S1 to S73

# Define A(e) as a Param: For each event e in E, list the allowed periods in P
model.A_e = Param(model.E, within=Any, initialize={
    'E1': ['P1', 'P2', 'P3'],
    'E2': ['P2', 'P4'],
    # Continue for all events in E
})

# Define DD as a Set of event pairs (e', e) where e' cannot occur on the same day as e
# Example initialization: If E1 and E2 cannot be on the same day
model.DD = Set(dimen=2, initialize=[
    ('E1', 'E2'),
    ('E3', 'E4'),
    # Continue for all event pairs that cannot be on the same day
])

# Define E_f as a subset of E for flight events
# Example initialization: Flight events might be E5, E12, E20, etc.
model.E_f = Set(within=model.E, initialize=['E5', 'E12', 'E20'])

# Define E_j: A dictionary that maps each stage j in J to a subset of events in E
# Example initialization: Stage J1 has events E1, E2, Stage J2 has events E3, E4, etc.
model.E_j = Set(model.J, within=model.E, initialize={
    'J1': ['E1', 'E2'],
    'J2': ['E3', 'E4'],
    'J3': ['E5', 'E6'],
    # Continue for other stages
})

# Define E_lec as a subset of E for lecture events
# Example initialization: Lecture events might be E7, E15, E23, etc.
model.E_lec = Set(within=model.E, initialize=['E7', 'E15', 'E23'])

# Define E_only as a subset of E for events that can only be scheduled with lectures on the same day
# Example initialization: Events E9 and E17 can only occur with lecture events
model.E_only = Set(within=model.E, initialize=['E9', 'E17'])

# Define E_onlyFlight as a subset of E for events that Flight events that can be scheduled only with 
# lectures and simulator events occurring the same day.
model.E_onlyFlight = Set(within=model.E, initialize=['E9', 'E17'])

# Define E_NOW as a subset of E for events that should not be flown with on-wing 
# instructor.
model.E_NOW = Set(within=model.E, initialize=['E9', 'E17'])

# Define E_OW as a subset of E for events required to be flown with on-wing 
# instructor
model.E_OW = Set(within=model.E, initialize=['E9', 'E17'])

# Define E_sim as a subset of E for events that are simulator events
model.E_sim = Set(within=model.E, initialize=['E9', 'E17'])

# Define E_ii as a subset of E for events that are in-and-in events
model.E_ii = Set(within=model.E, initialize=['E9', 'E17'])

# Define I_e: A dictionary that maps each event e in E to a subset of instructors in I
# Example initialization: Event E1 can be instructed by I1, I2; Event E2 by I3, I4
model.I_e = Set(model.E, within=model.I, initialize={
    'E1': ['I1', 'I2'],
    'E2': ['I3', 'I4'],
    'E3': ['I1', 'I3', 'I5'],
    # Continue for other events
})

# Define OW_s: A dictionary that maps each student s in S to a subset of instructors in I
# Example initialization: Student S1 has on wing instructors by I1, I2;
model.OW_s = Set(model.S, within=model.I, initialize={
    'S1': ['I1', 'I2'],
    'S2': ['I3', 'I4'],
    'S3': ['I1', 'I3', 'I5'],
    # Continue for other students
})

# Define P_d: A dictionary that maps each day d in D to a subset of periods in P
# Example initialization: Day D1 has periods P1 to P24, Day D2 has periods P25 to P48, etc.
model.P_d = Set(model.D, within=model.P, initialize={
    'D1': ['P' + str(i) for i in range(1, 25)],    
    'D2': ['P' + str(i) for i in range(25, 49)],   
})

# Define P_NO_i: A dictionary that maps each instructor i in I to a subset of periods in P
# Example initialization: Instructor I1 is not available in periods P1 to P24 etc.
model.P_NO_i = Set(model.I, within=model.P, initialize={
    'I1': ['P' + str(i) for i in range(1, 25)],    
    'I2': ['P' + str(i) for i in range(25, 49)],  
})

# Define P_NO_s: A dictionary that maps each student s in S to a subset of periods in P
# Example initialization: Instructor S1 is not available in periods P1 to P24 etc.
model.P_NO_s = Set(model.S, within=model.P, initialize={
    'S1': ['P' + str(i) for i in range(1, 25)],    
    'S2': ['P' + str(i) for i in range(25, 49)],  
})

# Define R as a Set of event pairs (e', e) where e' precedes event e
model.R = Set(dimen=2, initialize=[
    ('E1', 'E2'),
    ('E3', 'E4'),
    # Continue for all event pairs that cannot be on the same day
])

# Define S_e: A dictionary that maps each event e in E to a subset of events in E
# Example initialization: Instructor E2 and E3 precede E1 etc.
model.S_e = Set(model.E, within=model.E, initialize={
    'E1': ['E2','E3'],   
    'E2': ['E3','E4'],   
})

# Define SP_e_p: A mapping of each event e and period p to a set of periods where no event can start
# Example initialization: If event E1 starts in period P1, no events can start in periods P2, P3
model.SP_e_p = Set(model.E, model.P, within=model.P, initialize={
    ('E1', 'P1'): ['P2', 'P3', 'P4'],    # If E1 starts in P1, no event can start in P2, P3, P4
    ('E2', 'P5'): ['P6', 'P7'],          # If E2 starts in P5, no event can start in P6, P7
    # Continue for other events and periods
})

# Define warmups as a Set of event pairs (e', e) where e' reinstates curreny for event e
model.warmups = Set(dimen=2, initialize=[
    ('E1', 'E2'),
    ('E3', 'E4'),
    # Continue for all event pairs that cannot be on the same day
])

# Define warmup_S_e: A dictionary that maps each event e in E to a subset of events in E
# Example initialization: Events E2 and E3 satisfy warmup event E1 etc.
model.warmup_S_e = Set(model.E, within=model.E, initialize={
    'E1': ['E2','E3'],   
    'E2': ['E3','E4'],   
})

# Define Buffer_e: A parameter for each event e in E (e.g., buffer time in periods)
# Example initialization: Event E1 has a buffer of 2 periods, Event E2 has a buffer of 3 periods, etc.
model.Buffer_e = Param(model.E, initialize={
    'E1': 2,  # Buffer for event E1
    'E2': 3,  # Buffer for event E2
    'E3': 1,  # Buffer for event E3
    # Continue for all events
}, within=NonNegativeIntegers)

# Define CAP as a scalar parameter with a value of 20
model.CAP = Param(initialize=20)

# Initialize the parameter with the completion data
model.complete_e_s = Param(model.E, model.S, initialize={
    ('E1', 'S1'): 1,  # Student S1 has completed event E1
    ('E2', 'S1'): 0,  # Student S1 has not completed event E2
    # Continue for other students and events
}, within=Binary, default=0)

# Define CQwave_p: A parameter for each period p in P
# Example initialization: Period P1 has a 2 students that can be waved etc.
model.CQwave_p = Param(model.P, initialize={
    'P1': 2, 
    'P2': 3, 
    'P3': 1, 
}, within=NonNegativeIntegers)

# Initialize the parameter for Pair of days that indicates that maximum number of 
# days until a student is in a warmup window for either 1 warmup or 2 warmups, necessitating they 
# redo event e′ either once or twice before being able to schedule event e.
model.currency_e_e = Param(model.E, model.E, initialize={
    ('E1', 'E2'): 1,  
    ('E3', 'E4'): 1, 
}, within=NonNegativeIntegers)

# Number of days since student s completed event e at the beginning of the week
model.days_e_s = Param(model.E, model.S, initialize={
    ('E1', 'S2'): 1,  
    ('E2', 'S3'): 1, 
}, within=NonNegativeIntegers)

# Number of days since student s completed event e at the beginning of the week
model.EEvent_d_i = Param(model.D, model.I, initialize={
    ('D1', 'I2'): 1,  
    ('D2', 'I3'): 1, 
}, within=NonNegativeIntegers)

# Define forecast_p: A parameter for each period p in P
model.forecast_p = Param(model.P, initialize={
    'P1': (1,2), 
    'P2': (3,4), 
    'P3': (5,6), 
})

# Define G as 1 if requiring completion of event e for student s (desired), 0 otherwise. 
model.G_e_s = Param(model.E, model.S, initialize={
    ('E1', 'S2'): 1,  
    ('E2', 'S3'): 0, 
}, within=NonNegativeIntegers)

# Define iiR_e: A parameter for each event e in E
model.iiR_e = Param(model.E, initialize={
    'E1': 1, 
    'E2': 2, 
    'E3': 3, 
}, within=NonNegativeIntegers)

# Define instructorP as a scalar parameter with a value of 0.01
model.instructorP = Param(initialize=0.01)

# Define M_p: A parameter for each period p in P
model.M_p = Param(model.P, initialize={
    'P1': 1, 
    'P2': 2, 
    'P3': 3, 
}, within=NonNegativeIntegers, default=21)

# Define NA_e: A parameter for each event e in E
model.NA_e = Param(model.E, initialize={
    'E1': 1, 
    'E2': 2, 
    'E3': 3, 
}, within=NonNegativeIntegers)

# Define NI_e: A parameter for each event e in E
model.NI_e = Param(model.E, initialize={
    'E1': 1, 
    'E2': 2, 
    'E3': 3, 
}, within=NonNegativeIntegers)

# Define NUM_e: A parameter for each event e in E
model.NUM_e = Param(model.E, initialize={
    'E1': 1, 
    'E2': 2, 
    'E3': 3, 
}, within=NonNegativeIntegers)

# Define numwarmups_e_p_s 
model.numwarmups_e_p_s = Param(model.E, model.P, model.S, initialize={
    ('E1', 'P2', 'S3'): 1,  
    ('E2', 'P3', 'S4'): 1, 
}, within=NonNegativeIntegers)

# Define possible_e_s 
model.possible_e_s = Param(model.E, model.S, initialize={
    ('E1', 'S3'): 1,  
    ('E2', 'S4'): 1, 
}, within=NonNegativeIntegers)

# Define Reward_e_p_s 
model.Reward_e_p_s = Param(model.E, model.P, model.S, initialize={
    ('E1', 'P2', 'S3'): 1,  
    ('E2', 'P3', 'S4'): 1, 
}, within=NonNegativeIntegers)

# Define ScheduleP_p 
model.ScheduleP_p = Param(model.P, initialize={
    'P2': 1,  
    'P3': 1, 
}, within=NonNegativeIntegers)

# Define simCAP as a scalar parameter with a value of 5
model.simCAP = Param(initialize=5)

# Define studentP_e_s 
model.student_e_s = Param(model.E, model.S, initialize={
    ('E1', 'S3'): 1,  
    ('E2', 'S4'): 1, 
}, within=NonNegativeIntegers)

# Define warmupR_e_p_s 
model.warmupR_e_p_s = Param(model.E, model.P, model.S, initialize={
    ('E1', 'P2', 'S3'): 1,  
    ('E2', 'P3', 'S4'): 1, 
}, within=NonNegativeIntegers)

# Define weather_e: A parameter for each event e in E
model.weather_e = Param(model.E, initialize={
    'E1': (1,2), 
    'E2': (3,4), 
    'E3': (5,6), 
})

# Define weatherR_e_p 
model.weatherR_e_p = Param(model.E, model.P, initialize={
    ('E1', 'P2'): 1,  
    ('E2', 'P3'): 1, 
}, within=NonNegativeIntegers)

# Define ELAS_s: A non-negative decision variable for each student s
model.ELAS_s = Var(model.S, within=NonNegativeReals)

# Define L_e_i_p: A decision variable for event e, instructor i, and period p
model.L_e_i_p = Var(model.E, model.I, model.P, within=Binary)

# Define Lec_d_s: A decision variable for day d, student s
model.Lec_d_s = Var(model.D, model.S, within=Binary)

# Define LecI_d_i: A decision variable for day d, instructor i
model.LecI_d_i = Var(model.D, model.I, within=Binary)

# Define Y_e_i_p: A decision variable for event e, instructor i, and period p
model.Y_e_i_p = Var(model.E, model.I, model.P, within=Binary)

# Define X_e_p_s: A decision variable for event e, period p, student s
model.X_e_p_s = Var(model.E, model.P, model.S, within=Binary)

# Objective
model.obj = Objective(expr = 3*model.x + 4*model.y, sense=maximize)

# Constraints
model.constraint1 = Constraint(expr = 2*model.x + model.y <= 20)
model.constraint2 = Constraint(expr = 4*model.x - 5*model.y >= 10)

# Print the model (optional)
model.pprint()

from pyomo.opt import SolverFactory

# Create a CPLEX solver instance
solver = SolverFactory('cplex')

# Solve the model
result = solver.solve(model)

# Display the results
model.display()

print("x =", model.x())
print("y =", model.y())
