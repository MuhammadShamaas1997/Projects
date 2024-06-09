from pulp import LpProblem, LpMaximize, LpVariable, lpSum, GLPK_CMD
import math

with open('./Supplied/pirp/pirp-10-2-1-3-1.dat', 'r') as file:
    data = file.read()
file.close()
lines = data.split('\n')

# Read first line
values = lines[0].split()
n=int(values[0])
s=int(values[1])
K=int(values[2])
H=int(values[3])
Q = [float(values[4]) for i in range(K + 1)]

# Define data arrays
r = [0 for i in range(H + 1)]
C = [0 for i in range(n + 1)]
Xcoord = [0 for i in range(n + 1)]
Ycoord = [0 for i in range(n + 1)]
c = [[0 for i in range(n + 1)] for j in range(n + 1)]
h = [[0 for i in range(s + 1)] for j in range(n + 1)]
u = [[0 for g in range(s + 1)] for i in range(n + 1)]
I_total = [[0 for i in range(H + 1)] for j in range(n + 1)]
d_total = [[0 for t in range(H + 1)] for i in range(n + 1)]

# Read second line
values = lines[1].split()
Xcoord[0] = float(values[0])
Ycoord[0] = float(values[1])
I_total[0][0] = float(values[2])
for i in range(H):
    r[i+1] = float(values[3+i])
for i in range(s+1):
	h[0][i] = float(values[3+H+i])

# Read data of customers
for cI in range(1,n+1):
    values = lines[1+cI].split()
    Xcoord[cI] = float(values[0])
    Ycoord[cI] = float(values[1])
    C[cI] = float(values[2])
    I_total[cI][0] = float(values[3])
    for i in range(H):
    	d_total[cI][i+1] = float(values[4+i])
    for i in range(s+1):
    	u[cI][i] = float(values[4+H+i])
    for i in range(s+1):
    	h[cI][i] = float(values[4+H+s+i+1])

for i in range(n + 1):
	for j in range(n + 1):
		c[i][j] = math.sqrt(math.pow(Xcoord[i]-Xcoord[j],2) + math.pow(Ycoord[i]-Ycoord[j],2))

# Print data
print('n',n)
print('')
print('s',s)
print('')
print('K',K)
print('')
print('H',H)
print('')
print('Q',Q)
print('')
print('X coordinates',Xcoord)
print('')
print('Y coordinates',Ycoord)
print('')
print('I_total',I_total)
print('')
print('d_total',d_total)
print('')
print('r',r)
print('')
print('C',C)
print('')
print('h',h)
print('')
print('u',u)
print('')
print('')
print('c',c)
print('')


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
d = [[[LpVariable(f"d_{i}_{g}_{t}", lowBound=0, cat='Continuous') 
        for t in range(H + 1)] 
        for g in range(s + 1)] 
        for i in range(n + 1)]
x = [[[[LpVariable(f"x_{i}_{j}_{k}_{t}", lowBound=0, upBound=2, cat='Integer') 
        for t in range(H + 1)] 
        for k in range(K + 1)] 
        for j in range(n + 1)] 
        for i in range(n + 1)]
y = [[[LpVariable(f"y_{i}_{k}_{t}", cat='Binary') 
        for t in range(H + 1)] 
        for k in range(K + 1)] 
        for i in range(n + 1)]

# Define the problem
prob = LpProblem("MaximizeObjectiveFunction", LpMaximize)

# Define the objective function
objective = (
    lpSum(u[i][g] * d[i][g][t] for i in range(1, n + 1) for g in range(s + 1) for t in range(H + 1))
    - lpSum(h[i][g] * I[i][g][t] for i in range(n + 1) for g in range(s + 1) for t in range(H + 1))
    - lpSum(c[i][j] * x[i][j][k][t] for i in range(n + 1) for j in range(i) for k in range(1, K + 1) for t in range(H + 1))
)
prob += objective

# Constraints

# Add constraint (2): I(i=0,g,t) = I(i=0,g-1,t-1) - sum(i=1 to n)sum(k=1 to K)[q(i,g,k,t)] for g=1 to s, t=1 to H
for g in range(1, s + 1):
    for t in range(1, H + 1):
        prob += I[0][g][t] == I[0][g-1][t-1] - lpSum(q[i][g][k][t] for i in range(1, n + 1) for k in range(1, K + 1))

# Add constraint (3): I(i=0,g=0,t) = r(t), for t=0 to H
for t in range(H + 1):
    prob += I[0][0][t] == r[t]

