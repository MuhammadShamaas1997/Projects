import math
import random 
#import matplotlib.pyplot as plt
#import networkx as nx


def read_data(file_path):
    with open(file_path, 'r') as file:
        data = file.read()
    lines = data.split('\n')

    # Read first line
    values = lines[0].split()
    n = int(values[0])  # Number of customers
    s = int(values[1])  # Maximum age of products
    K = int(values[2])  # Number of vehicles
    H = int(values[3])  # Number of periods
    Q = [float(values[4]) for _ in range(K + 1)]  # Capacity of vehicles

    # Define data arrays
    r = [0 for _ in range(H + 1)]  # Replenishments of depot for different periods
    C = [0 for _ in range(n + 1)]  # Capacity of customers
    Xcoord = [0 for _ in range(n + 1)]  # X coordinates of nodes
    Ycoord = [0 for _ in range(n + 1)]  # Y coordinates of nodes
    c = [[0 for _ in range(n + 1)] for _ in range(n + 1)]  # Transport cost for nodes
    h = [[0 for _ in range(s + 1)] for _ in range(n + 1)]  # Holding costs of nodes of different ages 
    u = [[0 for _ in range(s + 1)] for _ in range(n + 1)]  # Revenues for nodes for products of different ages
    I_total = [[0 for _ in range(H + 1)] for _ in range(n + 1)]  # Inventory of nodes for different time periods
    d_total = [[0 for _ in range(H + 1)] for _ in range(n + 1)]  # Demand of nodes for different time periods

    # Read second line
    values = lines[1].split()
    Xcoord[0] = float(values[0])
    Ycoord[0] = float(values[1])
    I_total[0][0] = float(values[2])
    for i in range(H):
        r[i + 1] = float(values[3 + i])
    for i in range(s + 1):
        h[0][i] = float(values[3 + H + i])

    # Read data of customers
    for cI in range(1, n + 1):
        values = lines[1 + cI].split()
        Xcoord[cI] = float(values[0])
        Ycoord[cI] = float(values[1])
        C[cI] = float(values[2])
        I_total[cI][0] = float(values[3])
        for i in range(H):
            d_total[cI][i + 1] = float(values[4 + i])
        for i in range(s + 1):
            u[cI][i] = float(values[4 + H + i])
        for i in range(s + 1):
            h[cI][i] = float(values[4 + H + s + i + 1])

    for i in range(n + 1):
        for j in range(n + 1):
            c[i][j] = math.sqrt(math.pow(Xcoord[i] - Xcoord[j], 2) + math.pow(Ycoord[i] - Ycoord[j], 2))

    # # Print data
    # print('n',n)
    # print('')
    # print('s',s)
    # print('')
    # print('K',K)
    # print('')
    # print('H',H)
    # print('')
    # print('Q',Q)
    # print('')
    # print('X coordinates',Xcoord)
    # print('')
    # print('Y coordinates',Ycoord)
    # print('')
    # print('I_total',I_total)
    # print('')
    # print('d_total',d_total)
    # print('')
    # print('r',r)
    # print('')
    # print('C',C)
    # print('')
    # print('h',h)
    # print('')
    # print('u',u)
    # print('')
    # print('')
    # print('c',c)
    # print('')


    return n, s, K, H, Q, r, C, Xcoord, Ycoord, c, h, u, I_total, d_total

def initialize_inventory(n, I_total):
    inventory = [{}]
    for i in range(1, n + 1):
        inventory.append({
            "nodeId": i,
            "quantity": I_total[i][0],
            "age": 0
        })
    return inventory


