library(dplyr)
library(tidyverse)
library(readr)

meps_terms_8_10 <- read_csv("01-data_raw/meps_terms_8_10.csv")
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

#speeches
speech_counts_terms_9_10 <- read_csv("01-data_raw/speech_counts_terms_9_10.csv")
View(speech_counts_terms_9_10)

#save df
write_csv(
  speech_counts_terms_9_10,
  "02-data_preprocessed/speeches_preprocessed.csv")


#add speeches per MEP 
meps_productivity <- meps_preprocessed |> 
  left_join(
    speech_counts_df,
    by = c("identifier", "parliamentary_term")
  )
View(meps_productivity1)

