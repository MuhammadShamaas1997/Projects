 set C := 1..3;
 set B:= 1..4;
 param b{C};
 param d{B};
 param c{C, B};
 var x{i in C, j in B} >=0;
 var y1 binary;
 var y2 binary;
 var y3 binary;
 var y4 binary;
 var y5 binary;
 var w>=0, integer;
 minimize z:
 sum {i in C, j in B} c[i,j]*x[i,j];
 s.t. demand{j in B}:
 sum {i in C} x[i,j] >= d[j];
s.t. capacity{i in C}:
 sum {j in B} x[i,j] <= b[i];
 s.t. c1: x[1,1] + 15*y1 >=15;
 s.t. c2: x[1,1] + 50*y1 <=50;
 s.t. c3: x[2,1]- 30*y2 <=10;
 s.t. c4: x[2,2] + 5*y3 >=5;
 s.t. c5: x[2,3]- 33*y4 <=7;
 s.t. c6: x[2,3] + 7*y4 >=7;
 s.t. c7: y2 + y3 + y4 <= 1;
 s.t. c8: x[3,1] + x[3,2] + x[3,3] + x[3,4]-10*w = 0;
 s.t. c9: x[3,1]- 45*y5 <=15;
 s.t. c10: x[3,2] + 20*y5 >=20;