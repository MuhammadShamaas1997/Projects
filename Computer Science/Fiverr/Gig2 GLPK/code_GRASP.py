from pulp import LpProblem, LpMaximize, LpVariable, lpSum, GLPK_CMD
import math
import itertools
import pulp
import matplotlib.pyplot as plt
import networkx as nx

with open('./Supplied/pirp/pirp-20-2-2-3-1.dat', 'r') as file:
    data = file.read()
file.close()
lines = data.split('\n')

# Read first line
values = lines[0].split()
n=int(values[0]) # Number of customers
s=int(values[1]) # Maximum age of products
K=int(values[2]) # Number of vehicles
H=int(values[3]) # Number of periods
Q = [float(values[4]) for i in range(K + 1)] # Capacity of vehicles

# Define data arrays
r = [0 for i in range(H + 1)] # Replenishments of depot for different periods
C = [0 for i in range(n + 1)] # Capacity of customers
Xcoord = [0 for i in range(n + 1)] # X coordinates of nodes
Ycoord = [0 for i in range(n + 1)] # Y coordinates of nodes
c = [[0 for i in range(n + 1)] for j in range(n + 1)] # Transport cost for nodes
h = [[0 for i in range(s + 1)] for j in range(n + 1)] # Holding costs of nodes of different ages 
u = [[0 for g in range(s + 1)] for i in range(n + 1)] # Revenues for nodes for products of different ages
I_total = [[0 for i in range(H + 1)] for j in range(n + 1)] # Inventory of nodes for different time periodds
d_total = [[0 for t in range(H + 1)] for i in range(n + 1)] # Demand of nodes for different time periods

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

for t in range(1,H+1):
	vehicles = []
	for i in range(1,K+1):
		vehicles.append({"vehicleId":i,"currentNode":0,"quantity":Q[i],"route":[]})
	coveredNodes = [0]
	totalTransported = 0
	while n >= len(coveredNodes):
		# Find best nodes which are closest to current node and provide best revenue
		for v in vehicles:				
			possibleNodes = []
			# Find unvisited nodes
			for i in range(n+1):
				if (i not in coveredNodes):
					possibleNodes.append(i)

			# Compute stats for unvisited nodes
			stats = []
			for i in possibleNodes:
				stats.append({"nodeId":i,"holdingCost":I_total[i][0]*h[i][t-1],"transportCost":c[i][v["currentNode"]],"revenue":d_total[i][t] * u[i][0]})

			# Find best node
			bestNode = stats[0]
			metric = 0
			for nodeStat in stats:
				if ((nodeStat["revenue"] - nodeStat["holdingCost"] - nodeStat["transportCost"]) > metric):
					bestNode = nodeStat

			# Check if vehicle can meet demand of best node
			if (v["quantity"]>=d_total[bestNode["nodeId"]][t]):
				coveredNodes.append(bestNode["nodeId"])
				v["currentNode"] = bestNode["nodeId"]
				v["quantity"] = v["quantity"] - d_total[bestNode["nodeId"]][t]
				v["route"].append(bestNode["nodeId"])
				totalTransported = totalTransported + d_total[bestNode["nodeId"]][t]
		
	# Print best route
	for v in vehicles:
		print('Best route for vehicle ', v["vehicleId"],' in period ',t,': ',v["route"])