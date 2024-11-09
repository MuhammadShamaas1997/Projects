from pyomo.environ import *

# Define the model
model = ConcreteModel()

# Set of days
model.D = RangeSet(7)  # 7 days

# Set of student events
model.E = Set(initialize=['E' + str(i) for i in range(1, 11)])  # E1 to E10

# Set of instructors
model.I = RangeSet(6)  # 6 instructors

# Set of stages
model.J = RangeSet(1)  # 1 stage

# Set of periods
model.P = RangeSet(168)  # 168 periods

# Set of students
model.S = RangeSet(20)  # 20 students

import random

# Set a seed for reproducibility
random.seed(42)

# Define A(e) as a Param: For each event e in E, list the allowed periods in P
model.A_e = Set(model.E, initialize=lambda model, e: RangeSet(140))

# Define DD: Random pairs of events that cannot occur on the same day
all_events = list(model.E)
model.DD = Set(
    dimen=2,
    initialize=lambda model: {(random.choice(all_events), random.choice(all_events)) for _ in range(10)}
)

# Define E_f as a subset of E for flight events
model.E_f = Set(initialize=['E4', 'E5', 'E8', 'E9', 'E10'])  # Flight events

# Define E_CQ: Random subset of events
model.E_CQ = Set(
    initialize=lambda model: random.sample(all_events, random.randint(2, 5))
)

# Define E_j: Assign random events to stages
all_stages = list(model.J)
model.E_j = Param(
    model.J,
    initialize=lambda model, j: random.sample(all_events, random.randint(3, 6)),
    within=Any
)

# Define E_lec: Subset of E for lecture events
model.E_lec = Set(
    initialize=lambda model: random.sample(all_events, random.randint(2, 4))
)

# Define E_only: Random subset of events
model.E_only = Set(
    initialize=lambda model: random.sample(all_events, random.randint(0, 2))
)

# Define E_onlyFlight: Events related to flights
model.E_onlyFlight = Set(
    initialize=lambda model: random.sample(all_events, random.randint(2, 4))
)

# Define E_NOW and E_OW: Non-overlapping random subsets of events
random_events = set(random.sample(all_events, random.randint(5, 10)))
model.E_OW = Set(initialize=lambda model: random_events)
model.E_NOW = Set(initialize=lambda model: set(all_events) - random_events)

# Define E_sim: Simulator events
model.E_sim = Set(
    initialize=lambda model: random.sample(all_events, random.randint(2, 5))
)

# Define E_ii: In-and-in events
model.E_ii = Set(
    initialize=lambda model: random.sample(all_events, random.randint(3, 6))
)

# Define I_e: Randomly assign instructors to events
all_instructors = list(model.I)
model.I_e = Param(
    model.E,
    initialize=lambda model, e: random.sample(all_instructors, random.randint(1, len(all_instructors))),
    within=Any
)

# Define OW_s: Assign random instructors to students
all_students = list(model.S)
model.OW_s = Param(
    model.S,
    initialize=lambda model, s: random.sample(all_instructors, random.randint(1, len(all_instructors))),
    within=Any
)

# Define P_d: Random periods for each day
model.P_d = Param(
    model.D,
    initialize=lambda model, d: sorted(random.sample(list(model.P), random.randint(5, 12))),
    within=Any
)

# Define P_NO_i: Random unavailable periods for instructors
model.P_NO_i = Param(
    model.I,
    initialize=lambda model, i: sorted(random.sample(list(model.P), random.randint(5, 10))),
    within=Any
)

# Define P_NO_s: Random unavailable periods for students
model.P_NO_s = Param(
    model.S,
    initialize=lambda model, s: sorted(random.sample(list(model.P), random.randint(5, 10))),
    within=Any
)

# Define R: Random precedence order for events
model.R = Param(
    model.E,
    initialize=lambda model, e: random.randint(1, len(model.E)),
    within=Any
)

# Define SP_e_p: Random blocked periods for events
model.SP_e_p = Param(
    model.E, model.P,
    initialize=lambda model, e, p: sorted(random.sample(list(model.P), random.randint(0, 5))),
    within=Any
)

