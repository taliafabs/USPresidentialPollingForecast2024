#### Preamble ####
# Purpose: Cleans the raw presidential polling data obtained from FiveThirtyEight
# Author: Talia Fabregas, Aliza Mithwani, Fatimah Yunusa
# Date: 28 October 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - The president_polls data must be downloaded and saved as a parquet to data/raw_data
# - The `tidyverse`, `janitor`, and `arrow` packages must be installed and loaded
# - 02-download_data.R must have been run
# Any other information needed? We downloaded our president_polls data from FiveThirtyEight on
# October 29, 2024

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(haven)
library(arrow)

#### Clean data ####
raw_data <- 
  read_parquet("data/01-raw_data/raw_president_polls.parquet") |>
  clean_names() |>
  filter(!is.na(numeric_grade) & !is.na(pollscore))
  
cleaned_data <-
  raw_data |>
  mutate(
    state = if_else(is.na(state), "National", state),
    end_date = mdy(end_date),
    # end_date_num = as.numeric(end_date - min(end_date)),
    num = round((pct/100) * sample_size, 0),
    is_national = if_else(state=="National", 1, 0)
    ) |>
  filter(
    (party== "DEM" | party == "REP"), 
    numeric_grade >= 3.0,
    end_date >= as.Date("2024-05-05"),
    (population == "lv"),
    !is.na(pct),
    !is.na(pollscore)
  ) |>
  select(poll_id, pollster, numeric_grade, pollscore, methodology, state, end_date, population, party, candidate_name, pct, is_national)

harris <- 
  cleaned_data |>
  filter(candidate_name == "Kamala Harris", 
         end_date >= as.Date("2024-07-21")) |>
  mutate(
      num_harris = round((pct / 100) * sample_size, 0), # Need number not percent for some models
      pct_harris = pct,
      end_date_num = as.numeric(end_date - as.Date("2024-07-21"))
  ) |>
  select(poll_id, pollster, numeric_grade, pollscore, methodology, state, end_date, population, num_harris, pct_harris, end_date_num)

trump <- 
  cleaned_data |>
  filter(candidate_name == "Donald Trump", end_date >= as.Date("2024-07-21")) |>
  mutate(
    num_trump = round((pct / 100) * sample_size, 0), # Need number not percent for some models
    pct_trump = pct,
    end_date_num = as.numeric(end_date - as.Date("2024-07-21"))
  ) |>
  select(poll_id, pollster, numeric_grade, pollscore, methodology, state, end_date, population, num_trump, pct_trump, end_date_num)
  


#### Save data ####
write_parquet(cleaned_data, "data/02-analysis_data/analysis_data.parquet")
# write_parquet(model_data, "data/02-analysis_data/model_data.parquet")
write_parquet(harris, "data/02-analysis_data/harris-analysis_data.parquet")
write_parquet(trump, "data/02-analysis_data/trump-analysis_data.parquet")
