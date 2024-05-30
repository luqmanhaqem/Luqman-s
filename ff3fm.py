# Import packages
import pandas as pd
import numpy as np
import statsmodels.api as sm

# Import csv file
df = pd.read_csv("C:/Users/Admin/OneDrive - The University of Auckland/Year 3/FINANCE361\Assignment 1/Assignment_dataset.csv")

# Drop missing values
df.dropna(inplace=True)

# Choose stock
stocks = df[['MSFT', 'AAPL', 'ORCL']]

# Demean the stocks
demean_return = stocks.subtract(stocks.mean())

# Transpose demeaned_return
demean_return_transpose = np.transpose(demean_return)

# Calculate VCV Matrix
sigma = (demean_return_transpose @ demean_return)/288
sigma_inverse = np.linalg.inv(sigma)
sigma_inverse

# Calculate stock excess return
excess_stocks_return = stocks.subtract(df.RF, axis='index')
mu = excess_stocks_return.mean()

# Markowitz optimal portfolio weight
sigma_inverse_mu = sigma_inverse @ mu
ones = np.ones((3, 1))
sum_sigma_inverse_mu = sigma_inverse_mu @ ones
w = sigma_inverse_mu/sum_sigma_inverse_mu
w_transpose = np.transpose(w)
portfolio_excess_return = excess_stocks_return @ w

# Setting up our factors
X = df[['MktRF', 'SMB', 'HML']]
xvars = sm.add_constant(X)

# Run Fama French 3 factors model
model = sm.OLS (portfolio_excess_return, xvars).fit()
print(model.summary())

