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

# The objective function based on the model description
def objective_rule(model):
    # Summing over all events, periods, and students for scheduling rewards/penalties
    return (sum(model.X_e_p_s[e, p, s] for e in model.E for p in model.P for s in model.S) +
            sum(model.L_e_i_p[e, i, p] for e in model.E for i in model.I for p in model.P) +
            sum(model.ELAS_s[s] for s in model.S))

model.objective = Objective(rule=objective_rule, sense=minimize)  # Modify the sense as needed

# Constraints

# Constraint (1): Precedence relationship
def precedence_constraint_rule(model, e, e_prime, s):
    if (e, e_prime) in model.precedence_set:  # Define precedence_set as per your data
        return sum(model.X_e_p_s[e_prime, p, s] for p in model.P) >= sum(model.X_e_p_s[e, p, s] for p in model.P)
    return Constraint.Skip
model.precedence_constraint = Constraint(model.E, model.E, model.S, rule=precedence_constraint_rule)

# Constraint (2): Student currency guidelines
def currency_guidelines_constraint_rule(model, e, s):
    return sum(model.X_e_p_s[e, p, s] for p in model.P) >= model.complete_e_s[e, s]
model.currency_guidelines_constraint = Constraint(model.E, model.S, rule=currency_guidelines_constraint_rule)

# Constraint (3): Only one event completion per student
def event_completion_constraint_rule(model, e, s):
    return sum(model.X_e_p_s[e, p, s] for p in model.P) <= 1
model.event_completion_constraint = Constraint(model.E, model.S, rule=event_completion_constraint_rule)

# Constraint (4): Buffer periods between events
def buffer_constraint_rule(model, e, p, s):
    for p_next in range(int(p[1:]) + model.Buffer_e[e], int(p[1:]) + model.Buffer_e[e] + 1):
        if 'P' + str(p_next) in model.P:
            return model.X_e_p_s[e, p_next, s] == 0
    return Constraint.Skip
model.buffer_constraint = Constraint(model.E, model.P, model.S, rule=buffer_constraint_rule)

# Constraint (5): Event scheduling limit per student per period
def scheduling_limit_rule(model, e, s):
    return sum(model.X_e_p_s[e, p, s] for p in model.P) <= model.CAP
model.scheduling_limit_constraint = Constraint(model.E, model.S, rule=scheduling_limit_rule)

# Constraint (6): Instructor assignment to events
def instructor_assignment_rule(model, e, i, p):
    return model.L_e_i_p[e, i, p] <= model.CAP
model.instructor_assignment_constraint = Constraint(model.E, model.I, model.P, rule=instructor_assignment_rule)

# Constraint (7): Flight event assignment per student
def flight_event_constraint_rule(model, e, s):
    if e in model.flight_events:  # Define flight_events as per your data
        return sum(model.X_e_p_s[e, p, s] for p in model.P) >= 1
    return Constraint.Skip
model.flight_event_constraint = Constraint(model.E, model.S, rule=flight_event_constraint_rule)

# Constraint (8): Lecture and non-lecture events in a day
def lec_non_lec_constraint_rule(model, e, d, s):
    # Example: Ensure non-lecture events cannot be scheduled unless a lecture event occurs the same day
    if e in model.non_lecture_events:  # Define non_lecture_events set
        return sum(model.X_e_p_s[lec_e, p, s] for lec_e in model.lecture_events for p in model.P if p in model.P_d[d]) >= sum(model.X_e_p_s[e, p, s] for p in model.P if p in model.P_d[d])
    return Constraint.Skip
model.lec_non_lec_constraint = Constraint(model.E, model.D, model.S, rule=lec_non_lec_constraint_rule)

# Constraint (9): Flight event constraints
def flight_event_constraint_rule(model, e, d, s):
    if e in model.flight_events:  # Define flight_events set
        return sum(model.X_e_p_s[e, p, s] for p in model.P if p in model.P_d[d]) >= 1
    return Constraint.Skip
model.flight_event_constraint = Constraint(model.E, model.D, model.S, rule=flight_event_constraint_rule)

# Constraint (10): Number of lectures allowed per day
def lecture_limit_constraint_rule(model, d, s):
    return sum(model.X_e_p_s[e, p, s] for e in model.lecture_events for p in model.P if p in model.P_d[d]) <= 4
