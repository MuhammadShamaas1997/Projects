 set P; # Products
 set M; # Machines
 param a {i in M, j in P}; # time required for product j on machine i
 param b {j in P}; # profit per product
 param t {i in M}; # available machine i time per week
 param w; # available worker time per week
 var x {i in M} >=0; # number of hours workers spend each week on machine i
 var p {j in P} >= 0; # units of product j produced
 maximize Total_Profit: sum {j in P} b[j] * p[j];
 subject to Machine_time1 {i in M}: sum {j in P} a[i,j] * p[j]- x[i] <= 0;
 subject to Machine_time_bound {i in M}: x[i] <= t[i];
 subject to worker_time: sum {i in M} x[i] <= w;