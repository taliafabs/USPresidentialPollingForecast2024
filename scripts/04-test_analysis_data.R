#### Preamble ####
# Purpose: Tests the analysis data
# Author: Talia Fabregas, Aliza Mithwani, Fatimah Yunusa
# Date: 31 October 2024
# Contact: talia.fabregas@mail.utoronto.ca,fatimah.yunusa@mail.utoronto.ca, aliza.mithwani@mail.utoronto.ca 
# License: MIT
# Pre-requisites:
# - The `tidyverse`, `arrow` and `testthat` package must be installed and loaded
# - 02-download_data.R and 03-clean_data.R must have been run
# Any other information needed? No


#### Workspace setup ####
library(tidyverse)
library(testthat)
library(arrow)

analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")
harris_analysis_data <- read_parquet("data/02-analysis_data/harris-analysis_data.parquet")
trump_analysis_data <- read_parquet("data/02-analysis_data/trump-analysis_data.parquet")

#### Test data ####

# Test that the analysis dataset has 310 rows
test_that("analysis dataset has 310 rows", {
  expect_equal(nrow(analysis_data), 310)
})

# Test that the Harris analysis dataset and Trump analysis dataset both have 117 rows
test_that("harris dataset has 117 rows", {
  expect_equal(nrow(harris_analysis_data), 117)
})

test_that("trump dataset has 117 rows", {
  expect_equal(nrow(trump_analysis_data), 117)
})

# Test that the analysis dataset has 10 columns
test_that("analysis dataset has 10 columns", {
  expect_equal(ncol(analysis_data), 10)
})

# Test that the trump and harris analysis datasets have 9 columns each
test_that("Harris analysis dataset has 9 columns", {
  expect_equal(ncol(harris_analysis_data), 9)
})

test_that("Trump analysis dataset has 9 columns", {
  expect_equal(ncol(trump_analysis_data), 9)
})

# Test that the 'candidate_name' column is character type
test_that("'candidate_name' is character", {
  expect_type(analysis_data$candidate_name, "character")
})

test_that("'party' is character", {
  expect_type(analysis_data$party, "character")
})