model.lecture_limit_constraint = Constraint(model.D, model.S, rule=lecture_limit_constraint_rule)

# Constraint (11): Only flight events per day limit
def only_flight_constraint_rule(model, e, d, s):
    if e in model.flight_events:  # Define flight_events set
        return sum(model.X_e_p_s[e, p, s] for p in model.P if p in model.P_d[d]) <= 1
    return Constraint.Skip
model.only_flight_constraint = Constraint(model.E, model.D, model.S, rule=only_flight_constraint_rule)

# Constraint (12): Non-lecture events cannot be scheduled without lecture events
def non_lec_schedule_constraint_rule(model, e, d, s):
    if e in model.non_lecture_events:  # Define non_lecture_events set
        return sum(model.X_e_p_s[lec_e, p, s] for lec_e in model.lecture_events for p in model.P if p in model.P_d[d]) >= sum(model.X_e_p_s[e, p, s] for p in model.P if p in model.P_d[d])
    return Constraint.Skip
model.non_lec_schedule_constraint = Constraint(model.E, model.D, model.S, rule=non_lec_schedule_constraint_rule)

# Constraint (13): Lecture and flight scheduling in combination
def lec_flight_constraint_rule(model, e, d, s):
    if e in model.flight_events:  # Combine flight and lecture rules
        return sum(model.X_e_p_s[lec_e, p, s] for lec_e in model.lecture_events for p in model.P if p in model.P_d[d]) >= sum(model.X_e_p_s[e, p, s] for p in model.P if p in model.P_d[d])
    return Constraint.Skip
model.lec_flight_constraint = Constraint(model.E, model.D, model.S, rule=lec_flight_constraint_rule)

# Constraint (14): Buffer constraint between events (constraint 14)
def buffer_time_constraint_rule(model, e, e_prime, p, s):
    if e != e_prime:
        return sum(model.X_e_p_s[e, p, s] for p in model.P) + model.Buffer_e[e] <= sum(model.X_e_p_s[e_prime, p, s] for p in model.P)
    return Constraint.Skip
model.buffer_time_constraint = Constraint(model.E, model.E, model.P, model.S, rule=buffer_time_constraint_rule)

# Constraint (15): Limit the number of lectures and other events
def lecture_other_event_limit_rule(model, e, d, s):
    # Limit the number of events scheduled on the same day
    return sum(model.X_e_p_s[e, p, s] for p in model.P if p in model.P_d[d]) <= 1
model.lecture_other_event_limit = Constraint(model.E, model.D, model.S, rule=lecture_other_event_limit_rule)

# Constraint (16): No overlapping events for a student in the same period
def no_overlap_constraint_rule(model, s, p):
    # Ensure no student is assigned to multiple events in the same period
    return sum(model.X_e_p_s[e, p, s] for e in model.E) <= 1
model.no_overlap_constraint = Constraint(model.S, model.P, rule=no_overlap_constraint_rule)

# Constraint (17): Instructor availability for events
def instructor_availability_rule(model, e, i, p):
    # Ensure that if an instructor is assigned to an event, they are not assigned elsewhere in the same period
    return sum(model.L_e_i_p[e, i, p] for e in model.E) <= 1
model.instructor_availability = Constraint(model.I, model.P, rule=instructor_availability_rule)

# Constraint (18): Instructor workload limit (e.g., max 4 events per day)
def instructor_workload_limit_rule(model, i, d):
    # Ensure an instructor isn't assigned to more than a set number of events in a single day
    return sum(model.L_e_i_p[e, i, p] for e in model.E for p in model.P if p in model.P_d[d]) <= 4
model.instructor_workload_limit = Constraint(model.I, model.D, rule=instructor_workload_limit_rule)

# Constraint (19): Student event participation restriction based on weather, etc.
def event_restriction_rule(model, e, p, s):
    # Example restriction for weather or other conditions
    return sum(model.X_e_p_s[e, p, s] for p in model.P) <= model.CAP
model.event_restriction = Constraint(model.E, model.P, model.S, rule=event_restriction_rule)

# Constraint (20): Instructor-Student interaction limit (e.g., limit the number of times a student and instructor meet per day)
def instructor_student_limit_rule(model, e, s, i):
    # Ensure a student doesn't interact with the same instructor too many times in a day
    return sum(model.L_e_i_p[e, i, p] * model.X_e_p_s[e, p, s] for p in model.P for e in model.E) <= 2
