#### Preamble ####
# Purpose: Tests the structure and validity of the simulated U.S. presidential polling data
  #electoral divisions dataset.
# Author: Talia Fabregas, Aliza Mithwani, Fatimah Yunusa
# Date: 31 October 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` and `testthat` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? Make sure you are in the `USPresidentialPollingForecast2024` rproj


#### Workspace setup ####
library(tidyverse)
library(testthat)

simulated_data <- read_csv("data/00-simulated_data/simulated_data.csv")

# Test if the data was successfully loaded
if (exists("simulated_data")) {
  message("Test Passed: The simulated dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}


#### Test the simulated data ####

# Check if the dataset has 1000 rows
if (nrow(simulated_data) == 1000) {
  message("Test Passed: The simulated dataset has 1000 rows.")
} else {
  stop("Test Failed: The simulated dataset does not have 1000 rows.")
}

# Check if the dataset has 6 columns
if (ncol(simulated_data) == 6) {
  message("Test Passed: The dataset has 6 columns.")
} else {
  stop("Test Failed: The dataset does not have 6 columns.")
}

# Check if there are any missing values in the dataset
if (all(!is.na(simulated_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check that every poll has a unique poll_id
if (n_distinct(simulated_data$poll_id) == nrow(simulated_data)) {
  message("Test Passed: All poll_id values are unique.")
} else {
  stop("Test Failed: The 'poll_id' column contains duplicate values.")
}


# Check if the 'state' column contains only the names of competitive states that 
# were included in the polling data
included_states <- c(
  "National", "Pennsylvania", "Texas", "Nebraska", "Nebraska CD-2", "Florida", 
  "Georgia", "Michigan", "Minnesota", "Nevada", "New Hampshire", 
  "North Carolina", "Virginia", "Wisconsin", "Montana", "Missouri"
)

if (all(simulated_data$state %in% included_states)) {
  message("Test Passed: The 'state' column contains only states that were included in the polling data.")
} else {
  stop("Test Failed: The 'state' column contains state names that may be valid states, but were not included in the polling data")
}

# Check that every pollster included in the dataset is a valid pollster
valid_pollsters <- c("YouGov", "Siena/NYT", "CES / YouGov", "Marquette Law School", 
                     "The Washington Post", "McCourtney Institute/YouGov")
if (all(simulated_data$pollster %in% valid_pollsters)) {
  message("Test Passed: The 'pollster' column contains only valid pollsters.")
} else {
  stop("Test Failed: The 'pollster' column contains an unexpected pollster.")
}

# Check that every numeric_grade is a valid numeric grade as defined by ABC and 538
valid_numeric_grades <- c(0.5, 0.6, 0.7, 0.9, 1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 
                    1.8, 1.9, 2, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 3)
if (all(simulated_data$numeric_grade %in% valid_numeric_grades)) {
  message("Test Passed: The 'numeric_grade' column contains only valid values")
} else {
  stop("Test Failed: The 'numeric_grade' column contains an unexpected value")
}

# Check that the percentage of voters supporting Harris is always >= 0 and <= 100
if (all(simulated_data$harris_pct) >= 0.0 & all(simulated_data$harris_pct) <= 100.0) {
  message("Test Passed: The 'harris_pct' values are all between 0 and 100.")
} else {
  stop("Test Failed: The 'harris_pct' column contains at least one value <0 or >100.")
}

# Check that the percentage of voters supporting Trump is always >= 0 and <= 100
if (all(simulated_data$trump_pct) >= 0.0 & all(simulated_data$trump_pct) <= 100.0) {
  message("Test Passed: The 'trump_pct' values are all between 0 and 100.")
} else {
  stop("Test Failed: The 'trump_pct' column contains at least one value <0 or >100.")
}

# Check that the harris_pct + trump_pct adds up to 1 in every poll
# ChatGPT was used to debug this test
test_that("harris_pct and trump_pct sum to 100", {
  expect_equal(simulated_data$harris_pct + simulated_data$trump_pct, rep(100, num_simulated_polls), 
               tolerance = 0.01)  # Allow a small tolerance for floating point errors
})

