import os 
import tarfile 
from six.moves import urllib

DOWNLOAD_ROOT = "https://raw.githubusercontent.com/ageron/handson-ml2/master/" 
HOUSING_PATH = os.path.join("datasets", "housing") 
HOUSING_URL = DOWNLOAD_ROOT + "datasets/housing/housing.tgz"
"""
def fetch_housing_data(housing_url=HOUSING_URL, housing_path=HOUSING_PATH):    
	if not os.path.isdir(housing_path):
		os.makedirs(housing_path)    
	tgz_path = os.path.join(housing_path, "housing.tgz")    
	urllib.request.urlretrieve(housing_url, tgz_path)    
	housing_tgz = tarfile.open(tgz_path)    
	housing_tgz.extractall(path=housing_path)    
	housing_tgz.close()

fetch_housing_data()
"""
import pandas as pd
def load_housing_data(housing_path=HOUSING_PATH):    
	csv_path = os.path.join(housing_path, "housing.csv")    
	return pd.read_csv(csv_path) 

housing=load_housing_data()
import matplotlib.pyplot as plt 
housing.hist(bins=50, figsize=(20,15)) 
plt.show()


import numpy as np
def split_train_test(data, test_ratio):
    shuffled_indices = np.random.permutation(len(data))
    test_set_size = int(len(data) * test_ratio)
    test_indices = shuffled_indices[:test_set_size]
    train_indices = shuffled_indices[test_set_size:]
    return data.iloc[train_indices], data.iloc[test_indices]

train_set, test_set = split_train_test(housing, 0.2)

from zlib import crc32
def test_set_check(identifier, test_ratio):
    return crc32(np.int64(identifier)) & 0xffffffff < test_ratio * 2**32
def split_train_test_by_id(data, test_ratio, id_column):
    ids = data[id_column]
    in_test_set = ids.apply(lambda id_: test_set_check(id_, test_ratio))    
    return data.loc[~in_test_set], data.loc[in_test_set] 

housing_with_id = housing.reset_index()   # adds an `index` column 
train_set, test_set = split_train_test_by_id(housing_with_id, 0.2, "index") 

housing_with_id["id"] = housing["longitude"] * 1000 + housing["latitude"] 
train_set, test_set = split_train_test_by_id(housing_with_id, 0.2, "id")

from sklearn.model_selection import train_test_split
train_set, test_set = train_test_split(housing, test_size=0.2, random_state=42)

housing["income_cat"] = pd.cut(housing["median_income"],bins=[0., 1.5, 3.0, 4.5, 6., np.inf],labels=[1, 2, 3, 4, 5])
housing["income_cat"].hist() 
plt.show()

from sklearn.model_selection import StratifiedShuffleSplit
split = StratifiedShuffleSplit(n_splits=1, test_size=0.2, random_state=42) 
for train_index, test_index in split.split(housing, housing["income_cat"]):
    strat_train_set = housing.loc[train_index]
    strat_test_set = housing.loc[test_index]

strat_test_set["income_cat"].value_counts() / len(strat_test_set) 

for set_ in (strat_train_set, strat_test_set):
    set_.drop("income_cat", axis=1, inplace=True) 

housing = strat_train_set.copy()
housing.plot(kind="scatter", x="longitude", y="latitude")
plt.show()

housing.plot(kind="scatter", x="longitude", y="latitude", alpha=0.1)
plt.show()

housing.plot(kind="scatter", x="longitude", y="latitude", alpha=0.4,    s=housing["population"]/100, label="population", figsize=(10,7),    c="median_house_value", cmap=plt.get_cmap("jet"), colorbar=True, ) 
plt.legend()
plt.show()

corr_matrix = housing.corr() 
corr_matrix["median_house_value"].sort_values(ascending=False)

from pandas.plotting import scatter_matrix
attributes = ["median_house_value", "median_income", "total_rooms","housing_median_age"] 
scatter_matrix(housing[attributes], figsize=(12, 8))
plt.show()

housing.plot(kind="scatter", x="median_income", y="median_house_value",alpha=0.1) 
plt.show()

housing["rooms_per_household"] = housing["total_rooms"]/housing["households"] 
housing["bedrooms_per_room"] = housing["total_bedrooms"]/housing["total_rooms"] 
housing["population_per_household"]=housing["population"]/housing["households"] 

corr_matrix = housing.corr()
corr_matrix["median_house_value"].sort_values(ascending=False) 

housing = strat_train_set.drop("median_house_value", axis=1) 
housing_labels = strat_train_set["median_house_value"].copy()

housing.dropna(subset=["total_bedrooms"])    # option 1 
housing.drop("total_bedrooms", axis=1)       # option 2 
median = housing["total_bedrooms"].median()  # option 3 
housing["total_bedrooms"].fillna(median, inplace=True)

from sklearn.impute import SimpleImputer
imputer = SimpleImputer(strategy="median") 

housing_num = housing.drop("ocean_proximity", axis=1)
imputer.fit(housing_num) 
X = imputer.transform(housing_num) 
housing_tr = pd.DataFrame(X, columns=housing_num.columns)

