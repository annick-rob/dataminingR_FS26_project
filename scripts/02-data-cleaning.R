library(dplyr)
library(tidyverse)
library(readr)

meps_terms_8_10 <- read_csv("data_raw/meps_terms_8_10.csv")
View(meps_terms_8_10)

#delete the variables I don't need for the analysis
meps_preprocessed <- meps_df |> 
  select(
    identifier,
    givenName,
    familyName,
    country,
    political_group,
    gender,
    parliamentary_term
  )

#combine name
meps_preprocessed <- meps_preprocessed |> 
  mutate(name = paste(givenName, familyName))

#sort data
meps_preprocessed <- meps_preprocessed |> 
  select(
    identifier,
    name,
    country,
    political_group,
    gender,
    parliamentary_term
  )

#duplicates?
meps_preprocessed <- meps_preprocessed |> 
  distinct()

summary(meps_preprocessed)
View(meps_preprocessed)

#save df
write_csv(
  meps_preprocessed,
  "data_preprocessed/meps_preprocessed.csv")


