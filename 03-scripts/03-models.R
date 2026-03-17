library(readr)
library(dplyr)

meps_productivity <- read_csv("02-data_preprocessed/meps_productivity.csv")

#regression Model 
model <- lm(
  productivity ~ gender + political_group + country + term,
  data = meps_productivity
)

summary(model)

#fe country and party
model_fe <- lm(
  productivity ~ gender + term + factor(political_group) + factor(country),
  data = meps_productivity
)

summary(model_fe)

