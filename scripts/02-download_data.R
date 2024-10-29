#### Preamble ####
# Purpose: Downloads and saves the data from 538
# Author: Talia Fabregas, Fatimah Yunusa, Aliza Mitzwani
# Date: 24 October 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(janitor)
library(arrow)

#### Download data ####
raw_president_polls <- read_csv("data/01-raw_data/president_polls.csv")

#### Save data ####
write_parquet(raw_president_polls, "data/01-raw_data/raw_president_polls.parquet") 

         