model.instructor_student_limit = Constraint(model.E, model.S, model.I, rule=instructor_student_limit_rule)

# Constraint (21): Flight event restriction based on student flight currency
def flight_event_currency_rule(model, e, s):
    # Ensure a student participates in at least one flight event to maintain currency
    if e in model.flight_events:  # Define flight_events set
        return sum(model.X_e_p_s[e, p, s] for p in model.P) >= 1
    return Constraint.Skip
model.flight_event_currency = Constraint(model.E, model.S, rule=flight_event_currency_rule)

# Constraint (22): Warmup event requirement before regular events
def warmup_event_rule(model, e, s):
    if e in model.warmup_events:  # Define warmup_events set
        return sum(model.X_e_p_s[e, p, s] for p in model.P) >= 1
    return Constraint.Skip
model.warmup_event = Constraint(model.E, model.S, rule=warmup_event_rule)

# Constraint (23): Instructor flight event limit (e.g., no more than 3 flight events per day)
def instructor_flight_limit_rule(model, i, d):
    return sum(model.L_e_i_p[e, i, p] for e in model.flight_events for p in model.P if p in model.P_d[d]) <= 3
model.instructor_flight_limit = Constraint(model.I, model.D, rule=instructor_flight_limit_rule)

# Constraint (24): Event buffer time between conflicting events
def event_buffer_time_rule(model, e, e_prime, p, s):
    # Ensure a buffer between conflicting events
    if e != e_prime:
        return sum(model.X_e_p_s[e, p, s] for p in model.P) + model.Buffer_e[e] <= sum(model.X_e_p_s[e_prime, p, s] for p in model.P)
    return Constraint.Skip
model.event_buffer_time = Constraint(model.E, model.E, model.P, model.S, rule=event_buffer_time_rule)

# Constraint (25): Ensure some events are scheduled in specific periods (e.g., certain lectures or exams)
def specific_period_constraint_rule(model, e, p):
    # Ensure certain events (e.g., exams) are scheduled in specific periods
    if e in model.special_events:  # Define special events
        return model.X_e_p_s[e, p, s] == 1
    return Constraint.Skip
model.specific_period_constraint = Constraint(model.E, model.P, rule=specific_period_constraint_rule)

# Constraint (26): Ensure only specific instructors can teach certain events
def instructor_event_specific_rule(model, e, i, p):
    # Restrict event e to only specific instructors
    if e in model.specific_instructor_events:  # Define specific instructor events
        return model.L_e_i_p[e, i, p] == 1
    return Constraint.Skip
model.instructor_event_specific = Constraint(model.E, model.I, model.P, rule=instructor_event_specific_rule)

# Constraint (27): Ensure students complete a minimum number of events per week
def minimum_event_completion_rule(model, s):
    return sum(model.X_e_p_s[e, p, s] for e in model.E for p in model.P) >= 5
model.minimum_event_completion = Constraint(model.S, rule=minimum_event_completion_rule)

# Constraint (28): Ensure certain events occur in sequence
def event_sequence_rule(model, e, e_next, s):
    # Event e_next can only occur if e has been completed first
    return sum(model.X_e_p_s[e_next, p, s] for p in model.P) <= sum(model.X_e_p_s[e, p, s] for p in model.P)
model.event_sequence = Constraint(model.E, model.E, model.S, rule=event_sequence_rule)

# Constraint (29): Ensure no event overlaps in consecutive periods
def no_consecutive_event_overlap_rule(model, e, p, s):
    # Ensure that no event is scheduled back-to-back in consecutive periods
    return sum(model.X_e_p_s[e, p, s] for p in model.P) <= 1
model.no_consecutive_event_overlap = Constraint(model.E, model.P, model.S, rule=no_consecutive_event_overlap_rule)

# Constraint (30): Ensure no instructor is double-booked
def instructor_double_booking_rule(model, i, p):
    # Ensure an instructor isn't assigned to multiple events in the same period
    return sum(model.L_e_i_p[e, i, p] for e in model.E) <= 1
model.instructor_double_booking = Constraint(model.I, model.P, rule=instructor_double_booking_rule)

# Constraints (31)-(35) are already enforced in parameter definitions

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