def greedy_algo(n, s, K, H, Q, r, C, Xcoord, Ycoord, c, h, u, I_total, d_total, inventory):
    total_profit = 0
    depotInventory = I_total[0] 
    for t in range(1, H + 1):
        profit = 0
        print("\nPeriod # ", t, " started")
        vehicles = [{"vehicleId": i, "currentNode": 0, "quantity": Q[i], "route": []} for i in range(1, K + 1)]
        
        # Initialize covered nodes
        coveredNodes = [0]
        totalTransported = 0
        transportCost = 0

        # Loop while demand of each node has not been met
        while n >= len(coveredNodes):
            # Find best nodes which are closest to current node and provide best revenue
            for v in vehicles:                
                possibleNodes = [i for i in range(n + 1) if i not in coveredNodes]

                # Compute stats for unvisited nodes
                stats = []
                for i in possibleNodes:
                    stats.append({
                        "nodeId": i,
                        "holdingCost": (h[i][t-1]),
                        "transportCost": c[i][v["currentNode"]],
                        "revenue": d_total[i][t] * u[i][0]
                    })

                # Find best node
                bestNode = stats[0]
                metric = 0
                complete = False
                for nodeStat in stats:
                    nodeDemand = d_total[nodeStat["nodeId"]][t]
                    age = inventory[nodeStat["nodeId"]]["age"]

                     # Check if the inventory is too old to be used
                    if age > s:
                        continue  # Skip this node because its inventory is expired


                    sellingCost = u[nodeStat["nodeId"]][age] if age <= s else 0


                    # Comparing Profits (Using Existing Inventory vs. Transporting New) þ.a. ef true þá 
                    #This if condition checks whether it is more profitable to use existing inventory at the node (if available) rather than transporting new inventory from the depot.
                    # Ef það er hagstæðara að nota existing inventroy þá förum við inní þessa lykkju
                    if (((nodeStat["revenue"] - inventory[nodeStat["nodeId"]]["quantity"] * nodeStat["holdingCost"] - nodeStat["transportCost"]) 
                    < nodeDemand * sellingCost - (inventory[nodeStat["nodeId"]]["quantity"] - nodeDemand) * nodeStat["holdingCost"]) and (inventory[nodeStat["nodeId"]]["quantity"] 
                    >= nodeDemand)):
                        # nodeStat["revenue"]: Represents the revenue that would be generated by delivering NEW inventory to the node.
                        # inventory[nodeStat["nodeId"]]["quantity"] * nodeStat["holdingCost"]: This is the total holding cost of the current inventory at the node. It considers how much inventory is held and its associated cost.
                        # nodeStat["transportCost"]: This is the cost of transporting new inventory from the current vehicle location to the node.
                        # The expression above Represents the effective profit if new inventory is transported to the node. It subtracts the holding cost and the transport cost from the revenue.

                        # nodeDemand * sellingCost: 
                        # This represents the revenue generated by fulfilling the demand using the EXISTING inventory at the node, considering the selling price of that aged inventory.
                        # (inventory[nodeStat["nodeId"]]["quantity"] - nodeDemand) * nodeStat["holdingCost"]): Holding cost of the inventory left at the customers
                        # (inventory[nodeStat["nodeId"]]["quantity"] >= nodeDemand): Ensures that there is enough existing inventory at the node to fulfill the demand.
                        

                        coveredNodes.append(nodeStat["nodeId"])

                        # Hérna líka appenda við lista!
                        # Gæti kanski notað notestat?



                        # The node is marked as "covered," meaning its demand has been fulfilled using existing inventory. It’s added to the coveredNodes list, so it won’t be revisited later.
                        inventory[nodeStat["nodeId"]]["quantity"] -= nodeDemand 
                        # The inventory at the node is decreased by the amount of demand that was fulfilled. This updates the remaining inventory at the node after fulfilling the demand.
                        profit += (nodeDemand * sellingCost) - (inventory[nodeStat["nodeId"]]["quantity"] * nodeStat["holdingCost"])                        
                        # Adds the profit generated from selling the existing inventory at the node.
                        # Subtracts the holding cost of the remaining inventory after fulfilling the demand.
                        complete = True 
                        # Set to true to indicate that the node has been serviced!
                        # This flag is set to True to indicate that the node's demand has been fully satisfied using existing inventory. This prevents further actions for this node in the current period.
                        print("Inventory used to meet demand of node # ", nodeStat["nodeId"])
                        #print(nodeDemand,' ',sellingCost,' ',(nodeDemand * sellingCost),' ',inventory[nodeStat["nodeId"]]["quantity"],' ',nodeStat["holdingCost"],' ',(inventory[nodeStat["nodeId"]]["quantity"] * nodeStat["holdingCost"]))
                        break

                    # Selecting the Best Node If Transporting New Inventory Is More Profitable
                    elif ((nodeStat["revenue"] - inventory[nodeStat["nodeId"]]["quantity"] * nodeStat["holdingCost"] - nodeStat["transportCost"]) > metric):
                        bestNode = nodeStat
                        # Hérna myndi ég þá bara appenda við einhvern lista, til að fá profit lista fyrir the route! og myndi þá appenda profit líka


                        # Ef ég nota þetta þá er ég að fá hærri profit!
                        metric = nodeStat["revenue"] - inventory[nodeStat["nodeId"]]["quantity"] * nodeStat["holdingCost"] - nodeStat["transportCost"]


                        # This elif condition is evaluated if the if condition is not met. It checks if the profit from transporting new inventory to the node is higher than the current metric (the highest profit found so far).
                        # metric; Tracks the highest profit found while evaluating possible nodes. Initially, it’s set to 0.
                        # If the current node offers a higher profit than the previously found best option, it updates bestNode to this node. This node will be the target for transporting new inventory if no existing inventory was used.
                        



                # Check if vehicle can meet demand of best node
                if (v["quantity"] >= d_total[bestNode["nodeId"]][t] and (not complete)): # ÚTAF ÞVÍ AÐ VIÐ ERUM BÚINN AÐ MERKJA VIÐ TRUE, ÞÁ FÖRUM VIÐ ALDREI INNÍ ÞESSA LYKKJU!!!!! EF VIÐ VELJUM AÐ NOTA GAMLA INVENTROY ÞEAS
                    coveredNodes.append(bestNode["nodeId"])
                    print("Vehicle visited node # ", bestNode["nodeId"])
                    v["currentNode"] = bestNode["nodeId"]
                    v["quantity"] -= d_total[bestNode["nodeId"]][t]
                    v["route"].append(bestNode["nodeId"])
                    depotInventory[0] = depotInventory[0] - d_total[bestNode["nodeId"]][t] 
                    #print(d_total[bestNode["nodeId"]][t],' ',u[bestNode["nodeId"]][0],' ',bestNode["revenue"],' ',inventory[bestNode["nodeId"]]["quantity"],' ',bestNode["holdingCost"],' ',inventory[bestNode["nodeId"]]["quantity"] * bestNode["holdingCost"])
                    profit += bestNode["revenue"] - inventory[bestNode["nodeId"]]["quantity"] * bestNode["holdingCost"] - bestNode["transportCost"]
                    transportCost += bestNode["transportCost"]
                    totalTransported += d_total[bestNode["nodeId"]][t]

        # for i in range(1, n + 1):
        #     inventory[i]["age"] += 1
        #     inventory[i]["quantity"] = inventory[i]["quantity"] if t <= s else 0


        # Update the age of inventory and discard any that is too old
        for i in range(1, n + 1):
            inventory[i]["age"] += 1
            if inventory[i]["age"] > s:
                inventory[i]["quantity"] = 0  # Discard expired inventory
            inventory[i]["quantity"] = inventory[i]["quantity"] if t <= s else 0
            
            
        # Print best route
        for v in vehicles:
            print('Best route for vehicle ', v["vehicleId"], ' in period ', t, ': ', v["route"])

        # Calculate holding costs at depot
        for i in range(H):
            #print(depotInventory[i],' ',h[0][i],' ',depotInventory[i] * h[0][i])
            profit = profit - depotInventory[i] * h[0][i]
          
        # Age products and add replenishments at depot
        for i in range(H-1,0,-1):
            depotInventory[i] = depotInventory[i-1]
        depotInventory[0] = r[t]

        #print('Transport cost for period ', t, ' = ', transportCost)
        print('Total profit for period ', t, ' = ', profit)
        total_profit += profit
    print('Total profit for all periods = ', total_profit)


