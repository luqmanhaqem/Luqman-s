# install required packages
install.packages("tidyverse")
library(tidyverse)
library(stats)
install.packages("car")
library(car)

# Import data
df <- read.csv("C:/Users/Admin/OneDrive - The University of Auckland/Year 3/FINANCE361/Assignment 1/Assignment_dataset.csv")
view(df)

# Drop missing values
df <- na.omit(df)

# Choose the stocks
stocks <- df %>% 
  select(MSFT, AAPL, ORCL)
View(stocks)

# Demean the stocks
demean_return <- sweep(stocks, 2, colMeans(stocks), "-")
View(demean_return)

# Transpose the demean_return
demean_return_trans <- t(demean_return)
View(demean_return_trans)

# Convert columns into dataframe
demean_return <- as.matrix(demean_return)
demean_return_trans <- as.matrix(demean_return_trans)

# Calculate VCV Matrix
sigma <- (demean_return_trans %*% demean_return)/288
View(sigma)
sigma_inv <- solve(sigma)


# Calculate stock excess return
excess_stocks_return <- sweep(stocks, 1, df$RF[1:nrow(stocks)], "-")
print(excess_stocks_return)
mu <- colMeans(excess_stocks_return)
View(mu)
mu <- as.matrix(mu)
excess_stocks_return <- as.matrix(excess_stocks_return)

# Calculate markowitz portfolio weight
sigma_inv_mu <- sigma_inv %*% mu
ones <- c(1,1,1)
sum_sigma_inv_mu <- ones %*% sigma_inv_mu
w <- sigma_inv_mu %*% (1/sum_sigma_inv_mu)
w

# Calculate Portfolio Return
portfolio_excess_resturn <- excess_stocks_return %*% w
portfolio_excess_resturn

# Select the FF3 factors
ff3factors <- df %>% 
  select(MktRF, SMB, HML)

# Merge Y and X
vars <- cbind(portfolio_excess_resturn, ff3factors)
View(vars)

# Run OLS
model <- lm(portfolio_excess_resturn ~ MktRF + SMB + HML, vars)
summary(model)
