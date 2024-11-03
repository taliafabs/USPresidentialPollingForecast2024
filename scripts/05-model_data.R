#### Preamble ####
# Purpose: Models the
# Author: Talia Fabregas, Aliza Mithwani, Fatimah Yunusa
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites:Run 01-download_data.R and 03-clean_data.R
# Any other information needed? Data was downloaded and saved from FiveThirtyEight on October 29, 2024


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(broom)
library(modelsummary)
library(arrow)

#### Read data ####
harris <- read_parquet("data/02-analysis_data/harris-analysis_data.parquet")
trump <- read_parquet("data/02-analysis_data/trump-analysis_data.parquet")

#### Build models ####

# Bayesian model for pct_harris using spline and state and pollster as fixed effects
harris_spline_model <- stan_glm(
  pct_harris ~ ns(end_date_num, df = 5) + state + pollster + pollscore,
  data=harris,
  family = gaussian(),
  prior = normal(0, 5),
  prior_intercept = normal(50, 10),
  seed = 304,
  iter = 2000,
  chains = 4,
  refresh = 0
)

# Bayesian model for pct_trump using spline and state and pollster as fixed effects
trump_spline_model <- stan_glm(
  pct_trump ~ ns(end_date_num, df = 5) + state + pollster + pollscore, # Change df for the number of "bits" - higher numbers - more "wiggly" - but then need to worry about overfitting.
  data = trump,
  family = gaussian(),
  prior = normal(0, 5),
  prior_intercept = normal(50, 10),
  seed = 304,
  iter = 2000,
  chains = 4,
  refresh = 0
)

#### Save model ####
saveRDS(
  harris_spline_model,
  file = "models/harris_model.rds"
)

saveRDS(
  trump_spline_model,
  file = "models/trump_model.rds"
)
