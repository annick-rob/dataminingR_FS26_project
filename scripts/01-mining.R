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

#Generating a Loop to get all Women form every country and generating directly a country variable
# but only for the last parlamentary term (10)

#(Promts 3-5 ChatGPT)

all_women <- list()

countries <- c(
  "BE","BG","CZ","DK","DE","EE","IE","EL","ES","FR","HR","IT",
  "CY","LV","LT","LU","HU","MT","NL","AT","PL","PT","RO","SI",
  "SK","FI","SE"
)

for (country in countries) {
  
  url <- paste0(
    "https://data.europarl.europa.eu/api/v2/meps?",
    "parliamentary-term=10",
    "&gender=FEMALE",
    "&country-of-representation=", country,
    "&limit=500"
  )
  
  response <- GET(
    url,
    add_headers(
      "User-Agent" = "mep-project-research-4.5.0",
      "Accept" = "application/ld+json"
    )
  )
  
  cat("Country:", country, "- Status:", status_code(response), "\n")
  
  if (status_code(response) != 200) next
  
  txt <- content(response, as = "text", encoding = "UTF-8")
  
  if (nchar(txt) == 0) next
  
  parsed <- tryCatch(
    fromJSON(txt, flatten = TRUE),
    error = function(e) NULL
  )
  
  if (is.null(parsed)) next
  if (is.null(parsed$data)) next
  if (length(parsed$data) == 0) next
  
  df <- as.data.frame(parsed$data)
  
  if (nrow(df) == 0) next
  
  df$country <- country
  df$gender <- "FEMALE"
  df$parliamentary_term <- 10
  
  all_women[[country]] <- df
}

#checking the new row for women 
women_df <- bind_rows(all_women)
glimpse(women_df)
write_csv(women_df, "data_raw/meps_women_term10_by_country.csv")




