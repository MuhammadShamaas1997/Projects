 var a1 >=0;
 var a2 >=0;
 var w1 >=0;
 var w2 >=0;
 # objective
 maximize z: 1.1*a1 + 0.9*a2 + w1 + 0.8*w2;
 # constraints
 subject to c1: w1 + w2 <= 1000;
 subject to c2: a1 + a2 <= 800;
 subject to c3: 0.2*w1- 0.8*a1 >= 0;
 subject to c4: 0.4*a2- 0.6*w2 >= 0;