def build_RCL(profit_list, RCL_size):
    # Sort the profit list in descending order based on profit
    sorted_profit_list = sorted(profit_list, key=lambda x: x['profit'], reverse=True)
    #print(sorted_profit_list)
    
    # Select the top N nodes for the RCL
    RCL = sorted_profit_list[:RCL_size]
    
    return RCL

# Tabu Search Class
class TabuSearch:
    def __init__(self, initial_solution, max_iterations, c, tabu_tenure=5):
        self.current_solution = initial_solution  # Starting solution (from GRASP or another heuristic)
        self.best_solution = initial_solution
        self.tabu_list = []  # List to store tabu moves
        self.max_iterations = max_iterations
        self.tabu_tenure = tabu_tenure  # How long a move stays on the tabu list
        self.c = c # Transport costs

    def neighborhood(self):
        """
        Generate neighbors by performing Inventory Swaps and Route Changes.
        """
        neighbors = []
        # Only perform route change if vehicle_routes has more than 1 node
        if len(self.current_solution['vehicle_routes']) > 1:
            neighbors.append(self.route_change(self.current_solution))
        return neighbors

    def route_change(self, solution):
        """
        Perform a route change (2-opt or reverse a subset of nodes).
        Example: Swap the order of two nodes.
        """
        new_solution = solution.copy()
        # Logic to swap nodes in the current route (example: swap two random nodes)
        vIndex = 0
        for vRoute in new_solution['vehicle_routes']: 
            route = vRoute
            if len(route) > 1:
                lastNode = 0
                for node in route:
                    new_solution['profit'] = new_solution['profit'] - self.c[lastNode][node]
                    lastNode = node 
                idx1, idx2 = random.sample(range(len(route)), 2)
                route[idx1], route[idx2] = route[idx2], route[idx1]
                lastNode = 0
                for node in route:
                	new_solution['profit'] = new_solution['profit'] + self.c[lastNode][node]
                	lastNode = node 

            new_solution['vehicle_routes'][vIndex] = route
            vIndex = vIndex + 1
        return new_solution

    def is_tabu(self, move):
        """
        Check if a move is tabu.
        """
        return move in self.tabu_list

    def aspiration_criteria(self, move, solution):
        """
        Define when to accept a move despite it being tabu.
        Example: Accept if the solution is better than the current best.
        """
        return solution["profit"] > self.best_solution["profit"]

    def update_tabu_list(self, move):
        """
        Update the tabu list by adding the move and removing old entries.
        """
        self.tabu_list.append(move)
        if len(self.tabu_list) > self.tabu_tenure:
            self.tabu_list.pop(0)

    def run(self):
        """
        Main loop of the Tabu Search.
        """
        for iteration in range(self.max_iterations):
            # Generate neighborhood solutions
            neighbors = self.neighborhood()
            
            # Evaluate all neighbors and select the best non-tabu move
            best_neighbor = None
            best_value = float('-inf')
            
            for neighbor in neighbors:
                value = neighbor["profit"]
                move = neighbor  # Simplified for demonstration
                if (not self.is_tabu(move)) or self.aspiration_criteria(move, neighbor):
                    if value > best_value:
                        best_value = value
                        best_neighbor = neighbor

            # Update current solution
            if best_neighbor is not None:
                self.current_solution = best_neighbor
                self.update_tabu_list(best_neighbor)
                if best_value > self.best_solution["profit"]:
                    self.best_solution = best_neighbor
            
            print(f"Iteration {iteration}: Best value = {best_value}")

        return self.best_solution


