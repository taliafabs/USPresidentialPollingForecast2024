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
# analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")
harris <- read_parquet("data/02-analysis_data/harris-analysis_data.parquet")
trump <- read_parquet("data/02-analysis_data/trump-analysis_data.parquet")

harris_spline_model <- stan_glm(
  pct_harris ~ ns(end_date_num, df = 5) + state + pollster, # Change df for the number of "bits" - higher numbers - more "wiggly" - but then need to worry about overfitting.
  data = harris,
  family = gaussian(),
  prior = normal(0, 5),
  prior_intercept = normal(50, 10),
  seed = 304,
  iter = 2000,
  chains = 4,
  refresh = 0
)

trump_spline_model <- stan_glm(
  pct_trump ~ ns(end_date_num, df = 5) + state + pollster, # Change df for the number of "bits" - higher numbers - more "wiggly" - but then need to worry about overfitting.
  data = trump,
  family = gaussian(),
  prior = normal(0, 5),
  prior_intercept = normal(50, 10),
  seed = 304,
  iter = 2000,
  chains = 4,
  refresh = 0
)
# model_data <- read_parquet("data/02-analysis_data/model_data.parquet")

# model_data |>
#   mutate(
#   pollster = as.factor(pollster),
#   state = as.factor(state),
# )

### Model data ####
# first_model <-
#   stan_glm(
#     formula = flying_time ~ length + width,
#     data = analysis_data,
#     family = gaussian(),
#     prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
#     prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
#     prior_aux = exponential(rate = 1, autoscale = TRUE),
#     seed = 853
#   )

# harris |>
#   mutate(
#     pollster = factor(pollster),
#     state = factor(state)
#   )
# 
# trump |>
#   mutate(
#     pollster = factor(pollster),
#     state = factor(state)
#   )

# end_date_num is the number of days since July 21, when Biden dropped out and endorsed Harris
# harris_model <- lm(harris_avg_pct ~ end_date_num + pollster + state + sample_size, data=harris)
# trump_model <- lm(trump_avg_pct ~ end_date_num + pollster + state + sample_size, data=trump)

# priors <- normal(0, 2.5, autoscale = TRUE)
# 
# model_formula <- harris_won_poll ~ end_date_num + (1 | state) + (1 | pollster)
# 
# bayesian_model <- stan_glmer(
#   formula = model_formula,
#   data = model_data,
#   family = binomial(link = "logit"),
#   prior = priors,
#   prior_intercept = priors,
#   seed = 123,
#   cores = 4,
#   adapt_delta = 0.95
# )

#### Save model ####
saveRDS(
  harris_spline_model,
  file = "models/harris_model.rds"
)

saveRDS(
  trump_spline_model,
  file = "models/trump_model.rds"
)

# saveRDS(
#   bayesian_model,
#   file = "models/bayesian_model.rds"
# )

# saveRDS(
#   harris_model,
#   file = "models/harris_model.rds"
# )
# 
# saveRDS(
#   trump_model,
#   file = "models/harris_model.rds"
# )

