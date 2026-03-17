library(dplyr)
library(tidyverse)
library(readr)

meps_terms_8_10 <- read_csv("01-data_raw/meps_terms_8_10.csv")
View(meps_terms_8_10)

#delete the variables I don't need for the analysis
meps_preprocessed <- meps_terms_8_10 |> 
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
  "02-data_preprocessed/meps_preprocessed.csv")

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
    speech_counts_terms_9_10,
    by = c("identifier", "parliamentary_term")
  )
View(meps_productivity)

#save df
write_csv(
  meps_productivity,
  "02-data_preprocessed/meps_productivity.csv")

#recode gender
table(meps_productivity$gender)
meps_productivity <- meps_productivity |> 
  mutate(gender = ifelse(gender == "MALE", 1, 0))

#check result
table(meps_productivity$gender)

#dependent variable
meps_productivity$productivity <- meps_productivity$speeches

#term variable
meps_productivity$term <- meps_productivity$parliamentary_term

#categorical variables
meps_productivity$political_group <- as.factor(meps_productivity$political_group)
meps_productivity$country <- as.factor(meps_productivity$country)

#save dataframe
write_csv(
  meps_productivity,
  "02-data_preprocessed/meps_productivity.csv"
)




