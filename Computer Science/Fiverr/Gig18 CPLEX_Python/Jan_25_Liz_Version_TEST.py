from sklearn.model_selection import GridSearchCV, train_test_split
from sklearn.preprocessing import OneHotEncoder, OrdinalEncoder, PolynomialFeatures
from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import StandardScaler
from sklearn.compose import ColumnTransformer, make_column_transformer
from sklearn.linear_model import LinearRegression, Ridge
from sklearn.pipeline import Pipeline, make_pipeline
from sklearn.metrics import r2_score
import gurobipy_pandas as gppd
from gurobi_ml import add_predictor_constr
import gurobipy as gp
import pandas as pd
import warnings
import numpy as np

# Load and preprocess the dataset
dataset = pd.read_csv('test-out.csv')
dataset["date"] = pd.to_datetime(dataset["date"])
dataset['occupied'] = dataset['spaces'] - dataset['Available']
dataset = dataset.dropna()

# Filter dataset by specific parking lots
lots = [
    "Civic Center",
    "Structure 2",
    "Structure 3",
    "Lot 8",
    "Structure 5",
]
df = dataset[dataset.lot.isin(lots)].copy()  # Avoid SettingWithCopyWarning
sample_fraction = 0.00003  # Adjust this fraction to control the size of the sample
df = df.sample(frac=sample_fraction, random_state=1)

# Categorize price based on lot type
def categorize_price(lot):
    if lot == 'Civic Center':
        return 8.5
    elif lot == 'Lot 8':
        return 10
    else:
        return 5

df['price'] = df['lot'].apply(categorize_price)
df.loc[:, 'price'] = pd.to_numeric(df['price'])  # Avoid SettingWithCopyWarning

# Features and target variable
X = df[["lot", "day", "hour", "price"]]
y = df["occupied"]

# Handle missing values and fit the encoder on full dataset
X = X.fillna("missing")

# Define categorical and numerical features
categorical_features = ["lot"]
numerical_features = ["day", "hour","price"]

# Apply OneHotEncoder to categorical features
encoder = OneHotEncoder(sparse=False, handle_unknown="ignore")
X_encoded = encoder.fit_transform(X[categorical_features])

# Convert encoded features to DataFrame
X_encoded_df = pd.DataFrame(X_encoded, columns=encoder.get_feature_names_out(categorical_features))

# Reset index of numerical features to ensure alignment
X_numerical_df = X[numerical_features].reset_index(drop=True)

# Concatenate encoded features with numerical features
X_transformed = pd.concat([X_encoded_df, X_numerical_df], axis=1)

# Split the data for training and testing
X_train, X_test, y_train, y_test = train_test_split(
    X_transformed, y, train_size=0.8, random_state=1
)

# Create a pipeline with polynomial features and Ridge regression
pipeline = Pipeline([
    #('poly', PolynomialFeatures(degree=2, include_bias=False)),
    ('scaler', StandardScaler()),
    ('regressor', Ridge())
])

# Define hyperparameters for GridSearchCV
param_grid = {
    'regressor__alpha': [0.1, 1.0, 10.0]
}

# Perform GridSearchCV
grid_search = GridSearchCV(pipeline, param_grid, cv=5, scoring='r2')
grid_search.fit(X_train, y_train)

# Get the best model
best_model = grid_search.best_estimator_

# Get R^2 value from test data
y_pred = best_model.predict(X_test)
print(f"The R^2 value in the test set is {np.round(r2_score(y_test, y_pred), 5)}")

# Train the model on the full dataset
best_model.fit(X_transformed, y)
y_pred_full = best_model.predict(X_transformed)
print(f"The R^2 value in the full dataset is {np.round(r2_score(y, y_pred_full), 5)}")

# Set up the optimization model
day = 1
B = 5000  # total amount of spaces supply
hour = 1
a_min = 5  # minimum price of parking in lot
a_max = 25  # maximum chargers in lot
year = 2020
c_waste = 10  # cost of wasting a space
spaces_min = 0
spaces_max = 1000

# Parking lot installation costs
c_install = pd.Series({
    "Civic Center": 12,
    "Structure 2": 10,
    "Structure 3": 10,
    "Lot 8": 80,
    "Structure 5": 10,
}, name='installation_cost')
c_install = c_install.loc[lots]

# Get lower and upper bounds for price and available spaces
data = pd.concat([
    c_install,
    df.groupby("lot")["occupied"].min().rename('min_Available'),
    df.groupby("lot")["occupied"].max().rename('max_Available')
], axis=1)

# Feature setup
feats = pd.DataFrame(
    data={
        "day": day,
        "hour": hour,
        "lot": lots
    },
    index=lots
)

# Build the optimization model
m = gp.Model("Car_Parking_Allocation")
p = gppd.add_vars(m, data, name="price", lb=a_min, ub=a_max)  # price of parking
x = gppd.add_vars(m, data, name="x", lb=spaces_min, ub=spaces_max)  # spaces to supply
s = gppd.add_vars(m, data, name="s")  # spaces filled
w = gppd.add_vars(m, data, name="w")  # spaces not filled
d = gppd.add_vars(m, data, lb=-gp.GRB.INFINITY, name="demand")  # regression demand prediction
m.update()

# Supply constraint
m.addConstr(x.sum() == B)
m.update()

# Parking quantity constraints
gppd.add_constrs(m, s, gp.GRB.LESS_EQUAL, x)
gppd.add_constrs(m, s, gp.GRB.LESS_EQUAL, d)
m.update()

# Wastage constraints
gppd.add_constrs(m, w, gp.GRB.EQUAL, x - s)
m.update()

# Create Gurobi variables for each feature in X_transformed
input_vars = pd.DataFrame(index=X_transformed.index)
for col in X_transformed.columns:
    input_vars[col] = gppd.add_vars(m, X_transformed.index, lb=-gp.GRB.INFINITY, name=col)

# Ensure there are no NaN values in input_vars
placeholder_var = m.addVar(lb=-gp.GRB.INFINITY, vtype=gp.GRB.CONTINUOUS, name="placeholder")
input_vars = input_vars.apply(lambda col: col.apply(lambda x: x if isinstance(x, gp.Var) else placeholder_var))

# Define output variable
output_vars = gppd.add_vars(m, pd.Index(range(len(input_vars))), lb=-gp.GRB.INFINITY, name="output")

# Add predictor constraint for demand using gurobi_ml
pred_constr = add_predictor_constr(
    gp_model=m,               # Gurobi model
    predictor=best_model,            # Trained regression pipeline
    input_vars=input_vars,    # Input variables in DataFrame format
    output_vars=output_vars   # Output variable
)

# Objective function: maximize revenue
m.setObjective((p * s).sum() - c_waste * w.sum() - (c_install * x).sum(), gp.GRB.MAXIMIZE)
m.Params.NonConvex = 2
m.optimize()

# Extract and print the optimal solution
solution = pd.DataFrame(index=lots)
solution["Price"] = p.gppd.X
solution["Allocated"] = x.gppd.X
solution["Parked"] = s.gppd.X
solution["Wasted"] = w.gppd.X
solution["Pred_demand"] = d.gppd.X

opt_revenue = m.ObjVal
print("\n The optimal net revenue: $%f million" % opt_revenue)
print(solution.round(4))

# Maximum error in regression approximation
print(
    "Maximum error in approximating the regression {:.6}".format(
        np.max(pred_constr.get_error())
    )
)
