 set P; # Products
 param s {i in P}; # sell price per pound of product
 param t {i in P}; # packaging time per pound of product
 param w; # available worker time per day
 param p; # purchase price per pound of unprocessed beef
 param M; # pounds of beef per day that can be purchased
 var x {i in P} >=0; # pounds of each product sold
 var y >= 0; # pounds of unprocessed beef purchased
 maximize Total_Profit: sum {i in P} s[i]*x[i]- p*y;
 subject to Max_purchased: y <= M;
 subject to steak_amount: x['bulksteak'] + x['steak']- 0.5*y = 0;
 subject to ground_amount: x['bulkground'] + x['ground']- 0.5*y = 0;
 subject to labor_time: sum {i in P} t[i]*x[i] <= w;