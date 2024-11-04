#### Preamble ####
# Purpose: Simulates a dataset that contains
# Author: Talia Fabregas, Aliza Mithwani, Fatimah Yunusa
# Date: 31 October 2024
# Contact: talia.fabregas@mail.utoronto.ca, fatimah.yunusa@mail.utoronto.ca, aliza.mithwani@mail.utoronto.ca 
# License: MIT
# Pre-requisites: The `tidyverse` and `arrow` packages must be installed
# Any other information needed? Make sure you are in the `USPresidentialPollingForecast2024` rproj


#### Workspace setup ####
library(tidyverse)
library(arrow)
set.seed(538)
num_simulated_polls <- 1000

# simulate a relationship with interaction between state and support for Harris and Trump

#### Simulate data ####
# State names
states <- c(
  "National",
  "Pennsylvania",
  "Texas",
  "Nebraska",
  "Nebraska CD-2",
  "Florida",
  "Georgia",
  "Michigan",
  "Minnesota",
  "Nevada",
  "New Hampshire",
  "North Carolina",
  "Virginia",
  "Wisconsin",
  "Montana",
  "Missouri"
  )

# Pollsters
pollsters <- c("YouGov", "Siena/NYT", "CES / YouGov", "Marquette Law School", 
               "The Washington Post", "McCourtney Institute/YouGov")

# Political parties
nominees <- c("Kamala Harris", "Donald Trump")
dates <- seq(as.Date("2024-07-21"), as.Date("2024-10-29"), by = "day")

# numeric grade for polls
numeric_grades <- c(0.5, 0.6, 0.7, 0.9, 1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 
                   1.8, 1.9, 2, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 3)

# sample sizes for polls
sample_size <- round(rnorm(1, mean = 1700, sd = 500))
sample_size <- pmax(500, pmin(sample_size, 10000))

#### Simulate the Data ####
simulated_data <- tibble(
  poll_id = 1:num_simulated_polls,
  state = sample(
    states,
    size = num_simulated_polls,
    replace = TRUE,
    # make it sample National polls and the states at a similar rate to the polling data
    # competitiveness and number of electoral votes make a staet more likely to be sampled
    prob = c(0.45, 0.21, 0.06, 0.02, 0.04, 0.05, 0.1, 0.15, 0.01, 0.05, 0.01, 
             0.075, 0.004, 0.19, 0.001, 0.001)
    ),
  pollster = sample(pollsters, num_simulated_polls, replace = TRUE),
  sample_size = sample_size,
  # this makes support for Harris interact with the state. 
  # higher in states like Minnesota, Virginia, and New Hampshire
  # lower in Texas, Florida, Montana, Missouri
  # in the case where only trump and harris are considered, close to 50 in the
  # seven battleground states
  harris_pct = case_when(
    state == "National" ~ pmax(0, pmin(rnorm(1, mean = 50, sd = 2.5), 100)),
    state == "Michigan" ~ pmax(0, pmin(rnorm(1, mean = 50, sd = 2.5), 100)),
    state == "Wisconsin" ~ pmax(0, pmin(rnorm(1, mean = 50, sd = 2.5), 100)),
    state == "Pennsylvania" ~ pmax(0, pmin(rnorm(1, mean = 50, sd = 2.5), 100)),
    state == "Arizona" ~ pmax(0, pmin(rnorm(1, mean = 50, sd = 2.5), 100)),
    state == "Nevada" ~ pmax(0, pmin(rnorm(1, mean = 50, sd = 2.5), 100)),
    state == "Georgia" ~ pmax(0, pmin(rnorm(1, mean = 50, sd = 2.5), 100)),
    state == "North Carolina" ~ pmax(0, pmin(rnorm(1, mean = 50, sd = 2.5), 100)),
    state == "Florida" ~ pmax(0, pmin(rnorm(1, mean = 44, sd = 2.5), 100)),
    state == "Texas" ~ pmax(0, pmin(rnorm(1, mean = 45, sd = 2.5), 100)),
    state == "Nebraska" ~ pmax(0, pmin(rnorm(1, mean = 38, sd = 2.5), 100)),
    state == "Nebraska CD-2" ~ pmax(0, pmin(rnorm(1, mean = 53, sd = 2.5), 100)),
    state == "New Hampshire" ~ pmax(0, pmin(rnorm(1, mean = 54, sd = 2.5), 100)),
    state == "Virginia" ~ pmax(0, pmin(rnorm(1, mean = 54, sd = 2.5), 100)),
    state == "Minnesota" ~ pmax(0, pmin(rnorm(1, mean = 53, sd = 2.5), 100)),
    state == "Missouri" ~ pmax(0, pmin(rnorm(1, mean = 41, sd = 2.5), 100))
  ),
  trump_pct = 100-harris_pct
)

#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
write_parquet(simulated_data, "data/00-simulated_data/simulated_data.parquet")
