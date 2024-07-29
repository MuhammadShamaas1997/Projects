from docplex.mp.model import Model
import numpy as np
import math

# Model setup
model = Model(name="Optimization Model")

# Define the parameters
m = 10 # Number of boxes
N = 3 # Number of containers
L = {j: 10 for j in range(1, N + 1)} 
W = {j: 10 for j in range(1, N + 1)} 
H = {j: 10 for j in range(1, N + 1)} 
l = {i: 5 for i in range(1, m + 1)} 
w = {i: 5 for i in range(1, m + 1)} 
h = {i: 5 for i in range(1, m + 1)} 
M = 1e9

# Create and add binary variables to the model
p = {(i, j): model.binary_var(name=f"p({i},{j})") for i in range(1, m + 1) for j in range(1, N + 1)}
u = {j: model.binary_var(name=f"u({j})") for j in range(1, N + 1)}
x_pos = {(i, k): model.binary_var(name=f"x_pos({i},{k})") for k in range(2, m + 1) for i in range(1, k)}
x_neg = {(i, k): model.binary_var(name=f"x_neg({i},{k})") for k in range(2, m + 1) for i in range(1, k)}
y_pos = {(i, k): model.binary_var(name=f"y_pos({i},{k})") for k in range(2, m + 1) for i in range(1, k)}
y_neg = {(i, k): model.binary_var(name=f"y_neg({i},{k})") for k in range(2, m + 1) for i in range(1, k)}
z_pos = {(i, k): model.binary_var(name=f"z_pos({i},{k})") for k in range(2, m + 1) for i in range(1, k)}
z_neg = {(i, k): model.binary_var(name=f"z_neg({i},{k})") for k in range(2, m + 1) for i in range(1, k)}
l_x = {i: model.binary_var(name=f"l_x({i})") for i in range(1, m + 1)}
l_y = {i: model.binary_var(name=f"l_y({i})") for i in range(1, m + 1)}
l_z = {i: model.binary_var(name=f"l_z({i})") for i in range(1, m + 1)}
w_x = {i: model.binary_var(name=f"w_x({i})") for i in range(1, m + 1)}
w_y = {i: model.binary_var(name=f"w_y({i})") for i in range(1, m + 1)}
w_z = {i: model.binary_var(name=f"w_z({i})") for i in range(1, m + 1)}
h_x = {i: model.binary_var(name=f"h_x({i})") for i in range(1, m + 1)}
h_y = {i: model.binary_var(name=f"h_y({i})") for i in range(1, m + 1)}
h_z = {i: model.binary_var(name=f"h_z({i})") for i in range(1, m + 1)}
x = {i: model.continuous_var(name=f"x({i})") for i in range(1, m + 1)}
y = {i: model.continuous_var(name=f"y({i})") for i in range(1, m + 1)}
z = {i: model.continuous_var(name=f"z({i})") for i in range(1, m + 1)}

# Objective function
objective = model.sum(u[j] * L[j] * W[j] * H[j] for j in range(1, N + 1)) - model.sum(l[i] * w[i] * h[i] for i in range(1, m + 1))

# Add the constraint p(i,j) <= u(j) for all i and j
for i in range(1, m + 1):
    for j in range(1, N + 1):
        model.add_constraint(p[i, j] <= u[j])

# Add the constraint sum(j=1 to N){p(i,j)} = 1 for all i
for i in range(1, m + 1):
    model.add_constraint(model.sum(p[i, j] for j in range(1, N + 1)) == 1)

# Add the constraint (3)-(5)
for i in range(1, m + 1):
    for j in range(1, N + 1):
        model.add_constraint(x[i] + l[i] * l_x[i] + w[i] * w_x[i] + h[i] * h_x[i] <= L[j] + (1 - p[i, j]) * M)
        model.add_constraint(y[i] + l[i] * l_y[i] + w[i] * w_y[i] + h[i] * h_y[i] <= W[j] + (1 - p[i, j]) * M)
        model.add_constraint(z[i] + l[i] * l_z[i] + w[i] * w_z[i] + h[i] * h_z[i] <= H[j] + (1 - p[i, j]) * M)

# Add the constraint (6)-(11)
for k in range(1, m + 1):
    for i in range(1, k):
        model.add_constraint(x[i] + l[i] * l_x[i] + w[i] * w_x[i] + h[i] * h_x[i] <= x[k] + (1 - x_pos[i, k]) * M)
        model.add_constraint(x[k] + l[k] * l_x[k] + w[k] * w_x[k] + h[k] * h_x[k] <= x[i] + (1 - x_neg[i, k]) * M)
        model.add_constraint(y[i] + l[i] * l_y[i] + w[i] * w_y[i] + h[i] * h_y[i] <= y[k] + (1 - y_pos[i, k]) * M)
        model.add_constraint(y[k] + l[k] * l_y[k] + w[k] * w_y[k] + h[k] * h_y[k] <= y[i] + (1 - y_neg[i, k]) * M)
        model.add_constraint(z[i] + l[i] * l_z[i] + w[i] * w_z[i] + h[i] * h_z[i] <= z[k] + (1 - z_pos[i, k]) * M)
        model.add_constraint(z[k] + l[k] * l_z[k] + w[k] * w_z[k] + h[k] * h_z[k] <= z[i] + (1 - z_neg[i, k]) * M)

# Add the constraint (12)
for k in range(1, m + 1):
    for i in range(1, k):
        for j in range(1, N + 1):
            model.add_constraint(x_pos[i, k] + x_neg[i, k] + y_pos[i, k] + y_neg[i, k] + z_pos[i, k] + z_neg[i, k] >= p[i, j] + p[k, j] - 1)

# Add the constraint (13)-(17)
for i in range(1, m + 1):
    model.add_constraint(l_x[i] + l_y[i] + l_z[i] == 1)
    model.add_constraint(w_x[i] + w_y[i] + w_z[i] == 1)
    model.add_constraint(h_x[i] + h_y[i] + h_z[i] == 1)
    model.add_constraint(l_x[i] + w_x[i] + h_x[i] == 1)
    model.add_constraint(l_y[i] + w_y[i] + h_y[i] == 1)
    model.add_constraint(x[i] >= 0)
    model.add_constraint(y[i] >= 0)
    model.add_constraint(z[i] >= 0)

model.minimize(objective)

# Solve the model
solution = model.solve()

# Check if a solution was found
if solution:
    print("Solution found:")
    # Print the values of the variables
    for j in range(1, N + 1):
        print(f"u({j}) = {u[j].solution_value}")
    for (i, j), var in p.items():
        print(f"p({i},{j}) = {var.solution_value}")
else:
    print("No solution found.")