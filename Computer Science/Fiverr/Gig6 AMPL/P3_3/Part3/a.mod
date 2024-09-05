 var p >=0;
 var a1 >=0;
 var a2 >=0;
 var h1 >=0;
 var h2 >=0;
 # objective
 maximize z: 130*a2 + 60*a1 + 40*h1 + 90*h2- 40*p;
 # constraints
 subject to c1: p <= 20;
 subject to c2: a1 + a2- 0.5*p = 0;
 subject to c3: h1 + h2- 0.5*p = 0;
 subject to c4: a2 + 0.75*h2 <= 8;