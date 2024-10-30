#### Preamble ####
# Purpose: Cleans the raw presidential polling data obtained from 538
# Author: Talia Fabregas, Aliza Mithwani, Fatimah Yunusa
# Date: 28 October 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites: Run 02-download_data.R first
# Any other information needed? 

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(haven)
library(arrow)

#### Clean data ####
raw_data <- read_parquet("data/01-raw_data/raw_president_polls.parquet") |>
  clean_names() 
  
cleaned_data <-
  raw_data |>
  filter((candidate_name == "Kamala Harris" |
           # candidate_name == "Joe Biden" |
             candidate_name == "Donald Trump"), numeric_grade >= 2.7) |>
  mutate(
    state = if_else(is.na(state), "National", state),
    end_date = mdy(end_date),
    num = round((pct/100) * sample_size, 0)
    ) |>
  filter(end_date >= as.Date("2024-07-21"))


#### Save data ####
write_parquet(cleaned_data, "data/02-analysis_data/presidential_polls_analysis_data.parquet")
