 set N;
 set E within (N cross N);
 var x {(i,j) in E} binary;
 maximize f:
 sum {(i,j) in E} x[i,j];
 subject to
 degree {i in N}:
 sum {(i,j) in E} x[i,j]+sum {(j,i) in E} x[j,i] = 2;