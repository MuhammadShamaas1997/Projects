% Define constants (c_i, L_i, Z_i, etc.)
c = [1, 2, 3]; % Example coefficients (you'll need to use actual values)
L = [4, 5, 6]; % Example L_i values
Z = [7, 8, 9]; % Example Z_i values
sigma = 0.5;   % Example sigma value
K = 1;         % Example K value

% Define the inner product function
innerProduct = @(a, b) sum(a .* b);

% Define the objective function F(w)
objFun = @(w) K * (exp(sum(c .* L .* exp(w))) * exp(sum(c .* L .* exp(w))) - 2 * sigma) ...
        + sum(c .* arrayfun(@(i) innerProduct(exp(w(i)), w(i)), 1:length(w)));

% Define the constraint function (equality)
constraint = @(w) deal([], 2 * sigma + exp(sum(Z .* c .* exp(w))) - 0);

% Initial guess for w
w0 = ones(size(c)); % Initial guess (adjust depending on your system)

% Options for fmincon (optional)
options = optimoptions('fmincon','Display','iter','Algorithm','sqp');

% Call fmincon
[w_opt, fval] = fmincon(objFun, w0, [], [], [], [], [], [], constraint, options);

% Display the result
disp('Optimal w:');
disp(w_opt);
disp('Objective function value:');
disp(fval);