def greedy_randomized(n, s, K, H, Q, r, C, Xcoord, Ycoord, c, h, u, I_total, d_total, inventory, alpha=0.2):
    total_profit = 0
    depotInventory = I_total[0]
    
    for t in range(1, H + 1):
        initial_solution = {"inventory_used":[],"vehicle_routes":[],"depotInventory":depotInventory,"inventory":inventory,}
        profit = 0
        print("\nPeriod # ", t, " started")
        
        vehicles = [{"vehicleId": i, "currentNode": 0, "quantity": Q[i], "route": []} for i in range(1, K + 1)]
        
        # Initialize covered nodes
        coveredNodes = [0]
        #totalTransported = 0
        #transportCost = 0
        
        # Loop while demand of each node has not been met
        while n >= len(coveredNodes):
            for v in vehicles:
                profit_list = []  # Initialize profit_list for each vehicle
                
                possibleNodes = [i for i in range(1, n + 1) if i not in coveredNodes]

                if (len(possibleNodes)==0):
                	continue

                for i in possibleNodes:
                    nodeStat = {
                        "nodeId": i,
                        "holdingCost": (h[i][t-1] if ((t-1) <= s) else 0),
                        "transportCost": c[i][v["currentNode"]],
                        "revenue": d_total[i][t] * u[i][0]
                    }
                    nodeDemand = d_total[nodeStat["nodeId"]][t]
                    age = inventory[nodeStat["nodeId"]]["age"]

                    # Check if the inventory is too old to be used
                    if age > s:
                    	# Consistent profit calculation for new transport
                    	profit_new = nodeStat["revenue"] - (inventory[nodeStat["nodeId"]]["quantity"] * nodeStat["holdingCost"]) - nodeStat["transportCost"]
                    	profit_list.append({"nodeId": i, "profit": profit_new, "inventory_type": "new"})
                    	continue

                    sellingCost = u[nodeStat["nodeId"]][age] if age <= s else 0

                    # Consistent profit calculation for existing inventory
                    if inventory[nodeStat["nodeId"]]["quantity"] >= nodeDemand:
                        profit_existing = (nodeDemand * sellingCost) - ((inventory[nodeStat["nodeId"]]["quantity"] - nodeDemand) * nodeStat["holdingCost"])
                    else:
                        profit_existing = float('-inf')  # Impossible to use existing inventory

                    # Consistent profit calculation for new transport
                    profit_new = nodeStat["revenue"] - (inventory[nodeStat["nodeId"]]["quantity"] * nodeStat["holdingCost"]) - nodeStat["transportCost"]

                    # Choose the better option and add it to profit_list
                    if profit_existing >= profit_new:
                        profit_list.append({"nodeId": i, "profit": profit_existing, "inventory_type": "existing"})
                    else:
                        profit_list.append({"nodeId": i, "profit": profit_new, "inventory_type": "new"})

                # Determine the size of the RCL based on alpha
                # rcl_size = max(1, int(alpha * len(profit_list)))
                rcl_size = 3

                # Build the RCL using the provided function
                RCL = build_RCL(profit_list, rcl_size)




                # Print the complete profit_list and RCL for this vehicle and period
                #print(f"\nProfit List for Vehicle {v['vehicleId']} in Period {t}:")
                #for entry in profit_list:
                    #print(f"  Node ID: {entry['nodeId']}, Profit: {entry['profit']:.2f}, Inventory Type: {entry['inventory_type']}")
                
                #print(f"RCL for Vehicle {v['vehicleId']} in Period {t}:")
                #for entry in RCL:
                    #print(f"  Node ID: {entry['nodeId']}, Profit: {entry['profit']:.2f}, Inventory Type: {entry['inventory_type']}")





                # Select the highest profit node from the RCL (deterministic for now)
                # bestNode = RCL[0] choose the best one always. then we just have the original greedy algorithm
                bestNode = random.choice(RCL)

                # Check if the best option is using existing inventory or new transport
                if bestNode['inventory_type'] == "existing":
                    coveredNodes.append(bestNode["nodeId"])
                    inventory[bestNode["nodeId"]]["quantity"] -= d_total[bestNode["nodeId"]][t]
                    profit += bestNode['profit']
                    initial_solution["inventory_used"].append(bestNode["nodeId"])
                    #print(f"Inventory used to meet demand of node # {bestNode['nodeId']}")
                else:
                    if v["quantity"] >= d_total[bestNode["nodeId"]][t]:
                        coveredNodes.append(bestNode["nodeId"])
                        #print(f"Vehicle visited node # {bestNode['nodeId']}")
                        v["currentNode"] = bestNode["nodeId"]
                        v["quantity"] -= d_total[bestNode["nodeId"]][t]
                        v["route"].append(bestNode["nodeId"])
                        depotInventory[0] -= d_total[bestNode["nodeId"]][t]
                        profit += bestNode['profit']
                        #transportCost += nodeStat["transportCost"]
                        #totalTransported += d_total[bestNode["nodeId"]][t]
        
        for i in range(1, n + 1):
            inventory[i]["age"] += 1
            if inventory[i]["age"] > s:
                inventory[i]["quantity"] = 0  # Discard expired inventory
            inventory[i]["quantity"] = inventory[i]["quantity"] if t <= s else 0

        # Print best route
        for v in vehicles:
            initial_solution["vehicle_routes"].append(v["route"])
            #print('Best route for vehicle ', v["vehicleId"], ' in period ', t, ': ', v["route"])

        # Calculate holding costs at depot
        for i in range(H):
            profit -= depotInventory[i] * (h[0][i] if i<=s else 0)
        
        for i in range(H - 1, 0, -1):
            depotInventory[i] = depotInventory[i - 1]
        depotInventory[0] = r[t]

        initial_solution["profit"] = profit;
        tabu_search = TabuSearch(initial_solution, max_iterations=10, c=c)
        best_solution = tabu_search.run()
        print('Total profit for period ', t, ' = ', best_solution['profit'])
        total_profit += best_solution['profit']
        # Output the best solution found
        print(f"Best solution: {best_solution}")
        print(f"Inventory: {inventory}")
    print('Total profit for all periods = ', total_profit)


def main(file_path):
    # Step 1: Read and parse data
    n, s, K, H, Q, r, C, Xcoord, Ycoord, c, h, u, I_total, d_total = read_data(file_path)
    
    # Step 2: Initialize inventory
    inventory = initialize_inventory(n, I_total)
    
    # Step 3: Run the simulation
    #greedy_algo(n, s, K, H, Q, r, C, Xcoord, Ycoord, c, h, u, I_total, d_total, inventory)
    greedy_randomized(n, s, K, H, Q, r, C, Xcoord, Ycoord, c, h, u, I_total, d_total, inventory)
import sys
if __name__ == "__main__":
    #file_path = './Supplied/pirp/pirp-10-2-1-3-1.dat'
    print (sys.argv[1])

    file_path = './Supplied/pirp/pirp-'+sys.argv[1]+'.dat' # Works
    main(file_path)
