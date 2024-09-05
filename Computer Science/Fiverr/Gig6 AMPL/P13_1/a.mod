# A general Binary Integer Linear Programming Model
 param n; # Number of variables
 param me; # Number of equality constraints
 param mg; # Number of >= inequality constraints
 param ml; # Number of <= inequality constraints
 param c {j in 1..n};
 param be {i in 1..me};
 param bg {i in 1..mg};
 param bl {i in 1..ml};
 param ae {i in 1..me, j in 1..n};
 param ag {i in 1..mg, j in 1..n};
 param al {i in 1..ml, j in 1..n};
 var x {j in 1..n} binary;
 maximize z: sum {j in 1..n} c[j] * x[j];
 subject to e_constr {i in 1..me}: sum {j in 1..n} ae[i,j] * x[j] = be[i];
 subject to g_constr {i in 1..mg}: sum {j in 1..n} ag[i,j] * x[j] >= bg[i];
 subject to l_constr {i in 1..ml}: sum {j in 1..n} al[i,j] * x[j] <= bl[i];