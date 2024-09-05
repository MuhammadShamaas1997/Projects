param n; # Number of variables
 param m; # Number of constraints
 param c {j in 1..n};
 param b {i in 1..m};
 param a {i in 1..m, j in 1..n};
 var x {j in 1..n} >= 0;
 maximize z: sum {j in 1..n} c[j] * x[j];
 subject to constr {i in 1..m}: sum {j in 1..n} a[i,j] * x[j] <= b[i];