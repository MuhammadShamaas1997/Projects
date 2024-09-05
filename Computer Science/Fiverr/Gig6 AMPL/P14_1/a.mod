set I := 1..4;
 set J := 1..3;
 param c{I, J};
 param b{I};
 param f{I};
 param d{J};
 var x{i in I, j in J} >=0;
 var y{i in I} binary;
 minimize z:
 sum {i in I, j in J} c[i,j]*x[i,j] + sum {i in I} f[i]*y[i];
 s.t. demand{j in J}:
 sum {i in I} x[i,j] >= d[j];
 s.t. capacity{i in I}:
 sum {j in J} x[i,j] <= b[i];
 s.t. c3{i in I, j in J}:
 x[i,j]- b[i]*y[i] <=0;
 s.t. constr_a: y[1]- y[2] <=0;
 s.t. constr_b: y[1] + y[2] + y[3] + y[4] <=2;
 s.t. constr_c: y[2] + y[4] >=1;