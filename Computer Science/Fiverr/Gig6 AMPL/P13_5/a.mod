 param n := 9;
 /* size of the puzzle */
 param b := 3; /* block size */
 param notyet{1..n, 1..n}, integer, >= 0, <= n, default 0;
 var x{i in 1..n, j in 1..n, k in 1..n} binary;
 /* x[i,j,k] = 1 iff the number assigned to cell (i,j) is k */
 /* no objective is needed */
 s.t. fixed{i in 1..n, j in 1..n, k in 1..n: notyet[i,j] > 0}:
 x[i,j,k] = (if notyet[i,j] = k then 1 else 0);
 /* assign the values of variables that are given */
 assignment{i in 1..n, j in 1..n}: sum{k in 1..n} x[i,j,k] = 1;
 /* each cell (i,j) must be assigned one number */
 row{i in 1..n, k in 1..n}: sum{j in 1..n} x[i,j,k] = 1;
 /* each number k must appear once in every row */
 column{j in 1..n, k in 1..n}: sum{i in 1..n} x[i,j,k] = 1;
 /* each number k must appear once in every column */
 block{p in 1..(n/b), q in 1..(n/b), k in 1..n}:
 sum{i in b*(p-1)+1..b*p, j in b*(q-1)+1..b*q} x[i,j,k] = 1;
 /* each number k must appear once in every block */