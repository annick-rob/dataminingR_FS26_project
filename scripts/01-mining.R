#Getting started
library(tidyverse)
library(httr)
library(jsonlite)

#defining the url for the informations about the Members of the Parliment (Promt 1 ChatGPT)
url <- "https://data.europarl.europa.eu/api/v2/meps?limit=50" 

#user-Agent (Promt 2 ChatGPT)
response <- GET(
  url,
  add_headers(
    "User-Agent" = "mep-project-research-1.0",
    "Accept" = "application/ld+json"
  )
)


# Check if this works -> 200
status_code(response)

#saving what i recieved as text
data <- content(response, as = "text", encoding = "UTF-8")

#Putting the JSON in R
data_json <- fromJSON(data, flatten = TRUE)

#getting a df 
meps_df <- as.data.frame(data_json$data)
glimpse(meps_df)

#save as csv in data_raw
write_csv(meps_df, "data_raw/meps_raw.csv")



