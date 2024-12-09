#### Preamble ####
# Purpose: Downloads and saves the data from fivethirtyeight as a parquet
# Author: Talia Fabregas, Fatimah Yunusa, Aliza Mitzwani
# Date: 24 October 2024
# Contact: talia.fabregas@mail.utoronto.ca, fatimah.yunusa@mail.utoronto.ca, aliza.mithwani@mail.utoronto.ca 
# License: MIT
# Pre-requisites: Download the Presidential general election polls (current cycle) 
# data from fivethirtyeight.com. 
# Any other information needed? We downloaded the data on October 26, 2024.


#### Workspace setup ####
library(tidyverse)
library(janitor)
library(arrow)

#### Download data ####
raw_president_polls <- read_csv("data/01-raw_data/president_polls.csv")

#### Save data ####
write_parquet(raw_president_polls, "data/01-raw_data/raw_data.parquet") 

         
