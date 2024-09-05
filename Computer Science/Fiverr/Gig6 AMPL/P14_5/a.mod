set B := 1..4;
 set P := 1..5;
 param b{B};
 param d{P};
 param c{B, P};
 var x{i in B, j in P} >=0;
 var y1 binary;
 var y2 binary;
 var y3 binary;
 var y4 binary;
 var y5 binary;
 var w>=0, integer;
 minimize z:
 sum {i in B, j in P} c[i,j]*x[i,j];
 s.t. demand{j in P}:
 sum {i in B} x[i,j] >= d[j];
 s.t. capacity{i in B}:
 sum {j in P} x[i,j] <= b[i];
 s.t. c1: sum {j in P} x[1,j] + 500*y1 >= 500;
 s.t. c2: sum {j in P} x[1,j] + 800*y1 <= 800;
 s.t. c3: sum {j in P} x[2,j]- 100*w = 0;
 s.t. c4: x[3,4]- 700*y2 <= 200;
 s.t. c5: x[3,4] + 200*y2 >= 200;
 s.t. c6: x[3,1]- 600*y3 <= 300;
 s.t. c7: x[3,2] + 200*y4 >= 200;
 s.t. c8: y2 + y3 + y4 <= 2;
 s.t. c9: x[4,1] + 300*y5 >= 300;
 s.t. c10: x[4,2]- 200*y5 >= 0;