# Add constraint (4): I(i,g,t) = I(i,g-1,t-1) + sum(k=1 to K)[q(i,g,k,t)-d(i,g,t)], for i=1 to n, g=1 to s, t=1 to H
for i in range(1, n + 1):
    for g in range(1, s + 1):
        for t in range(1, H + 1):
            prob += I[i][g][t] == I[i][g-1][t-1] + lpSum(q[i][g][k][t] for k in range(1, K + 1)) - d[i][g][t]

# Add constraint (5): I(i,g=0,t) = sum(k=1 to K)[q(i,g=0,k,t) - d(i,g=0,t)], for i=1 to n, t=0 to H
for i in range(1, n + 1):
    for t in range(H + 1):
        prob += I[i][0][t] == lpSum(q[i][0][k][t] for k in range(1, K + 1)) - d[i][0][t]

# Add constraint (6): sum(g=0 to s)[I(i,g,t)] <= C(i), for i=1 to n, t=0 to H
for i in range(1, n + 1):
    for t in range(H + 1):
        prob += lpSum(I[i][g][t] for g in range(s + 1)) <= C[i]

# Add constraint (7): d_total(i,t) = sum(g=0 to s)[d(i,g,t)], for i=1 to n, t=0 to H
for i in range(1, n + 1):
    for t in range(H + 1):
        prob += d_total[i][t] == lpSum(d[i][g][t] for g in range(s + 1))

# Add constraint (8): sum(g=0 to s)sum(k=1 to K)[q(i,g,k,t)] <= C(i) - sum(g=0 to s)[I(i,g,t-1)], for i=1 to n, t=1 to H
for i in range(1, n + 1):
    for t in range(1, H + 1):
        prob += lpSum(q[i][g][k][t] for g in range(s + 1) for k in range(1, K + 1)) <= C[i] - lpSum(I[i][g][t-1] for g in range(s + 1))

# Add constraint (9): q(i,g,k,t) <=C(i)*y(i,k,t), for i=1 to n, g=0 to s, k=1 to K, t=0 to H
for i in range(1, n + 1):
    for g in range(s + 1):
        for k in range(1, K + 1):
            for t in range(H + 1):
                prob += q[i][g][k][t] <= C[i] * y[i][k][t]

# Add constraint (10): sum(i=1 to n)sum(g=0 to s)[q(i,g,k,t)] <= Q(k)*y(0,k,t), for k=1 to K, t=0 to H
for k in range(1, K + 1):
    for t in range(H + 1):
        prob += lpSum(q[i][g][k][t] for i in range(1, n + 1) for g in range(s + 1)) <= Q[k] * y[0][k][t]

# Add constraint (11): sum(j=i+1 to n)[x(i,j,k,t)] + sum(j=0 to i)[x(j,i,k,t)] = 2*y(i,k,t), for i=0 to n, k=1 to K, t=0 to H
for i in range(n + 1):
    for k in range(1, K + 1):
        for t in range(H + 1):
            prob += (
                lpSum(x[i][j][k][t] for j in range(i + 1, n + 1)) +
                lpSum(x[j][i][k][t] for j in range(i))
            ) == 2 * y[i][k][t]

# Add constraint (13): sum(k=1 to K)[y(i,k,t)] <= 1, for i=1 to n, t=0 to H
for i in range(1, n + 1):
    for t in range(H + 1):
        prob += lpSum(y[i][k][t] for k in range(1, K + 1)) <= 1

# Add constraint (14): I(i,g,t)>=0, d(i,g,t)>=0, q(i,g,k,t)>=0, for i=1 to n, g=0 to s, k=1 to K, t=0 to H
for i in range(1, n + 1):
    for g in range(s + 1):
        for t in range(H + 1):
            prob += I[i][g][t] >= 0
            prob += d[i][g][t] >= 0
            for k in range(1, K + 1):
                prob += q[i][g][k][t] >= 0

# Add constraint (15): x(0,i,k,t) <= 2 for i=1 to n, k=1 to K, t=0 to H
for i in range(1, n + 1):
    for k in range(1, K + 1):
        for t in range(H + 1):
            prob += x[0][i][k][t] <= 2

# Add constraint (16): x(i,j,k,t) <= 1 for i=1 to n, j=i+1 to n, k=1 to K, t=0 to H
for i in range(1, n + 1):
    for j in range(i + 1, n + 1):
        for k in range(1, K + 1):
            for t in range(H + 1):
                prob += x[i][j][k][t] <= 1

# Add constraint (17): y(i,k,t) <= 1 for i=0 to n, k=1 to K, t=0 to H
for i in range(n + 1):
    for k in range(1, K + 1):
        for t in range(H + 1):
            prob += y[i][k][t] <= 1

# Solve the problem
prob.solve(GLPK_CMD(msg=1))

'''
# Output the results
for v in prob.variables():
    print(v.name, "=", v.varValue)
'''
print("Objective value =", prob.objective.value())
