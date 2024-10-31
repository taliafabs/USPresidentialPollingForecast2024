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
    (population == "lv")
  ) |>
  select(poll_id, pollster_id, pollster, numeric_grade, pollscore, methodology, 
         transparency_score, state, end_date, sponsor_candidate_id, 
         sponsor_candidate_party, endorsed_candidate_id, endorsed_candidate_party,
         sample_size, population, internal, partisan, party, candidate_name, pct,
         num, is_national
         )

harris <- 
  cleaned_data |>
  filter(candidate_name == "Kamala Harris", 
         end_date >= as.Date("2024-07-21")) |>
  mutate(
      num_harris = round((pct / 100) * sample_size, 0), # Need number not percent for some models
      pct_harris = pct,
      end_date_num = (end_date - as.Date("2024-07-21"))
  )

trump <- 
  cleaned_data |>
  filter(candidate_name == "Donald Trump", end_date >= as.Date("2024-07-21")) |>
  mutate(
    num_trump = round((pct / 100) * sample_size, 0), # Need number not percent for some models
    pct_trump = pct,
    end_date_num = (end_date - as.Date("2024-07-21"))
  )
  

# # Subset the data to high-quality Harris and Trump polling estimates after she became presumptive DEM nominee
# harris <- 
#   cleaned_data |>
#   filter(candidate_name == "Kamala Harris", end_date >= as.Date("2024-07-21")) |>
#   mutate(
#     num_harris = round((pct / 100) * sample_size, 0), # Need number not percent for some models
#     pct_harris = pct
#   ) |>
#   group_by(poll_id, pollster_id, pollster, pollscore, transparency_score, end_date, 
#            end_date_num, state, endorsed_candidate_party, sponsor_candidate_party) |>
#   summarize(harris_avg_pct = mean(pct),
#             harris_total = sum(num))
# trump <- 
#   cleaned_data |>
#   filter(candidate_name == "Donald Trump", end_date >= as.Date("2024-07-21")) |>
#   mutate(
#     num_trump = round((pct / 100) * sample_size, 0), # Need number not percent for some models
#     pct_trump = pct
#   ) |>
#   group_by(poll_id, pollster_id, pollster, pollscore, transparency_score, end_date, 
#            end_date_num, state, endorsed_candidate_party, sponsor_candidate_party) |>
#   summarize(trump_avg_pct = mean(pct),
#          trump_total = sum(num))
# 
# 
# # specifically choose to only keep the trump_avg_pct and trump_total from trump
# # model data is derived from the analysis data; it just has the average support for Harris and Trump across each poll
# # to determine who won the poll
# model_data <- 
#   harris |>
#   left_join(
#     select(trump, trump_avg_pct, trump_total),  # Select only poll_id and avg_pct from trump
#     by = c("poll_id", "pollster_id", "pollster", "pollscore", "transparency_score", "end_date", 
#            "end_date_num", "state", "endorsed_candidate_party")
#   ) |>
#   mutate(
#     harris_won_poll = ifelse(harris_avg_pct > trump_avg_pct, 1, 0)
#   )

#### Save data ####
write_parquet(cleaned_data, "data/02-analysis_data/analysis_data.parquet")
# write_parquet(model_data, "data/02-analysis_data/model_data.parquet")
write_parquet(harris, "data/02-analysis_data/harris-analysis_data.parquet")
write_parquet(trump, "data/02-analysis_data/trump-analysis_data.parquet")