# Define S_e: Random relationships between events
model.S_e = Set(
    model.E,
    initialize=lambda model, e: random.sample(all_events, random.randint(0, len(all_events) // 2))
)

import random

# Define warmups as a Set of event pairs (e', e) where e' reinstates currency for event e
def warmups_initializer(model):
    warmups_set = []
    for e in model.E:
        for e_prev in model.E:
            if model.R[e_prev] < model.R[e]:  # Ensure R is initialized correctly
                if random.random() < 0.3:  # 30% chance to include a pair
                    warmups_set.append((e_prev, e))
    return warmups_set
model.warmups = Set(dimen=2, initialize=warmups_initializer)

# Define warmup_S_e
def warmup_S_e_initializer(model, e):
    return random.sample(list(model.E), random.randint(1, 5))  # Random subset of 1-5 events
model.warmup_S_e = Set(model.E, initialize=warmup_S_e_initializer)

# Define Buffer_e
model.Buffer_e = Param(model.E, initialize=lambda model, e: random.randint(1, 5))  # 1-5 periods buffer

# Define CAP
model.CAP = Param(initialize=random.randint(10, 30))  # Random scalar between 10 and 30

# Define complete_e_s
model.complete_e_s = Param(
    model.E,
    model.S,
    initialize=lambda model, e, s: random.choice([0, 1]),  # Binary: 0 or 1
    within=Binary
)

# Define CQwave_p
model.CQwave_p = Param(
    model.P,
    initialize=lambda model, p: random.randint(0, 5),  # 0-5 students can be waved
    within=NonNegativeIntegers
)

# Define currency_e_e
model.currency_e_e = Param(model.E, initialize=lambda model, e: random.randint(5, 15))  # 5-15 days

# Define days_e_s
model.days_e_s = Param(
    model.E,
    model.S,
    initialize=lambda model, e, s: random.randint(5, 20)  # 5-20 days
)

# Define EEvent_d_i
model.EEvent_d_i = Param(
    model.D,
    model.I,
    initialize=lambda model, d, i: random.randint(0, 10),  # Random non-negative integer
    within=NonNegativeIntegers
)

# Define forecast_p
model.forecast_p = Param(
    model.P,
    initialize=lambda model, p: random.randint(1, 10),  # Forecast values between 1 and 10
    within=NonNegativeIntegers
)

# Define G_e_s
model.G_e_s = Param(
    model.E,
    model.S,
    initialize=lambda model, e, s: random.randint(0, 1),  # Binary: 0 or 1
    within=Binary
)

# Define iiR_e
model.iiR_e = Param(model.E, initialize=lambda model, e: random.randint(1, 3))  # 1-3 range

# Define instructorP
model.instructorP = Param(initialize=round(random.uniform(0.01, 0.1), 2))  # 0.01 to 0.1

# Define M_p
model.M_p = Param(model.P, initialize=lambda model, p: random.randint(20, 50))  # 20-50

# Define NA_e
model.NA_e = Param(model.E, initialize=lambda model, e: random.randint(1, 3))  # 1-3 range

# Define NI_e
model.NI_e = Param(model.E, initialize=lambda model, e: random.randint(1, 3))  # 1-3 range

# Define NUM_e
model.NUM_e = Param(model.E, initialize=lambda model, e: random.randint(1, 4))  # 1-4 range

# Define numwarmups_e_p_s
model.numwarmups_e_p_s = Param(
    model.E,
    model.P,
    model.S,
    initialize=lambda model, e, p, s: random.randint(0, 2),  # 0-2 warmups
    within=NonNegativeIntegers
)

# Define possible_e_s
model.possible_e_s = Param(
    model.E,
    model.S,
    initialize=lambda model, e, s: random.randint(0, 1),  # Binary: 0 or 1
    within=Binary
)

# Define Reward_e_p_s
model.Reward_e_p_s = Param(
    model.E,
    model.P,
    model.S,
    initialize=lambda model, e, p, s: random.randint(0, 10),  # 0-10 reward
    within=NonNegativeIntegers
)

# Define ScheduleP_p
model.ScheduleP_p = Param(
    model.P,
    initialize=lambda model, p: random.randint(0, 5),  # 0-5 scheduled
    within=NonNegativeIntegers
)

# Define simCAP
model.simCAP = Param(initialize=random.randint(3, 7))  # Simulator capacity: 3-7

# Define studentP_e_s
model.studentP_e_s = Param(
    model.E,
    model.S,
    initialize=lambda model, e, s: random.randint(0, 10),  # 0-10 points
    within=NonNegativeIntegers
)

# Define warmupR_e_p_s
model.warmupR_e_p_s = Param(
    model.E,
    model.P,
    model.S,
    initialize=lambda model, e, p, s: random.randint(0, 5),  # 0-5 warmups
    within=NonNegativeIntegers
)

# Define weather_e
model.weather_e = Param(model.E, initialize=lambda model, e: random.randint(0, 2))  # 0-2 conditions

# Define weatherR_e_p
model.weatherR_e_p = Param(
    model.E,
    model.P,
    initialize=lambda model, e, p: random.randint(0, 5),  # 0-5 weather rewards
    within=NonNegativeIntegers
)

# Decision variables

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
    return sum(
        (model.G_e_s[e, s] * model.studentP_e_s[e, s] - sum(model.X_e_p_s[e, p, s] for p in model.A_e[e]))
        for e in model.E for s in model.S
    ) 
    + sum(
        model.scheduleP * model.X_e_p_s[e, p, s] for e in model.E for p in model.A_e[e] for s in model.S
    ) 
    + sum(
        model.Reward_e_p_s[e, p, s] * model.X_e_p_s[e, p, s] for e in model.E for p in model.A_e[e] for s in model.S
    ) 
    + sum(
        model.instructorP * (model.Y_e_i_p[e, i, p] + model.L_e_i_p[e, i, p])
        for e in model.E for i in model.I for p in model.P
    ) 
    + sum(
        model.ELAS_s[s] for s in model.S
    ) 
    + sum(
        model.iiR_e * model.X_e_p_s[e, p, s] for e in model.E for p in model.A_e[e] for s in model.S
    ) 
    + sum(
        model.warmupR_e_p_s * model.X_e_p_s[e, p, s] for e in model.E for p in model.A_e[e] for s in model.S
    ) 
    + sum(
        model.weatherR_e_p[e, p] * model.X_e_p_s[e, p, s] for e in model.E for p in model.P for s in model.S
    )

model.objective = Objective(rule=objective_rule, sense=minimize)  # Modify the sense as needed

# Constraints

# Constraint (1) X_e_p_s(e,p,s) <= sum(p' <= p - NUM_e(e'') - Buffer_e(e''), p' in A_e(e''), e'' in S_e(e'), possible_e_s(e'',s)=1) [X_e_p_s(e'',p',s)] for (e',e) in R, possible_e_s(e,s)=1, complete_e_s(e',s)=1, possible_e_s(e',s)=1, p in A_e, s in S
def scheduling_dependency_rule(model, e, p, s):
    # Check if this event and student combination is valid
    if model.possible_e_s[e, s] == 1:
        # Create the RHS sum
        rhs_sum = sum(
            model.X_e_p_s[e_prime, p_prime, s]  # Corrected reference
            for e_prime in model.S_e[e]  # Ensure e_prime comes from the valid set
            for p_prime in model.P  # Iterate over all periods
            if model.A_e[e_prime] == 1  # Check if period is valid (using p_prime)
            and p_prime <= p - model.NUM_e[e_prime] - model.Buffer_e[e_prime]
            and model.complete_e_s[e_prime, s] == 1
            and model.possible_e_s[e_prime, s] == 1
        )
        # Return the constraint inequality
        return model.X_e_p_s[e, p, s] <= rhs_sum
    else:
        # If the event-student combination is not valid, no constraint is needed
        return Constraint.Skip
model.scheduling_dependency = Constraint(
    model.E, model.P, model.S, rule=scheduling_dependency_rule
)


# Constraint (2):  X_e_p_s(e,p,s) <= sum(p' <= p - NUM_e(e'') - Buffer_e(e''), p' in A_e(e''), e'' in S_e(e') where possible_e_s(e'',s)=1) [X_e_p_s(e'',p',s)] / numwarmups_e_p_s(e,p,s) for (e',e) in warmups, possible_e_s(e,s)=1, complete_e_s(e',s)=1, possible_e_s(e',s)=1, numwarmups_e_p_s(e,p,s)>0, p in A_e(e), s in S
def warmup_constraint_rule(model, e, p, s):
    # Check if numwarmups_e_p_s is greater than 0 to avoid division by zero
    if model.numwarmups_e_p_s[e, p, s] > 0:
        # Create the RHS sum for valid periods and events
        rhs_sum = sum(
            model.X_e_p_s[e_prime, p_prime, s]
            for e_prime in model.S_e[e]  # Ensure e_prime comes from the valid set
            for p_prime in model.P  # Iterate over periods
            if (
                p_prime <= p - model.NUM_e[e_prime] - model.Buffer_e[e_prime]
                and model.A_e[e_prime] == 1  # Ensure valid period
                and model.possible_e_s[e_prime, s] == 1
                and model.complete_e_s[e_prime, s] == 1
            )
        )
        
        # Return the constraint: X_e_p_s(e, p, s) <= RHS / numwarmups_e_p_s
        return model.X_e_p_s[e, p, s] <= rhs_sum / model.numwarmups_e_p_s[e, p, s]
    else:
        # Skip the constraint if numwarmups_e_p_s is 0
        return Constraint.Skip
model.warmup_constraint = Constraint(model.E, model.P, model.S, rule=warmup_constraint_rule)

# Constraint (3) sum(p in A_e(e'), e' in S_e(e)) [X_e_p_s(e',p,s)] <= 1 for e in E, possible_e_s(e,s)=1, s in S
def constraint_rule(model, e, s):
    # Check if event e is possible for student s
    if model.possible_e_s[e, s] == 1:
        
        # Check if the set model.S_e[e] is non-empty
        if model.S_e[e]:
            # Initialize the expression for the constraint
            expr = sum(
                model.X_e_p_s[e_prime, p, s]  # Decision variable for event e_prime, period p, student s
                for e_prime in model.S_e[e]   # Iterate over events related to e
                for p in model.A_e[e_prime]   # Iterate over valid periods for event e_prime
            )
                        
            # Return the constraint expression (sum of X_e_p_s must be <= 1)
            return expr <= 1
        else:
            # If the set S_e[e] is empty, skip the constraint
            return Constraint.Feasible
    else:
        # If event e is not possible for student s, return Constraint.Feasible to skip
        return Constraint.Feasible
model.event_student_constraint = Constraint(model.E, model.S, rule=constraint_rule)

# Constraint (4) sum(p in A_e(e''), e'' in warmup_S_e(e')) [X_e_p_s(e'',p,s) <= numwarmups_e_p_s(e,p,s)] for (e',e) in warmups, possible_e_s(e,s)=1, numwarmups_e_p_s(e,p,s)>0, s in S
def constraint_4_rule(model, e_prime, e, p, s):
    if (e_prime, e) in model.warmups and model.possible_e_s[e, s] == 1 and model.numwarmups_e_p_s[e, p, s] > 0:
        # Verify e_prime is a valid key and A_e[e_prime] is iterable
        if e_prime in model.A_e:
            lhs_sum = sum(
                model.X_e_p_s[e_double_prime, p_prime, s]
                for e_double_prime in model.warmup_S_e[e_prime]
                for p_prime in model.A_e[e_double_prime]  # Ensure this is iterable
            )
            return lhs_sum <= model.numwarmups_e_p_s[e, p, s]
    return Constraint.Feasible
model.warmup_index = Set(
    initialize=[
        (e_prime, e, p, s)
        for e_prime, e in model.warmups
        for s in model.S
        for p in model.A_e[e]
        if model.possible_e_s[e, s] == 1 and model.numwarmups_e_p_s[e, p, s] > 0
    ]
)
model.constraint4 = Constraint(model.warmup_index, rule=constraint_4_rule)

# Constraint (5) sum(e, possible_e_s(e,s)=1, p - NUM_e(e)  - Buffer_e(e) + 1 <= p' <= p, p' in A_e(e) ) [X_e_p_s(e,p',s)] <=1 for p in P, s in S
def overlapping_events_rule(model, p, s):
    # Build the summation only for valid events and periods
    summation_terms = [
        model.X_e_p_s[e, p_prime, s]
        for e in model.E  # Iterate over all events
        if model.possible_e_s[e, s] == 1  # Only include valid events for the student
        for p_prime in model.A_e[e]  # Iterate over valid periods for the event
        if p - model.NUM_e[e] - model.Buffer_e[e] + 1 <= p_prime <= p  # Ensure p_prime is in the range
    ]
    
    # If there are no valid terms, skip this constraint
    if not summation_terms:
        return Constraint.Skip

    # Summation of valid terms
    expr = sum(summation_terms)
    
    # Ensure the sum is less than or equal to 1
    return expr <= 1
model.overlapping_events_constraint = Constraint(model.P, model.S, rule=overlapping_events_rule)

# Constraint (6) sum(e, p - NUM_e(e) - Buffer_e(e) + 1 <= p' <= p, p' in A_e(e) ) [Y_e_i_p(e,i,p') + L_e_i_p(e,i,p')] <= 1 for i in I, p in P 
def instructor_availability_rule(model, i, p):
    # Build the summation terms for valid events and periods
    summation_terms = [
        model.Y_e_i_p[e, i, p_prime] + model.L_e_i_p[e, i, p_prime]
        for e in model.E  # Iterate over all events
        for p_prime in model.A_e[e]  # Iterate over valid periods for the event
        if p - model.NUM_e[e] - model.Buffer_e[e] + 1 <= p_prime <= p  # Ensure p_prime is in range
    ]
    
    # If there are no valid terms, skip this constraint
    if not summation_terms:
        return Constraint.Skip

    # Summation of valid terms
    expr = sum(summation_terms)

    # Ensure the sum is less than or equal to 1
    return expr <= 1
model.instructor_availability_constraint = Constraint(model.I, model.P, rule=instructor_availability_rule)

# Constraint (7) sum(e in E_f, possible_e_s(e,s)=1, p in A_e(e)) [X_e_p_s(e,p,s)] >= 1- ELAS_s(s) for s in S, sum(e in E_f) [possible_e_s(e,s)] >= 1
def elas_constraint_rule(model, s):
    # Check if there is at least one possible event for the student
    if sum(model.possible_e_s[e, s] for e in model.E_f) >= 1:
        # Summation over valid events and periods
        expr = sum(
            model.X_e_p_s[e, p, s]
            for e in model.E_f
            if model.possible_e_s[e, s] == 1
            for p in model.A_e[e]
        )
        # Ensure the summation is at least 1 - ELAS_s(s)
        return expr >= 1 - model.ELAS_s[s]
    else:
        # If no events are possible, skip this constraint
        return Constraint.Skip
model.elas_constraint = Constraint(model.S, rule=elas_constraint_rule)

# Constraint (8) sum(e in (E_sim union E_f) but not in (E_CQ union E_only), possible_e_s(e,s)=1, p in (P_d(d) intersection A_e(e))) [X_e_p_s(e,p,s)] <= 2(1-Lec_d_s(d,s) - sum(e in E_only, possible_e_s=1, p in (P_d intersection A_e(e)))) [X_e_p_s(e,p,s)] for d in D, s in S
def constraint_8_rule(model, d, s):
    # Define the valid events (e in E_sim union E_f but not in E_CQ union E_only)
    valid_events = [
        e for e in model.E_sim.union(model.E_f) 
        if e not in model.E_CQ and e not in model.E_only
    ]
    
    # Convert P_d[d] and A_e[e] to sets for intersection operation
    periods_for_d = set(model.P_d[d])  # Ensure this is a set
    periods_for_e = {e: set(model.A_e[e]) for e in valid_events}  # Convert to set for each event
    
    # Left-hand side: Sum over valid events and periods
    lhs_expr = sum(
        model.X_e_p_s[e, p, s]
        for e in valid_events
        for p in periods_for_e[e].intersection(periods_for_d)  # Intersection of sets
        if model.possible_e_s[e, s] == 1
    )

    # Right-hand side: the expression with Lec_d_s and the summation term
    rhs_expr = 2 * (1 - model.Lec_d_s[d, s] - sum(
        model.X_e_p_s[e, p, s]
        for e in model.E_only
        if model.possible_e_s[e, s] == 1
        for p in periods_for_d.intersection(model.A_e[e])  # Ensure this is a set intersection
    ))

    # Return the constraint expression
    if lhs_expr == rhs_expr:
        print(f"Trivial constraint for (d={d}, s={s}). Returning feasible.")
        return Constraint.Feasible
    return lhs_expr <= rhs_expr
#model.constraint8 = Constraint(model.D, model.S, rule=constraint_8_rule)

# Constraint (9) sum(e in (E_f) but not in (E_CQ union E_onlyFlight), possible_e_s(e,s)=1, p in (P_d(d) intersection A_e(e))) [X_e_p_s(e,p,s)] <= 2(1- sum(e in E_onlyFlight, possible_e_s=1, p in (P_d intersection A_e(e)))) [X_e_p_s(e,p,s)] for d in D, s in S
def constraint_9_rule(model, d, s):
    # Define valid events: e in E_f but not in E_CQ union E_onlyFlight
    valid_events = [
        e for e in model.E_f
        if e not in model.E_CQ and e not in model.E_onlyFlight
    ]
    
    # Get periods for d and e, ensuring sets for intersection
    periods_for_d = set(model.P_d[d])  # Ensure this is a set
    periods_for_e = {e: set(model.A_e[e]) for e in valid_events}  # Convert to set for each event
    
    # Left-hand side: Sum over valid events and periods for e in valid_events
    lhs_expr = sum(
        model.X_e_p_s[e, p, s]
        for e in valid_events
        for p in periods_for_e[e].intersection(periods_for_d)  # Intersection of sets
        if model.possible_e_s[e, s] == 1
    )
    
    # Right-hand side: The expression with Lec_d_s and the summation term
    rhs_expr = 2 * (1 - sum(
        model.X_e_p_s[e, p, s]
        for e in model.E_onlyFlight
        if model.possible_e_s[e, s] == 1
        for p in periods_for_d.intersection(model.A_e[e])  # Ensure this is a set intersection
    ))

    # Return the constraint expression
    if lhs_expr == rhs_expr:
        print(f"Trivial constraint for (d={d}, s={s}). Returning feasible.")
        return Constraint.Feasible
    return lhs_expr <= rhs_expr
#model.constraint9 = Constraint(model.D, model.S, rule=constraint_9_rule)

# Constraint (10) sum(e in E_lec, possible_e_s(e,s)=1, p in (P_d intersection A_e(e))) [X_e_p_s(e,p,s) * NUM_e(e)] <= (4 + 4 * Lec_d_s(d,s)) fpr d in D, s in S
def lec_constraint_rule(model, d, s):
    # Sum over events in E_lec, possible_e_s(e,s)=1, p in the intersection of P_d(d) and A_e(e)
    lhs_expr = sum(
        model.X_e_p_s[e, p, s] * model.NUM_e[e]
        for e in model.E_lec
        for p in set(model.P_d[d]).intersection(set(model.A_e[e]))  # Intersection of P_d(d) and A_e(e)
        if model.possible_e_s[e, s] == 1
    )
    
    # Right-hand side: 4 + 4 * Lec_d_s(d,s)
    rhs_expr = 4 + 4 * model.Lec_d_s[d, s]

    # Return the constraint expression
    return lhs_expr <= rhs_expr
model.lec_constraint = Constraint(model.D, model.S, rule=lec_constraint_rule)

# Constraint (11) sum(e in E_onlyFlight, possible_e_s(e,s)=1, p in (P_d intersection A_e(e))) [X_e_p_s] <= 1 - Lec_d_s(d,s) for d in D, s in S
def flight_constraint_rule(model, d, s):
    # Sum over events in E_onlyFlight, possible_e_s(e,s)=1, p in the intersection of P_d(d) and A_e(e)
    lhs_expr = sum(
        model.X_e_p_s[e, p, s]
        for e in model.E_onlyFlight
        for p in set(model.P_d[d]).intersection(set(model.A_e[e]))  # Convert lists to sets for intersection
        if model.possible_e_s[e, s] == 1
    )

    # Right-hand side: 1 - Lec_d_s(d,s)
    rhs_expr = 1 - model.Lec_d_s[d, s]

    # Return the constraint expression
    return lhs_expr <= rhs_expr
model.flight_constraint = Constraint(model.D, model.S, rule=flight_constraint_rule)

# Constraint (12) sum(e in E_lec but not in E_only, possible_e_s(e,s)=1, p in (P_d intersection A_e(e))) [X_e_p_s(e,p,s)] <= 8 (1- sum(e in E_only, possible_e_s(e,s)=1, p in (P_d intersection A_e(e))) [X_e_p_s(e,p,s)]) for d in D, s in S
def constraint_12_rule(model, d, s):
    # Left-hand side: sum over events in E_lec but not in E_only, possible_e_s(e,s)=1, p in (P_d intersection A_e(e))
    lhs_expr = sum(
        model.X_e_p_s[e, p, s]
        for e in model.E_lec
        if e not in model.E_only  # Exclude events in E_only
        for p in set(model.P_d[d]).intersection(set(model.A_e[e]))  # Intersection of P_d(d) and A_e(e)
        if model.possible_e_s[e, s] == 1
    )

    # Right-hand side: 8 * (1 - sum over events in E_only)
    rhs_expr = 8 * (1 - sum(
        model.X_e_p_s[e, p, s]
        for e in model.E_only
        for p in set(model.P_d[d]).intersection(set(model.A_e[e]))  # Intersection of P_d(d) and A_e(e)
        if model.possible_e_s[e, s] == 1
    ))

    # Return the constraint expression
    return lhs_expr <= rhs_expr
model.constraint12 = Constraint(model.D, model.S, rule=constraint_12_rule)

# Constraint (13) sum(e in E_lec, possible_e_s(e,s)=1, p in (P_d intersection A_e(e))) [X_e_p_s(e,p,s)] <= 8 (2- sum(e in E_f and E_sim but not in E_CQ, possible_e_s(e,s)=1, p in (P_d intersection A_e(e))) [X_e_p_s(e,p,s)]) for d in D, s in S
def constraint_13_rule(model, d, s):
    lhs_expr = sum(
        model.X_e_p_s[e, p, s]
        for e in model.E_lec
        if model.possible_e_s[e, s] == 1
        for p in set(model.P_d[d]).intersection(set(model.A_e[e]))  # Intersection
    )

    rhs_expr = 8 * (2 - sum(
        model.X_e_p_s[e, p, s]
        for e in model.E_f.union(model.E_sim)
        if e not in model.E_CQ and model.possible_e_s[e, s] == 1
        for p in set(model.P_d[d]).intersection(set(model.A_e[e]))  # Intersection
    ))

    return lhs_expr <= rhs_expr
model.constraint_13 = Constraint(model.D, model.S, rule=constraint_13_rule)


# Constraint (14) sum(e in E_lec, possible_e_s(e,s)=1, p in (P_d intersection A_e(e))) [X_e_p_s(e,p,s)] <= 8 (3- sum(e in E_CQ but not in E_lec, possible_e_s(e,s)=1, p in (P_d intersection A_e(e))) [X_e_p_s(e,p,s)]) for d in D, s in S
def constraint_14_rule(model, d, s):
    lhs_expr = sum(
        model.X_e_p_s[e, p, s]
        for e in model.E_lec
        if model.possible_e_s[e, s] == 1
        for p in set(model.P_d[d]).intersection(set(model.A_e[e]))  # Intersection
    )

    rhs_expr = 8 * (3 - sum(
        model.X_e_p_s[e, p, s]
        for e in model.E_CQ
        if e not in model.E_lec and model.possible_e_s[e, s] == 1
        for p in set(model.P_d[d]).intersection(set(model.A_e[e]))  # Intersection
    ))

    if lhs_expr == rhs_expr:
        print(f"Trivial constraint for (d={d}, s={s}). Returning feasible.")
        return Constraint.Feasible
    return lhs_expr <= rhs_expr
#model.constraint_14 = Constraint(model.D, model.S, rule=constraint_14_rule)

# Constraint (15) sum(e in E_CQ but not in E_lec, possible_e_s(e,s)=1, p in (P_d intersection A_e(e))) [X_e_p_s(e,p,s)] <= 3 (1- Lec_d_s(d,s)) for d in D, s in S
def constraint_15_rule(model, d, s):
    lhs_expr = sum(
        model.X_e_p_s[e, p, s]
        for e in model.E_CQ
        if e not in model.E_lec and model.possible_e_s[e, s] == 1
        for p in set(model.P_d[d]).intersection(set(model.A_e[e]))  # Intersection
    )

    rhs_expr = 3 * (1 - model.Lec_d_s[d, s])

    return lhs_expr <= rhs_expr
model.constraint_15 = Constraint(model.D, model.S, rule=constraint_15_rule)

# Constraint (16) sum(e', possible_e_s(e',s)=1, p' in (SP_e_p(e',p) intersection A_e(e'))) [X_e_p_s(e',p',s)] <= 8 (1- sum(e, possible_e_s(e,s)=1) [X_e_p_s(e,p,s)]) for p in P, s in S
def constraint_16_rule(model, p, s):
    lhs_expr = sum(
        model.X_e_p_s[e, p_prime, s]
        for e in model.E
        for p_prime in set(model.SP_e_p[e, p]).intersection(set(model.A_e[e]))  # Intersection
        if model.possible_e_s[e, s] == 1
    )

    rhs_expr = 8 * (1 - sum(
        model.X_e_p_s[e, p, s]
        for e in model.E
        if model.possible_e_s[e, s] == 1
    ))

    return lhs_expr <= rhs_expr
model.constraint_16 = Constraint(model.P, model.S, rule=constraint_16_rule)

# Constraint (17) sum(e in E_f, p in (P_d intersection A_e(e))) [Y_e_i_p(e,i,p)] <= (2+EEvent_d_i(d,i))(1-LecI_d_i(d,i)) for d in D, i in I
def constraint_17_rule(model, d, i):
    lhs_expr = sum(
        model.Y_e_i_p[e, i, p]
        for e in model.E_f
        for p in set(model.P_d[d]).intersection(set(model.A_e[e]))  # Intersection
    )

    rhs_expr = (2 + model.EEvent_d_i[d, i]) * (1 - model.LecI_d_i[d, i])

    return lhs_expr <= rhs_expr

model.constraint_17 = Constraint(model.D, model.I, rule=constraint_17_rule)

# Constraint (18) sum(e in E_lec, p in (P_d intersection A_e(e))) [L_e_i_p(e,i,p)NUM_e(e)] <= 4+4LecI_d_i(d,i) for d in D, i in I
def constraint_18_rule(model, d, i):
    lhs_expr = sum(
        model.L_e_i_p[e, i, p] * model.NUM_e[e]
        for e in model.E_lec
        for p in set(model.P_d[d]).intersection(set(model.A_e[e]))  # Intersection
    )

    rhs_expr = 4 + 4 * model.LecI_d_i[d, i]

    return lhs_expr <= rhs_expr
model.constraint_18 = Constraint(model.D, model.I, rule=constraint_18_rule)

# Constraint (19) sum(e', p' in (SP_e_p(e',p) intersection A_e(e'))) [Y_e_i_p(e',i,p') + L_e_i_p(e',i,p')] <= 8(1-sum(e)[Y_e_i_p(e,i,p) + L_e_i_p(e,i,p)]) for i in I, p in P
def constraint_19_rule(model, i, p):
    lhs_expr = sum(
        model.Y_e_i_p[e, i, p_prime] + model.L_e_i_p[e, i, p_prime]
        for e in model.E
        for p_prime in set(model.SP_e_p[e, p]).intersection(set(model.A_e[e]))  # Intersection
    )

    rhs_expr = 8 * (1 - sum(
        model.Y_e_i_p[e, i, p] + model.L_e_i_p[e, i, p]
        for e in model.E
        for p in set(model.A_e[e])
    ))

    return lhs_expr <= rhs_expr
model.constraint_19 = Constraint(model.I, model.P, rule=constraint_19_rule)

# Constraint (20) sum(s, possible_e_s(e,s)=1) [X_e_p_s(e,p,s)] <= sum(i in I_e(e)) [L_e_i_p(e,i,p)CAP] for e in E_lec, p in A_e(e)
def constraint_20_rule(model, e, p):
    # Implement the logic for the constraint here
    lhs_expr = sum(
        model.X_e_p_s[e, p, s] for s in model.S if model.possible_e_s[e, s] == 1
    )
    rhs_expr = 1  # Example right-hand side of the constraint (adjust as needed)
    return lhs_expr <= rhs_expr
for e in model.E:
    model.add_component(
        f"constraint_20_e_{e}", 
        Constraint(model.P, rule=lambda model, p: constraint_20_rule(model, e, p))
    )


# Constraint (21) sum(e in E_CQ intersection E_f, s given possible_e_s(e,s)=1) [X_e_p_s(e,p,s)] <= CQwave_p(p) for p in A_e(e) CQwave_p(p)>0
def constraint_21_rule(model, p):
    lhs_expr = sum(
        model.X_e_p_s[e, p, s]  # Summing over X_e_p_s(e,p,s)
        for e in model.E_f.union(model.E_sim)  # Union of E_f and E_sim
        for s in model.S  # Loop over all students s
        if model.possible_e_s[e, s] == 1  # Check if the event is possible for student s
    )

    rhs_expr = model.CQwave_p[p]  # Assuming CQwave_p(p) is a parameter

    return lhs_expr <= rhs_expr
model.constraint_21 = Constraint(model.P, rule=constraint_21_rule)


# Constraint (22) sum(e| possible_e_s(e,s)=1, p - NUM_e(e) + 1 <= p' <= p | p' in A_e, s) [NA_e(e) X_e_p_s(e,p',s)] <= M_p(p) for p in P
def constraint_22_rule(model, p, s):
    # Left-hand side expression: sum of the weighted X_e_p_s values
    lhs_expr = sum(
        model.NA_e[e] * model.X_e_p_s[e, p_prime, s]
        for e in model.E
        for p_prime in range(model.NUM_e[e], p + 1)  # Handle the range
        if p_prime in model.A_e[e] and model.possible_e_s[e, s] == 1
    )

    # Right-hand side expression
    rhs_expr = model.M_p[p]  # Assuming M_p(p) is a parameter

    # Check if both sides can be evaluated to a numerical value
    try:
        lhs_value = value(lhs_expr)  # Evaluate left-hand side
    except ValueError:
        lhs_value = None  # Handle the case where lhs_expr cannot be evaluated
    
    try:
        rhs_value = value(rhs_expr)  # Evaluate right-hand side
    except ValueError:
        rhs_value = None  # Handle the case where rhs_expr cannot be evaluated

    # If both sides can be evaluated and are equal, return a trivial feasible constraint
    if lhs_value is not None and rhs_value is not None and lhs_value == rhs_value:
        print(f"Trivial constraint for (p={p}, s={s}). Returning feasible.")
        return Constraint.Feasible  # Return feasible if the constraint is trivially satisfied

    # Return the actual constraint if not trivial (lhs_expr <= rhs_expr)
    return lhs_expr <= rhs_expr  # Non-trivial constraint
#model.constraint_22 = Constraint(model.P, model.S, rule=constraint_22_rule)



# Constraint (23) sum(s|possible_e_s=1) [NI_e(e)X_e_p_s(e,p,s)] = sum(i in I_e(e)) [Y_e_i_p(e,i,p)] for e in E_f, p in A_e(e)
def constraint_23_rule(model, e, p):
    lhs_expr = sum(
        model.NI_e[e] * model.X_e_p_s[e, p, s]
        for s in model.S
        if model.possible_e_s[e, s] == 1
    )

    rhs_expr = sum(
        model.Y_e_i_p[e, i, p]
        for i in model.I_e[e]
    )

    return lhs_expr == rhs_expr
model.constraint_23 = Constraint(model.E_f, model.A_e[e], rule=constraint_23_rule)

# Constraint (24) sum(p in P_d intersection A_e(e))[X_e_p_s(e,p,s)] + sum(p in P_d intersection A_e(e'))[X_e_p_s(e',p,s)] <=1 for d in D, (e',e) in DD | (possible_e,s(e,s)=1, possible_e,s(e',s)=1, complete_e_s(e,s)=0, complete_e_s(e',s)=0 ), s in S
def constraint_24_rule(model, d, s):
    lhs_expr = sum(
        model.X_e_p_s[e, p, s]
        for e in model.E
        for p in model.P_d[d]
        if p in model.A_e[e]
    ) + sum(
        model.X_e_p_s[e_prime, p, s]
        for e_prime in model.E
        for p in model.P_d[d]
        if p in model.A_e[e_prime]
    )

    rhs_expr = 1

    return lhs_expr <= rhs_expr
model.constraint_24 = Constraint(model.D, model.S, rule=constraint_24_rule)

# Constraint (25) X_e_p_s(e,p,s) <= sum(i in I_e(e) intersection OW_s(s)) [Y_e_i_p(e,i,p)] for e in E_OW, p in A_e(e), s in S | possible_e_s(e,s)=1
def constraint_25_rule(model, e, p, s):
    lhs_expr = model.X_e_p_s[e, p, s]
    rhs_expr = sum(
        model.Y_e_i_p[e, i, p]
        for i in model.I_e[e]
        if i in model.OW_s[s]
    )

    return lhs_expr <= rhs_expr
model.constraint_25 = Constraint(model.E_OW, model.A_e[e], model.S, rule=constraint_25_rule)

# Constraint (26) X_e_p_s(e,p,s) <= sum(i in I_e(e) but not in OW_s(s)) [Y_e_i_p(e,i,p)] for e in E_NOW, p in A_e(e), s in S | possible_e_s(e,s)=1
def constraint_26_rule(model, e, p, s):
    lhs_expr = model.X_e_p_s[e, p, s]
    rhs_expr = sum(
        model.Y_e_i_p[e, i, p]
        for i in model.I_e[e]
        if i not in model.OW_s[s]
    )

    return lhs_expr <= rhs_expr
model.constraint_26 = Constraint(model.E_NOW, model.A_e[e], model.S, rule=constraint_26_rule)

# Constraint (27) sum(e in E_OW | p in A_e(e), s | possible_e_s(e,s)=1 and i in (I_e(e) intersection OW_s(s))) [X_e_p_s(e,p,s)] <= 1 for i in I, p in P
def constraint_27_rule(model, i, p):
    # Compute the LHS: Summation over X_e_p_s
    lhs_expr = sum(
        model.X_e_p_s[e, p, s]
        for e in model.E_OW
        for s in model.S
        if model.possible_e_s[e, s] == 1 and i in model.I_e[e] and i in model.OW_s[s]
    )

    # Compute RHS: Simply 1
    rhs_expr = 1

    # Check for trivial cases
    if lhs_expr is None or lhs_expr == 0:
        return Constraint.Feasible  # Skip if no valid terms

    return lhs_expr <= rhs_expr
#model.constraint_27 = Constraint(model.I, model.P, rule=constraint_27_rule)

# Constraint (28) sum(s,e in E_sim | possible_e_s(e,s)=1, p - NUM_e(e) + 1 <= p' <= p | p' in A_e(e)) [X_e_p_s(e,p',s)] <= simCAP for p in P
def constraint_28_rule(model, p, s):
    lhs_expr = sum(
        model.X_e_p_s[e, p_prime, s]
        for e in model.E_sim
        for p_prime in range(model.NUM_e[e], p + 1)  # Handle the range
        if p_prime in model.A_e[e] and model.possible_e_s[e, s] == 1
    )

    rhs_expr = model.simCAP  # Assuming simCAP is a parameter

    if lhs_expr == rhs_expr:
        print(f"Trivial constraint for (d={d}, s={s}). Returning feasible.")
        return Constraint.Feasible
    return lhs_expr <= rhs_expr
#model.constraint_28 = Constraint(model.P, model.S, rule=constraint_28_rule)

# Constraint (29) sum (p - NUM_e(e) + 1 <= p' <= p and p' in A_e(e)) [Y_e_i_p(e,i,p') + L_e_i_p(e,i,p')] = 0for e in E, i in I, p in P_NO_i(i)
def constraint_29_rule(model, e, i, p):
    # Collect valid periods
    valid_periods = [
        p_prime for p_prime in range(model.NUM_e[e], p + 1)
        if p_prime in model.A_e[e]
    ]

    # If no valid periods, the constraint is trivially feasible
    if not valid_periods:
        return Constraint.Feasible

    # Define the left-hand side expression
    lhs_expr = sum(
        model.Y_e_i_p[e, i, p_prime] + model.L_e_i_p[e, i, p_prime]
        for p_prime in valid_periods
    )

    # Right-hand side expression
    rhs_expr = 0

    # Return the symbolic constraint
    return lhs_expr == rhs_expr
model.constraint_29 = Constraint(model.E, model.I, model.P, rule=constraint_29_rule)

# Constraint (30) sum(p - NUM_e(e) + 1 <= p' <= p and p' in A_e(e)) [X_e_p_s(e,p',s)]=0 for e in E, p in P_NO_s(s), s in S
def constraint_30_rule(model, e, p, s):
    # Collect valid periods for the summation
    valid_periods = [
        p_prime for p_prime in range(model.NUM_e[e], p + 1)
        if p_prime in model.A_e[e] and model.possible_e_s[e, s] == 1
    ]

    # If no valid periods, the constraint is trivially feasible
    if not valid_periods:
        return Constraint.Feasible

    # Define the left-hand side expression (lhs_expr)
    lhs_expr = sum(
        model.X_e_p_s[e, p_prime, s]
        for p_prime in valid_periods
    )

    # Right-hand side (rhs_expr)
    rhs_expr = 0

    # Return the constraint expression (lhs_expr == rhs_expr)
    return lhs_expr == rhs_expr
model.constraint_30 = Constraint(model.E, model.P, model.S, rule=constraint_30_rule)


# Constraints (31)-(35) are already enforced in variable definitions

print('Starting')

# Print the model (optional)
#model.pprint()

from pyomo.opt import SolverFactory

# Create a CPLEX solver instance
solver = SolverFactory('glpk')

# Solve the model
result = solver.solve(model, tee=True)

# Display the results
#model.display()

# Open the file in write mode (it will overwrite the file if it already exists)
with open('solver_output.txt', 'w') as f:
    # Check solver status
    if result.solver.status == 'ok' and result.solver.termination_condition == 'optimal':
        print("Solution found!\n", file=f)  # Print to file
        
        # Iterate over all variables in the model
        for var in model.component_objects(Var, active=True):
            print(f"Variable: {var.name}", file=f)  # Print to file
            var_object = getattr(model, var.name)
            
            # Print the values for each index
            for index in var_object:
                val = var_object[index].value
                print(f" {var.name} {index} : {val}", file=f)  # Print to file
    else:
        print("No solution found.", file=f)  # Print to file

    # Print the objective value
    print("Objective value:", value(model.objective), file=f)  # Print to file


#print("x =", model.x())
#print("y =", model.y())
