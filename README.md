# Data Mining Project Template

This repository contains the code for a small data mining project developed as part of the course:

**Data Access and Data Mining for Social Sciences**

University of Lucerne

Annick Robatel
Course: Data Mining for the Social Sciences using R
Term: Spring 2026

## Project Goal

The goal of this project is to collect and analyze data from the European Parliament Open Data API in order to study patterns in parliamentary activity among Members of the European Parliament (MEPs).

The project demonstrates:
- Identification of a suitable online data source
- Automated data collection via an API
- Use of loops to retrieve structured political data
- Data cleaning and preparation in R
- Reproducible research workflow
- Reproducible analysis


## Research Question

What factors explain variation in the parliamentary productivity of Members of the European Parliament?

Parliamentary productivity is defined as the number of parliamentary interventions by a Member of the European Parliament, measured through:

- number of plenary speeches
- number of parliamentary questions
- number of reports authored

These indicators capture how actively an MEP participates in legislative work.

## Data Source

The project uses the European Parliament Open Data API.

API Base URL: https://data.europarl.europa.eu/api/v2

Documentation: https://data.europarl.europa.eu/en/developer-corner/opendata-api

The API provides structured information on:
- Members of the European Parliament (MEPs)
- parliamentary terms
- gender
- country of representation
- political group affiliation

Data are retrieved using HTTP GET requests via the R package httr.


## Data Collection Strategy
Data are collected programmatically using loops in R.

The scripts retrieve information on MEPs for parliamentary terms 8–10, corresponding approximately to:
Term 8:	2014–2019
Term 9:	2019–2024
Term 10:	2024–present

Separate API queries are used to retrieve MEPs by:
- gender (female / male)
- country of representation
- political group

Because some API responses only return the filtered MEP information, variables such as gender, country, parliamentary term, and political group are added explicitly to the resulting datasets after each API request.
The retrieved datasets are then combined into larger data frames using bind_rows().

## Project Workflow

The project follows these steps:
- Query the EP Open Data API for MEP and productivity information
- Retrieve data across multiple parliamentary terms
- Combine data across countries and political groups
- Clean and structure the dataset
- Prepare the data for subsequent analysis of parliamentary productivity


## Reproducibility

To reproduce this project:

1. Clone the repository
2. Install required R packages
3. Run the scripts in the `scripts/` folder
All data should be generated automatically by the scripts.



