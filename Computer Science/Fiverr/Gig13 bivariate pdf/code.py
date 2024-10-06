import numpy as np
from scipy.optimize import minimize
from scipy.special import gamma
from scipy.stats import linregress

# Logarithmic version of the bivariate generalized inverse gamma-Lomax distribution
def bivariate_gen_inv_gamma_lomax_log_pdf(x, y, alpha, beta, s, lambd):
    # Ensure no division by zero or negative values
    if np.any(x <= 0) or np.any(y <= 0) or alpha <= 0 or beta <= 0 or s <= 0 or lambd <= 0:
        return -np.inf
    
    log_numerator = (-beta / x) + np.log(s) + np.log(x) - (1 + alpha) * np.log(x) + alpha * np.log(beta) \
                    + (-1 - s * x) * np.log(1 + (y / lambd))
    
    log_denominator = np.log(lambd) + np.log(gamma(alpha))
    
    log_pdf = log_numerator - log_denominator
    return log_pdf

# Log-likelihood function
def log_likelihood(params, x_data, y_data):
    alpha, beta, s, lambd = params
    log_pdf_values = bivariate_gen_inv_gamma_lomax_log_pdf(x_data, y_data, alpha, beta, s, lambd)
    return -np.sum(log_pdf_values)

# Fit using Maximum Likelihood Estimation (MLE)
def fit_mle(x_data, y_data, initial_params):
    result = minimize(log_likelihood, initial_params, args=(x_data, y_data), method='L-BFGS-B')
    return result.x  # Returns the optimized parameters

# Fit using Least Squares Estimation (LSE)
def fit_lse(x_data, y_data, initial_params):
    residuals = lambda params: np.sum((y_data - np.exp(bivariate_gen_inv_gamma_lomax_log_pdf(x_data, y_data, *params)))**2)
    result = minimize(residuals, initial_params, method='L-BFGS-B')
    return result.x  # Returns the optimized parameters

# Function to calculate R-squared
def calculate_r_squared(y_data, y_pred):
    ss_res = np.sum((y_data - y_pred) ** 2)
    ss_tot = np.sum((y_data - np.mean(y_data)) ** 2)
    return 1 - (ss_res / ss_tot)

# Function to calculate AIC and BIC
def calculate_aic_bic(log_likelihood_val, n_params, n_data):
    aic = 2 * n_params - 2 * log_likelihood_val
    bic = np.log(n_data) * n_params - 2 * log_likelihood_val
    return aic, bic

# Example usage with synthetic data
x_data = np.random.rand(100) * 10  # Replace with actual x data
y_data = np.random.rand(100) * 10  # Replace with actual y data

# Initial parameter guess for MLE and LSE
initial_params = [1, 1, 1, 1]

# Fit the model using MLE
mle_params = fit_mle(x_data, y_data, initial_params)
print("MLE Parameters:", mle_params)

# Fit the model using LSE
lse_params = fit_lse(x_data, y_data, initial_params)
print("LSE Parameters:", lse_params)

# Calculate R-squared for MLE fit
y_pred_mle = np.exp(bivariate_gen_inv_gamma_lomax_log_pdf(x_data, y_data, *mle_params))
r_squared_mle = calculate_r_squared(y_data, y_pred_mle)
print("R-squared (MLE):", r_squared_mle)

# Calculate log-likelihood, AIC, BIC for MLE fit
log_likelihood_val = -log_likelihood(mle_params, x_data, y_data)
aic, bic = calculate_aic_bic(log_likelihood_val, len(mle_params), len(x_data))
print("AIC (MLE):", aic)
print("BIC (MLE):", bic)
