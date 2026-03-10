#Getting started
library(tidyverse)
library(httr)
library(jsonlite)

# using the current parliamentary-term taking all MEPS
#defining the url for the informations about the Members of the Parliment (directly fromm the Website)
url <- "https://data.europarl.europa.eu/api/v2/meps?parliamentary-term=10&political-group=&country-of-representation=&format=application%2Fld%2Bjson&offset=0&limit=500" 

#user-Agent (Promt 2 ChatGPT)
response <- GET(
  url,
  add_headers(
    "User-Agent" = "mep-project-research-4.5.0",
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



