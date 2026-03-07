#Getting started
library(tidyverse)
library(httr)
library(jsonlite)

#defining the url for the informations about the Members of the Parliment 
url <- "https://data.europarl.europa.eu/api/v2/meps?limit=50" 

#user-Agent 
response <- GET(
  url,
  add_headers(
    "User-Agent" = "mep-project-research-1.0",
    "Accept" = "application/ld+json"
  )
)


# Check if this works 
status_code(response)

#saving what i recieved as text
data <- content(response, as = "text", encoding = "UTF-8")

#Putting the JSON in R
data_json <- fromJSON(data, flatten = TRUE)


