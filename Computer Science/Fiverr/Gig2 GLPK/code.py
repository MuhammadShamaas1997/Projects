from pulp import LpProblem, LpMaximize, LpVariable, lpSum, GLPK_CMD

# Problem dimensions
n = 10  # Number of customers Minimum 1 Maximum n
H = 3  # Number of time periods Minimum 1 Maximum H
K = 1 # Number of vehicles Minimum 1 Maximum K
s = 2 # Maximum age of products Minimum 0 Maximum s
Q_k = 1535 # Capacity of each vehicle k
I_0_g_0 = 2457 # Initial inventory at depot(0) of age g product at time 0
r_1 = 2457 # Fresh products produced at time 1
r_2 = 2457 # Fresh products produced at time 2
r_3 = 2457 # Fresh products produced at time 3
h_0_0 = 0.92 #Inventory holding cost at depot for product of age 0
h_0_1 = 0.28 #Inventory holding cost at depot for product of age 1
h_0_2 = 0.34 #Inventory holding cost at depot for product of age 2

# Example coefficients (replace these with actual values)
u = [[1 for g in range(s + 1)] for i in range(n + 1)]
d = [[[1 for t in range(H + 1)] for g in range(s + 1)] for i in range(n + 1)]
h = [[1 for g in range(s + 1)] for i in range(n + 1)]
r = [1 for t in range(H + 1)]  # Replace with actual values of r(t)
Q = [10 for k in range(K + 1)] # Example values for Q(k), replace with actual values
C = [10 for i in range(n + 1)]  # Capacity for each item (example values, replace with actual values)
c = [[1 for j in range(n + 1)] for i in range(n + 1)]

# Define variables
I = [[[LpVariable(f"I_{i}_{g}_{t}", lowBound=0, cat='Continuous') 
        for t in range(H + 1)] 
        for g in range(s + 1)] 
        for i in range(n + 1)]
q = [[[[LpVariable(f"q_{i}_{g}_{k}_{t}", lowBound=0, cat='Continuous') 
        for t in range(H + 1)] 
        for k in range(K + 1)] 
        for g in range(s + 1)] 
        for i in range(n + 1)]
x = [[[[LpVariable(f"x_{i}_{j}_{k}_{t}", cat='Binary') 
        for t in range(H + 1)] 
        for k in range(K + 1)] 
        for j in range(n + 1)] 
        for i in range(n + 1)]
y = [[[LpVariable(f"y_{i}_{k}_{t}", cat='Binary') 
        for t in range(H + 1)] 
        for k in range(K + 1)] 
        for i in range(n + 1)]
d_total = [[LpVariable(f"d_total_{i}_{t}", lowBound=0, cat='Continuous') 
        for t in range(H + 1)] 
        for i in range(n + 1)]
I_total = [[LpVariable(f"I_total_{i}_{t}", lowBound=0, cat='Continuous') 
        for t in range(H + 1)] 
        for i in range(n + 1)]

# Define the problem
prob = LpProblem("MaximizeObjectiveFunction", LpMaximize)

# Define the objective function
objective = (
    lpSum(u[i][g] * d[i][g][t] for i in range(1, n + 1) for g in range(s + 1) for t in range(1, H + 1))
    - lpSum(h[i][g] * I[i][g][t] for i in range(1, n + 1) for g in range(s + 1) for t in range(1, H + 1))
    - lpSum(c[i][j] * x[i][j][k][t] for i in range(1, n + 1) for j in range(1, n + 1) for k in range(1, K + 1) for t in range(1, H + 1))
)
prob += objective

# Constraints
# I(i=0,g,t) = I(i=0,g-1,t-1) - sum(i=1 to n)sum(k=1 to K)[q(i,g,k,t)] for g=1 to s, t=1 to H
for g in range(1, s + 1):
    for t in range(1, H + 1):
        prob += I[0][g][t-1] == I[0][g-1][t-2] - lpSum(q[i-1][g][k-1][t-1] for i in range(1, n + 1) for k in range(1, K + 1))

# I(i=0,g=0,t) = r(t), for t=1 to H
for t in range(1, H + 1):
    prob += I[0][0][t-1] == r[t-1]

# I(i,g,t) = I(i,g-1,t-1) + sum(k=1 to K)[q(i,g,k,t)-d(i,g,t)], for i=1 to n, g=1 to s, t=1 to H
for i in range(1, n + 1):
    for g in range(1, s + 1):
        for t in range(1, H + 1):
            prob += I[i][g][t-1] == I[i][g-1][t-2] + lpSum(q[i-1][g][k-1][t-1] - d[i][g][t-1] for k in range(1, K + 1))

