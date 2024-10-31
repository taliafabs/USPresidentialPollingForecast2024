#### Preamble ####
# Purpose: Simulates a dataset that contains
# Author: Talia Fabregas, Aliza Mithwani, Fatimah Yunusa
# Date: 31 October 2024
# Contact: talia.fabregas@mail.utoronto.ca
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
  # this makes support for Harris interact with the state. 
  # higher in states like Minnesota, Virginia, and New Hampshire
  # lower in Texas, Florida, Montana, Missouri
  # in the case where only trump and harris are considered, close to 50 in the
  # seven battleground states
  harris_pct = case_when(
   state == "National" ~ rnorm(1, mean=50, sd=2.5),
   state == "Michigan" ~ rnorm(1, mean=50, sd=2.5),
   state == "Wisconsin" ~ rnorm(1, mean=50, sd=2.5),
   state == "Pennsylvania" ~ rnorm(1, mean=50, sd=2.5),
   state == "Arizona" ~ rnorm(1, mean=50, sd=2.5),
   state == "Nevada" ~ rnorm(1, mean=50, sd=2.5),   
   state == "Georgia" ~ rnorm(1, mean=50, sd=2.5),
   state == "North Carolina" ~ rnorm(1, mean=50, sd=2.5),
   state == "Florida" ~ rnorm(1, mean=43, sd=2.5),
   state == "Texas" ~ rnorm(1, mean=45, sd=2.5),
   state == "Nebraska" ~ rnorm(1, mean=0.38, sd=2.5),
   state == "Nebraska CD-2" ~ rnorm(1, mean=0.53, sd=2.5),
   state == "New Hampshire" ~ rnorm(1, mean=0.54, sd=2.5),
   state == "Virgninia" ~ rnorm(1, mean=0.54, sd=2.5),
   state == "Minnesota" ~ rnorm(1, mean=0.53, sd=2.5),
   state == "Missouri" ~ rnorm(1, mean=0.41, sd=2.5)
  ),
  trump_pct = 100-harris_pct
)

#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
write_parquet(simulated_data, "data/00-simulated_data/simulated_data.parquet")
