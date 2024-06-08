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
Q = [float(values[4]) for i in range(K)]
print('n',n)
print('s',s)
print('K',K)
print('H',H)
print('Q',Q)

# Define data arrays
r = [0 for i in range(H + 1)]
C = [0 for i in range(n + 1)]
Xcoord = [0 for i in range(n + 1)]
Ycoord = [0 for i in range(n + 1)]
c = [[0 for i in range(n + 1)] for j in range(n + 1)]
h = [[0 for i in range(s + 1)] for j in range(n + 1)]
u = [[0 for i in range(s + 1)] for g in range(n + 1)]
I_total = [[0 for i in range(H + 1)] for j in range(n + 1)]
d_total = [[0 for t in range(H + 1)] for i in range(n + 1)]
d = [[[0 for t in range(H + 1)] for g in range(s + 1)] for i in range(n + 1)]

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
    	for j in range(s + 1):
    		d[cI][j][i+1] = float(values[4+i])/(s+1)
    for i in range(s+1):
    	u[cI][i] = float(values[4+H+i])
    for i in range(s+1):
    	h[cI][i] = float(values[4+H+s+i+1])


for i in range(n + 1):
	for j in range(n + 1):
		c[i][j] = math.sqrt(math.pow(Xcoord[i]-Xcoord[j],2) + math.pow(Ycoord[i]-Ycoord[j],2))


# Print data
print('X coordinates',Xcoord)
print('Y coordinates',Ycoord)
print('I_total',I_total)
print('d_total',d_total)
print('r',r)
print('C',C)
print('h',h)
print('u',u)
print('d',d)
print('c',c)


# I(i=0,g,t) = I(i=0,g-1,t-1) - sum(i=1 to n)sum(k=1 to K)[q(i,g,k,t)] for g=1 to s, t=1 to H
for g in range(1, s + 1):
    for t in range(1, H + 1):
        prob += I[0][g][t-1] == I[0][g-1][t-2] - lpSum(q[i-1][g][k-1][t-1] for i in range(1, n + 1) for k in range(1, K + 1))
'''
# I(i=0,g=0,t) = r(t), for t=1 to H
for t in range(1, H + 1):
    prob += I[0][0][t-1] == r[t-1]

# I(i,g,t) = I(i,g-1,t-1) + sum(k=1 to K)[q(i,g,k,t)-d(i,g,t)], for i=1 to n, g=1 to s, t=1 to H
for i in range(1, n + 1):
    for g in range(1, s + 1):
        for t in range(1, H + 1):
            prob += I[i][g][t-1] == I[i][g-1][t-2] + lpSum(q[i-1][g][k-1][t-1] - d[i][g][t-1] for k in range(1, K + 1))
'''
# I(i,g=0,t) = sum(k=1 to K)[q(i,g=0,k,t) - d(i,g=0,t)], for i=1 to n, t=1 to H
for i in range(1, n + 1):
    for t in range(1, H + 1):
        prob += I[i][0][t-1] == lpSum(q[i-1][0][k-1][t-1] - d[i][0][t-1] for k in range(1, K + 1))

# sum(g=0 to s)[I(i,g,t) <= C(i)], for i=1 to n, t=1 to H
for i in range(1, n + 1):
    for t in range(1, H + 1):
        prob += lpSum(I[i][g][t-1] for g in range(s + 1)) <= C[i]


# Add constraints for d_total(i,t) = sum(g=0 to s)[d(i,g,t)], for i=0 to n, t=1 to H
for i in range(n + 1):
    for t in range(1, H + 1):
        prob += d_total[i][t-1] == lpSum(d[i][g][t-1] for g in range(s + 1))


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

'''
# Output the results
for v in prob.variables():
    print(v.name, "=", v.varValue)
'''
print("Objective value =", prob.objective.value())