# I(i,g=0,t) = sum(k=1 to K)[q(i,g=0,k,t) - d(i,g=0,t)], for i=1 to n, t=1 to H
for i in range(1, n + 1):
    for t in range(1, H + 1):
        prob += I[i][0][t-1] == lpSum(q[i-1][0][k-1][t-1] - d[i][0][t-1] for k in range(1, K + 1))

# sum(g=0 to s)[I(i,g,t) <= C(i)], for i=1 to n, t=1 to H
for i in range(1, n + 1):
    for t in range(1, H + 1):
        prob += lpSum(I[i][g][t-1] for g in range(s + 1)) <= C[i]

for i in range(1, n + 1):
    for t in range(1, H + 1):
        prob += d_total[i-1][t-1] == lpSum(d[i][g][t-1] for g in range(s + 1))

# sum(g=0 to s)sum(k=1 to K)[q(i,g,k,t)] <= C(i) - sum(g=0 to s)[I(i,g,t-1)], for i=1 to n, t=1 to H
for i in range(1, n + 1):
    for t in range(1, H + 1):
        prob += lpSum(q[i-1][g][k-1][t-1] for g in range(s + 1) for k in range(1, K + 1)) <= C[i] - lpSum(I[i][g][t-2] for g in range(s + 1))

# q(i,g,k,t) <=C(i)*y(i,k,t), for i=1 to n, g=0 to s, k=1 to K, t=1 to H
for i in range(1, n + 1):
    for g in range(s + 1):
        for k in range(1, K + 1):
            for t in range(1, H + 1):
                prob += q[i-1][g][k-1][t-1] <= C[i] * y[i-1][k-1][t-1]

# sum(i=1 to n)sum(g=0 to s)[q(i,g,k,t)] <= Q(k)*y(0,k,t), for k=1 to K, t=1 to H
for k in range(1, K + 1):
    for t in range(1, H + 1):
        prob += lpSum(q[i-1][g][k-1][t-1] for i in range(1, n + 1) for g in range(s + 1)) <= Q[k-1] * y[0][k-1][t-1]

# sum(j=1 to n)sum(i < j)[x(i,j,k,t)] + sum(j=1 to n)sum(i > j)[x(j,i,k,t)] = 2*y(i,k,t), for i=1 to n, k=1 to K, t=1 to H
for i in range(1, n + 1):
    for k in range(1, K + 1):
        for t in range(1, H + 1):
            prob += (
                lpSum(x[i-1][j-1][k-1][t-1] for j in range(1, n + 1) if i < j) +
                lpSum(x[j-1][i-1][k-1][t-1] for j in range(1, n + 1) if i > j)
            ) == 2 * y[i-1][k-1][t-1]

# sum(k=1 to K)[y(i,k,t)] <= 1, for i=1 to n, t=1 to H
for i in range(1, n + 1):
    for t in range(1, H + 1):
        prob += lpSum(y[i-1][k-1][t-1] for k in range(1, K + 1)) <= 1

# I(i,g,t)>=0, d(i,g,t)>=0, q(i,g,k,t)>=0, for i=1 to n, g=0 to s, k=1 to K, t=1 to H
for i in range(1, n + 1):
    for g in range(s + 1):
        for t in range(1, H + 1):
            prob += I[i][g][t-1] >= 0
            prob += d[i][g][t-1] >= 0
        for k in range(1, K + 1):
            for t in range(1, H + 1):
                prob += q[i-1][g][k-1][t-1] >= 0

# x(i,j,k,t) is binary for i=0 to n, j=0 to n, k=1 to K, t=1 to H
for i in range(n + 1):
    for j in range(n + 1):
        for k in range(1, K + 1):
            for t in range(1, H + 1):
                prob += x[i][j][k][t] <= 1

# Add constraints for I_total(i,t) = sum(g=0 to s)[I(i,g,t)], for i=0 to n, t=1 to H
for i in range(n + 1):
    for t in range(1, H + 1):
        prob += I_total[i][t-1] == lpSum(I[i][g][t-1] for g in range(s + 1))

# Solve the problem
prob.solve(GLPK_CMD(msg=1))

# Output the results
for v in prob.variables():
    print(v.name, "=", v.varValue)
print("Objective value =", prob.objective.value())