housing_cat = housing[["ocean_proximity"]] 
from sklearn.preprocessing import OrdinalEncoder
ordinal_encoder = OrdinalEncoder()
housing_cat_encoded = ordinal_encoder.fit_transform(housing_cat) 

from sklearn.preprocessing import OneHotEncoder 
cat_encoder = OneHotEncoder() 
housing_cat_1hot = cat_encoder.fit_transform(housing_cat) 

from sklearn.base import BaseEstimator, TransformerMixin
rooms_ix, bedrooms_ix, population_ix, households_ix = 3, 4, 5, 6

class CombinedAttributesAdder(BaseEstimator, TransformerMixin):
    def __init__(self, add_bedrooms_per_room = True): # no *args or **kargs
        self.add_bedrooms_per_room = add_bedrooms_per_room
    def fit(self, X, y=None):
        return self  # nothing else to do
    def transform(self, X, y=None):
        rooms_per_household = X[:, rooms_ix] / X[:, households_ix]
        population_per_household = X[:, population_ix] / X[:, households_ix]
        if self.add_bedrooms_per_room:
            bedrooms_per_room = X[:, bedrooms_ix] / X[:, rooms_ix]
            return np.c_[X, rooms_per_household, population_per_household,bedrooms_per_room]
        else:
            return np.c_[X, rooms_per_household, population_per_household]

attr_adder = CombinedAttributesAdder(add_bedrooms_per_room=False) 
housing_extra_attribs = attr_adder.transform(housing.values)


from sklearn.pipeline import Pipeline 
from sklearn.preprocessing import StandardScaler
num_pipeline = Pipeline([('imputer', SimpleImputer(strategy="median")),('attribs_adder', CombinedAttributesAdder()),('std_scaler', StandardScaler()),])
housing_num_tr = num_pipeline.fit_transform(housing_num)


from sklearn.compose import ColumnTransformer
num_attribs = list(housing_num) 
cat_attribs = ["ocean_proximity"]
full_pipeline = ColumnTransformer([
        ("num", num_pipeline, num_attribs),
        ("cat", OneHotEncoder(), cat_attribs),
    ])
housing_prepared = full_pipeline.fit_transform(housing)


from sklearn.linear_model import LinearRegression
lin_reg = LinearRegression() 
lin_reg.fit(housing_prepared, housing_labels)

some_data = housing.iloc[:5] 
some_labels = housing_labels.iloc[:5] 
some_data_prepared = full_pipeline.transform(some_data) 
print("Predictions:", lin_reg.predict(some_data_prepared)) 
print("Labels:", list(some_labels))

from sklearn.metrics import mean_squared_error
housing_predictions = lin_reg.predict(housing_prepared) 
lin_mse = mean_squared_error(housing_labels, housing_predictions) 
lin_rmse = np.sqrt(lin_mse) 

from sklearn.tree import DecisionTreeRegressor
tree_reg = DecisionTreeRegressor() 
tree_reg.fit(housing_prepared, housing_labels) 

housing_predictions = tree_reg.predict(housing_prepared) 
tree_mse = mean_squared_error(housing_labels, housing_predictions) 
tree_rmse = np.sqrt(tree_mse) 
print(tree_rmse)

from sklearn.model_selection import cross_val_score 
scores = cross_val_score(tree_reg, housing_prepared, housing_labels,
                         scoring="neg_mean_squared_error", cv=10) 
tree_rmse_scores = np.sqrt(-scores)

def display_scores(scores): 
     print("Scores:", scores) 
     print("Mean:", scores.mean()) 
     print("Standard deviation:", scores.std()) 

display_scores(tree_rmse_scores)

lin_scores = cross_val_score(lin_reg, housing_prepared, housing_labels,
                              scoring="neg_mean_squared_error", cv=10) 
lin_rmse_scores = np.sqrt(-lin_scores) 
display_scores(lin_rmse_scores)


from sklearn.ensemble import RandomForestRegressor 
forest_reg = RandomForestRegressor() 
forest_reg.fit(housing_prepared, housing_labels) 

housing_predictions = forest_reg.predict(housing_prepared) 
forest_mse = mean_squared_error(housing_labels, housing_predictions) 
forest_rmse = np.sqrt(forest_mse)
print(forest_rmse) 
scores = cross_val_score(forest_reg, housing_prepared, housing_labels,
                         scoring="neg_mean_squared_error", cv=10) 
forest_rmse_scores = np.sqrt(-scores)
display_scores(forest_rmse_scores) 



from sklearn.model_selection import GridSearchCV
param_grid = [
    {'n_estimators': [3, 10, 30], 'max_features': [2, 4, 6, 8]},
    {'bootstrap': [False], 'n_estimators': [3, 10], 'max_features': [2, 3, 4]},
  ]
forest_reg = RandomForestRegressor()
grid_search = GridSearchCV(forest_reg, param_grid, cv=5,                           scoring='neg_mean_squared_error',
                           return_train_score=True)
grid_search.fit(housing_prepared, housing_labels)

print(grid_search.best_params_)
print(grid_search.best_estimator_)