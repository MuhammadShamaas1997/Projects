set EMPLOYEES;
set TASKS;

param h{EMPLOYEES};  # Max tasks per employee
param d{TASKS};      # Min employees per task
param a{EMPLOYEES, TASKS}; # Compatibility matrix (0 or 1)
param c{EMPLOYEES, TASKS}; # Cost of assignment
param p{EMPLOYEES, TASKS}; # Employee preference scores

var x{EMPLOYEES, TASKS} binary;

# Constraints

# Maximum workload for each employee
subject to WorkloadLimit {i in EMPLOYEES}:
    sum {j in TASKS} x[i, j] <= h[i];

# Minimum required employees per task
subject to TaskRequirement {j in TASKS}:
    sum {i in EMPLOYEES} x[i, j] >= d[j];

# Compatibility constraint (assign only if compatible)
subject to Compatibility {i in EMPLOYEES, j in TASKS}:
    x[i, j] <= a[i, j];

# Objective Functions

# Minimize total cost
minimize TotalCost:
    sum {i in EMPLOYEES, j in TASKS} c[i, j] * x[i, j];

# Maximize employee preference
maximize TotalPreference:
    sum {i in EMPLOYEES, j in TASKS} p[i, j] * x[i, j];
