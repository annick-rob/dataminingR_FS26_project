#Getting started
library(tidyverse)
library(httr)
library(jsonlite)
library(readr)

################
#very first try
################
# using the current parliamentary-term taking all MEPS
#defining the url for the informations about the Members of the Parliment (directly fromm the Website)
url <- "https://data.europarl.europa.eu/api/v2/meps?parliamentary-term=10&political-group=&country-of-representation=&format=application%2Fld%2Bjson&offset=0&limit=500" 

#user-Agent (Promt1 ChatGPT)
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

#Putting the JSON in R (Promt2 ChatGPT)
data_json <- fromJSON(data, flatten = TRUE)

#getting a df 
meps_df <- as.data.frame(data_json$data)
glimpse(meps_df)

#save as csv in data_raw 
write_csv(meps_df, "data_raw/meps_raw.csv")


################
#second try
################
#get data for df of women from parlamentary term 10 ----
#Generating a Loop to get all Women form every country and generating directly a country variable
#but only for the last parlamentary term (10)

#(Promts 4-9 ChatGPT)

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

################
#next try
################
#df for Women all parlamentary terms ---- (Promt 9 ChatGPT)
#Generating a Loop to get all Women form every country and generating directly a country variable
for (country in countries) {
  
  url <- paste0(
    "https://data.europarl.europa.eu/api/v2/meps?",
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
  all_women[[country]] <- df
}
women_df <- bind_rows(all_women)
glimpse(women_df)
write_csv(women_df, "data_raw/meps_women_allterms_by_country.csv")

################
#third try
################
#trying to get the political group as well in my loop (Promt10-14  ChatGPT)----
countries <- c(
  "BE","BG","CZ","DK","DE","EE","IE","EL","ES","FR","HR","IT",
  "CY","LV","LT","LU","HU","MT","NL","AT","PL","PT","RO","SI",
  "SK","FI","SE"
)

groups <- c(
  "EPP", "S&D", "PfE", "ECR", "Renew", "Greens/EFA", "The Left", "ESN", "NI"
)

all_women <- list()

for (country in countries) {
  for (group in groups) {
    
    url <- paste0(
      "https://data.europarl.europa.eu/api/v2/meps?",
      "parliamentary-term=10",
      "&gender=FEMALE",
      "&country-of-representation=", URLencode(country, reserved = TRUE),
      "&political-group=", URLencode(group, reserved = TRUE),
      "&limit=500"
    )
    
    response <- GET(
      url,
      add_headers(
        "User-Agent" = "mep-project-research-4.5.0",
        "Accept" = "application/ld+json"
      )
    )
    
    if (status_code(response) != 200) next
    
    txt <- content(response, as = "text", encoding = "UTF-8")
    if (nchar(txt) == 0) next
    
    parsed <- tryCatch(
      fromJSON(txt, flatten = TRUE),
      error = function(e) NULL
    )
    
    if (is.null(parsed) || is.null(parsed$data) || length(parsed$data) == 0) next
    
    df <- as.data.frame(parsed$data)
    if (nrow(df) == 0) next
    
    df$country <- country
    df$political_group <- group
    df$gender <- "FEMALE"
    df$parliamentary_term <- 10
    
    all_women[[paste(country, group, sep = "_")]] <- df
  }
}

women_df <- bind_rows(all_women)

glimpse(women_df)
write_csv(women_df, "data_raw/meps_women_term10_country_group.csv")


################
#next try
################
#women terms 8-10 and ploitical group---- (Promt14-18  ChatGPT)

terms <- 8:10

groups <- c(
  "PPE",
  "NI",
  "S-D",
  "VERTS-ALE",
  "ECR",
  "RENEW",
  "THE-LEFT",
  "ID"
)

all_women <- list()

for (term in terms) {
  for (group in groups) {
    
    url <- paste0(
      "https://data.europarl.europa.eu/api/v2/meps?",
      "parliamentary-term=", term,
      "&gender=FEMALE",
      "&political-group=", URLencode(group),
      "&limit=500"
    )
    
    response <- GET(
      url,
      add_headers(
        "User-Agent" = "mep-project-research-4.5.0",
        "Accept" = "application/ld+json"
      )
    )
    
    cat("term:", term,
        "| group:", group,
        "| status:", status_code(response), "\n")
    
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
    
    df$political_group <- group
    df$gender <- "FEMALE"
    df$parliamentary_term <- term
    
    all_women[[paste(term, group, sep = "_")]] <- df
    
    Sys.sleep(0.2)
  }
}

women_by_group <- bind_rows(all_women)

glimpse(women_by_group)

write_csv(women_by_group, "data_raw/meps_women_terms_8_10_by_group.csv")


################
#final try for women
################
#final request for women ---- (Promt 19-23  ChatGPT)
terms <- 8:10

countries <- c(
  "BE","BG","CZ","DK","DE","EE","IE","EL","ES","FR","HR","IT",
  "CY","LV","LT","LU","HU","MT","NL","AT","PL","PT","RO","SI",
  "SK","FI","SE", "UK"
)


groups <- c(
  "PPE",
  "NI",
  "S-D",
  "VERTS-ALE",
  "ECR",
  "RENEW",
  "THE-LEFT",
  "ID"
)

all_women <- list()

for (term in terms) {
  for (country in countries) {
    for (group in groups) {
      
      url <- paste0(
        "https://data.europarl.europa.eu/api/v2/meps?",
        "parliamentary-term=", term,
        "&gender=FEMALE",
        "&country-of-representation=", URLencode(country, reserved = TRUE),
        "&political-group=", URLencode(group, reserved = TRUE),
        "&limit=500"
      )
      
      response <- GET(
        url,
        add_headers(
          "User-Agent" = "mep-project-research-4.5.0",
          "Accept" = "application/ld+json"
        )
      )
      
      cat("term:", term,
          "| country:", country,
          "| group:", group,
          "| status:", status_code(response), "\n")
      
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
      df$political_group <- group
      df$gender <- "FEMALE"
      df$parliamentary_term <- term
      
      all_women[[paste(term, country, group, sep = "_")]] <- df
      
      Sys.sleep(0.2)
    }
  }
}


women_df <- bind_rows(all_women)
glimpse(women_df)
write_csv(women_df, "data_raw/meps_women_terms_8_10_country_group.csv")


################
#final try for men
################
# request for men ---- (Promt 24  ChatGPT)

terms <- 8:10

countries <- c(
  "BE","BG","CZ","DK","DE","EE","IE","EL","ES","FR","HR","IT",
  "CY","LV","LT","LU","HU","MT","NL","AT","PL","PT","RO","SI",
  "SK","FI","SE", "UK"
)


groups <- c(
  "PPE",
  "NI",
  "S-D",
  "VERTS-ALE",
  "ECR",
  "RENEW",
  "THE-LEFT",
  "ID"
)

all_men <- list()

for (term in terms) {
  for (country in countries) {
    for (group in groups) {
      
      url <- paste0(
        "https://data.europarl.europa.eu/api/v2/meps?",
        "parliamentary-term=", term,
        "&gender=MALE",
        "&country-of-representation=", URLencode(country, reserved = TRUE),
        "&political-group=", URLencode(group, reserved = TRUE),
        "&limit=500"
      )
      
      response <- tryCatch(
        GET(
          url,
          add_headers(
            "User-Agent" = "mep-project-research-4.5.0",
            "Accept" = "application/ld+json"
          ),
          timeout(60)
        ),
        error = function(e) {
          cat("Request failed:",
              "term =", term,
              "| country =", country,
              "| group =", group, "\n")
          return(NULL)
        }
      )
      
      if (is.null(response)) next
      
      cat("term:", term,
          "| country:", country,
          "| group:", group,
          "| status:", status_code(response), "\n")
      
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
      df$political_group <- group
      df$gender <- "MALE"
      df$parliamentary_term <- term
      
      all_men[[paste(term, country, group, sep = "_")]] <- df
      
      Sys.sleep(0.5)
    }
  }
}

men_df <- bind_rows(all_men)
glimpse(men_df)
write_csv(men_df, "data_raw/meps_men_terms_8_10_country_group.csv")



