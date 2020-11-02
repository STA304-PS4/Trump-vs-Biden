#### Preamble ####
# Purpose: To prepare the survey data downloaded from IPUMS USA based on the 2018 ACS survey. 
# This data set will be used in the post-stratification process. MEaning that the data will be 
# adjusted to match the categories used in the cleaned Nation-Scape Data set. Then bin counts will
# be generated so that the two data sets may be compared. 
# Author: Arjun Dhatt, Ben Draskovic, Gantavya Gupta, Yiqu Ding 
# Data: 2 November 2020
# Contact: ben.draskovic@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the ACS data and saved it to inputs/ACS
# - Set up a gitignore in order to retain the privacy of the data 


#### Workspace setup ####
library(haven)
library(tidyverse)
library(dplyr)
# Read in the raw data. 
raw_data <- read_dta("inputs/ACS/usa_00001.dta.gz"
)
# Add the labels
raw_data <- labelled::to_factor(raw_data)

# Select variables of interest for analysis
names(raw_data)

reduced_data <- 
  raw_data %>% 
  select(age, 
         race, 
         hispan,
         educ,
         ftotinc)
rm(raw_data)

#Remove all na values from the data (For Family income NA was 9999999)
#Remove all children under 18
prep_data <- reduced_data %>% 
  filter(
    ftotinc<9999999,
    as.integer(age)>18,
    !is.na(age),
    !is.na(race),
    !is.na(hispan),
  )
# This removes 799,716 respondants from the data 


#Group the education responses into groups that best match the groups in UCLA Survey being used
#Notably an estimate as to when a degree would be completed had to be used for this we used the estimate of 3 years or above
recode_key_education <- c(  
  "n/a or no schooling" = "Less than HS",
  "nursery school to grade 4" = "Less than HS",
  "grade 5, 6, 7, or 8" = "Less than HS",
  "grade 9" = "Completed Some HS",
  "grade 10" = "Completed Some HS",
  "grade 11" = "Completed Some HS",
  "grade 12" = "Completed HS",
  "1 year of college" = "Participated in Higher Education",
  "2 years of college" = "Participated in Higher Education",
  "3 years of college" = "Completed 1 Higher Education Degree",
  "4 years of college" = "Completed 1 Higher Education Degree",
  "5+ years of college" = "Completed 1 Higher Education Degree or more"
)

# After the keys is made use the recode function to create a new string based on the collumn being changed 
educ0 <- recode(prep_data$educ, !!!recode_key_education)

#Include Bi/Multi Racial individuals in other as this was not gathered in UCLA data 
#Assuming that Bi/Multi Racial individuals would select other with no Bi/Multi Racial option
recode_key_race <- c(  
  "two major races" = "other race, nec",
  "three or more major races" = "other race, nec",
  "chinese" = "asian or pacific islander",
  "japanese" = "asian or pacific islander",
  "other asian or pacific islander" = "asian or pacific islander"
)
# After the keys is made use the recode function to create a new string based on the collumn being changed
race0 <- recode(prep_data$race, !!!recode_key_race)

# Adjust the actual collumns in the data set 
# Also group age into Age_groups and group income into Income_Groups for post-stratification, 
prep_data <- prep_data %>% 
  mutate(
    education_grouped = educ0,
    race_ethnicity = race0,
    hispanic = hispan
  ) %>% 
  mutate(
    age = case_when(
      as.numeric(age) >=18 & as.numeric(age) <=35 ~ "18-35",
      as.numeric(age) >=36 & as.numeric(age) <=55 ~ "36-55",
      as.numeric(age) >=56 & as.numeric(age) <=75 ~ "56-75",
      as.numeric(age) >=76 ~ "76 or Older",
    )
  ) %>% 
  mutate(
    household_income_grouped = case_when(
      as.numeric(ftotinc) <25000 ~ "$25k or less",
      as.numeric(ftotinc) >=25000 & as.numeric(ftotinc) < 50000 ~ "$25k to $50k",
      as.numeric(ftotinc) >=50000 & as.numeric(ftotinc) < 75000 ~ "$50k to $75k",
      as.numeric(ftotinc) >=75000 & as.numeric(ftotinc) < 100000 ~ "$75k to $100k",
      as.numeric(ftotinc) >=100000 & as.numeric(ftotinc) < 150000 ~ "$100k to $150k",
      as.numeric(ftotinc) >=150000  ~ "$150k or more"
    )
  ) %>% 
  select(
    age, household_income_grouped, education_grouped, race_ethnicity, hispanic
  )


# Generate the data file 
write_dta(prep_data, "outputs/post_strat_data.dta")

#Create a new tibble that includes the count of individuals in each of our subdivided categories
cell_counts <- prep_data %>% 
  group_by(age, household_income_grouped, education_grouped, race_ethnicity, hispanic) %>% 
  summarise(n = n()) #%>%  


#Generate the Data file of these cell counts
write_csv(cell_counts, "outputs/post_strat_cellcount.csv")

#Create the proportion files needed in the modelling stage 
#Each will be based on one of our variables of comparison 
age_prop <- cell_counts %>% 
  ungroup() %>% 
  group_by(age) %>% 
  mutate(prop = n/sum(n)) %>% 
  ungroup()

income_prop <- cell_counts %>% 
  ungroup() %>% 
  group_by(household_income_grouped) %>% 
  mutate(prop = n/sum(n)) %>% 
  ungroup()

education_prop <- cell_counts %>% 
  ungroup() %>% 
  group_by(education_grouped) %>% 
  mutate(prop = n/sum(n)) %>% 
  ungroup()

race_prop <- cell_counts %>% 
  ungroup() %>% 
  group_by(race_ethnicity) %>% 
  mutate(prop = n/sum(n)) %>% 
  ungroup()

hispanic_prop <- cell_counts %>% 
  ungroup() %>% 
  group_by(hispanic) %>% 
  mutate(prop = n/sum(n)) %>% 
  ungroup()

