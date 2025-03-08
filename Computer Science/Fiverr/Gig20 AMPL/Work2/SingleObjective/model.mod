# Define sets
set I;  # Set of indices i1 to i4
set J;  # Set of indices j1 to j3
set K;  # Set of indices k1 to k5
set L;  # Set of indices l1 to l4

# Define parameters
param A {J};  
param B {J};  
param C {J};  
param D {J};  
param O {J};  
param G {J};  
param H {J};  

param E {I};  
param F {L};  

param P {I, J};  
param Q {L, J};  

param d {K, J};  
param r {K, J};  

param alpha {J};  
param M {I, J};  

param t_ik {I, K};  
param t_kl {K, L};  
param t_li {L, I};  
param t_l {L};    

param N {L, J};  

# Define variables
var X {I, K, J} >= 0;  # Variable X(i,k,j)
var Y {K, L, J} >= 0;  # Variable Y(k,l,j)
var S {L, I, J} >= 0;  # Variable S(l,i,j)
var T {L, J} >= 0;     # Variable T(l,j)
var Z {I} binary;      # Variable Z(i) (binary)
var W {L} binary;      # Variable W(l) (binary)

# Define objective function
minimize z1: 
    sum {i in I} (E[i] * Z[i]) + 
    sum {l in L} (F[l] * W[l]) + 
    sum {i in I, k in K, j in J} ((A[j] + B[j] * t_ik[i,k]) * X[i,k,j]) + 
    sum {k in K, l in L, j in J} (C[j] * t_kl[k,l] * Y[k,l,j]) + 
    sum {l in L, i in I, j in J} ((-G[j] + D[j] * t_li[l,i]) * S[l,i,j]) + 
    sum {l in L, j in J} ((H[j] + O[j] * t_l[l]) * T[l,j]);

# Constraint: Ensure X(i,k,j) satisfies demand d(k,j)
subject to DemandConstraint {k in K, j in J}:  
    sum {i in I} X[i, k, j] >= d[k, j];

# Constraint: Limit total S(l,i,j) and X(i,k,j) based on Z(i) and P(i,j)
subject to CapacityConstraint {i in I}:  
    sum {l in L, j in J} S[l, i, j] + sum {k in K, j in J} X[i, k, j] <= Z[i] * sum {j in J} P[i, j];

# Constraint: Ensure Y(k,l,j) does not exceed available X(i,k,j)
subject to FlowConstraint {k in K, j in J}:  
    sum {l in L} Y[k, l, j] <= sum {i in I} X[i, k, j];

# Constraint: Ensure Y(k,l,j) satisfies the threshold defined by T(l,j)
subject to ThresholdConstraint {l in L, j in J}:  
    alpha[j] * sum {k in K} Y[k, l, j] <= T[l, j];

# Constraint: Limit total Y(k,l,j) based on W(l) and Q(l,j)
subject to CapacityLimitConstraint {l in L}:  
    sum {k in K, j in J} Y[k, l, j] <= W[l] * sum {j in J} Q[l, j];

# Constraint: Ensure flow balance between Y(k,l,j), S(l,i,j), and T(l,j)
subject to FlowBalanceConstraint {l in L, j in J}:  
    sum {k in K} Y[k, l, j] = sum {i in I} S[l, i, j] + T[l, j];

# Constraint: Ensure total Y(k,l,j) matches r(k,j)
subject to DemandSatisfactionConstraint {k in K, j in J}:  
    sum {l in L} Y[k, l, j] = r[k, j];
