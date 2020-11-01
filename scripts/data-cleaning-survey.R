#### Preamble ####
# Purpose: The purpose of this code is to prepare and clean the Nationscape Data Set downloaded from the Democracy Fund Voter Study Group. Because we aren't looking at each and every one of the more than 200 variables included in the dataset, we want to clean the dataset so that it only includes variables that we are interested in. To address this issue, we only included the variables that we are interested in. Also, in our analysis, we will only be looking at who is going to win the popular vote between Donald Trump and Joe Biden, therefore we cleaned the results so that they only showcase those willing to vote for Donald Trump or Joe Biden. We also added another variable that was not originally included in the dataset to make vote a binary variable. A problem we encountered with the raw dataset was that a lot of the values were shown as N/A; to address this issue, we also cleaned the dataset so that it removed all N/A values meaning for each row in the dataset, every column has a meaningful value.# Author: Arjun Dhatt, Ben Draskovic, Gantavya Gupta, Yiqu Ding 
# Data: 2 November 2020
# Contact: arjun.dhatt@mail.utoronto.ca 
# License: MIT
# Pre-requisites: 
 ## 1. Go to: https://www.voterstudygroup.org/publication/nationscape-data-set
 ## 2. Look for the ‘Download the Full Data Set’ heading and enter your information and submit your request. After a short period of time, you will have received an email containing links to the dataset. 
 ## 3. Click on the link included in the email. Under the header ‘Download Resources’, download the .dta. files. This will be a zip file, therefore you will have to unzip it.
 ## 4. After unzipping the file, open ‘phase_2_v20200814’ -> ‘ns20200625’ -> ’01-data_cleaning-survey.R’. We open the folder pertaining to ‘ns20200625’ because we want data from June 25th, 2020. 
 ## 5. We want to then open ’01-data_cleaning-survey.R’ in R that way we can filter the dataset to our needs. 
 ## 6. You may need to adjust the file paths depending on your system. 

#### Workspace setup ####
library(haven)
library(tidyverse)

# Read in the raw data 
raw_data <- read_dta("inputs/ns20200625/ns20200625.dta")

# Add labels
raw_data <- labelled::to_factor(raw_data)

# Alter the dataset so that it only contains the variables that we are looking at. Also, add another variable that outputs a 1 if a participant chooses to vote for Donald Trump in the 2020 election and outputs a 2 if the participant chooses to vote for Joe Biden.
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

# The purpose of this line of code is to remove all NA values
# Some people may have not been comfortable sharing sensitive information such as income, so they may have refused to answer some questions. In order to avoid a distorted representation of our data, we removed all rows that contained an NA value. tbdata <- na.omit(tbdata)

write_csv(tbdata, "outputs/clean-survey.csv")


#### What else???? ####
# Maybe make some age-groups?
# Maybe check the values?
# Is vote a binary? If not, what are you going to do?


# The vote is not a binary variable, it contains 758 "Don't Know", 2626 "Donald Trump", 3075 "Joe Biden" and 20 NAs. 
# We resolved this by deleting the "Don't know" and NA responses, since it was a relatively small (12%) part of our
# data set.

