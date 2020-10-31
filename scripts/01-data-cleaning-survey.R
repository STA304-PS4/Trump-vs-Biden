#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from [...UPDATE ME!!!!!]
# Author: Arjun Dhatt, Ben Draskovic, Gantavya Gupta, Yiqu Ding 
# Data: 2 October 2020
# Contact: arjun.dhatt@mail.utoronto.ca 
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the data from X and save the folder that you're 
# interested in to inputs/data 
# - Don't forget to gitignore it!



#### Workspace setup ####
library(haven)
library(tidyverse)
# Read in the raw data (You might need to change this if you use a different dataset)
raw_data <- read_dta("inputs/ns20200625/ns20200625.dta")
# Add the labels
raw_data <- labelled::to_factor(raw_data)
# Just keep some variables

tbdata <- 
  raw_data %>% 
  select(age,
         education, hispanic,household_income, race_ethnicity,extra_covid_worn_mask,state, trump_biden
         ) %>% 
 mutate(binary = case_when(
   trump_biden == "Donald Trump" ~ 1,
   trump_biden == "Joe Biden" ~ 2
 )) %>% 
  filter(!is.na(binary))

write_csv(ps3_data, "outputs/clean-survey.csv")

#### What else???? ####
# Maybe make some age-groups?
# Maybe check the values?
# Is vote a binary? If not, what are you going to do?


# The vote is not a binary variable, it contains 758 "Don't Know", 2626 "Donald Trump", 3075 "Joe Biden" and 20 NAs. 
# We resolved this by deleting the "Don't know" and NA responses, since it was a relatively small (12%) part of our
# data set.

