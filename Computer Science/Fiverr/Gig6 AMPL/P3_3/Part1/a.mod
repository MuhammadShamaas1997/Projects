 # sets
 set Foods;
 set Nutrients;
 # parameters
 param cost {i in Foods};
 param requirement {j in Nutrients};
 param info {i in Foods, j in Nutrients};
 # variables
 var x{i in Foods} >=0;
 # objective
 minimize z: sum {i in Foods} cost[i]*x[i];
 # constraints
 subject to ingestion {j in Nutrients}: sum {i in Foods} info[i,j]*x[i] >=requirement[j];