#### Preamble ####
# Purpose: The purpose of this code is to prepare and clean the Nationscape Data Set downloaded from the Democracy Fund 
# Voter Study Group. Because we aren't looking at each and every one of the more than 200 variables included in the dataset,
# we want to clean the dataset so that it only includes variables that we are interested in. To address this issue, we only
# included the variables that we are interested in. Also, in our analysis, we will only be looking at who is going to win 
# the popular vote between Donald Trump and Joe Biden, therefore we cleaned the results so that they only showcase those 
# willing to vote for Donald Trump or Joe Biden. We also added another variable that was not originally included in the
# dataset to make vote a binary variable. A problem we encountered with the raw dataset was that a lot of the values were 
# shown as N/A; to address this issue, we also cleaned the dataset so that it removed all N/A values meaning for each row 
# in the dataset, every column has a meaningful value.
# Author: Arjun Dhatt, Ben Draskovic, Gantavya Gupta, Yiqu Ding 
# Data: 2 November 2020
# Contact: arjun.dhatt@mail.utoronto.ca 
# License: MIT
# Pre-requisites: 
## 1. Go to: https://www.voterstudygroup.org/publication/nationscape-data-set
## 2. Look for the 'Download the Full Data Set' heading and enter your information and submit your request. 
## After a short period of time, you will have received an email containing links to the dataset. 
## 3. Click on the link included in the email. Under the header 'Download Resources', download the .dta. 
## files. This will be a zip file, therefore you will have to unzip it.
## 4. After unzipping the file, open 'phase_2_v20200814' -> 'ns20200625' -> '01-data_cleaning-survey.R'. 
## We open the folder pertaining to 'ns20200625' because we want data from June 25th, 2020. 
## 5. We want to then open '01-data_cleaning-survey.R' in R that way we can filter the dataset to our needs. 
## 6. You may need to adjust the file paths depending on your system. 


#### Workspace setup ####
library(haven)
library(tidyverse)
library(dplyr)

# Read in the raw data 
raw_data <- read_dta("inputs/ns20200625/ns20200625.dta")

# Add labels
raw_data <- labelled::to_factor(raw_data)
# Keeping important variables
# Adding an extra variable that outputs a 1 if someone chooses to vote for Donald Trump in the 2020 elections 
# and 0 otherwise
tbdata <- 
  raw_data %>% 
  select(age,
         education, hispanic,household_income, race_ethnicity,extra_covid_worn_mask,state, trump_biden
  ) %>% 
  mutate(binary = case_when(
    trump_biden == "Donald Trump" ~ 1,
    trump_biden == "Joe Biden" ~ 0
  )) %>% 
  filter(!is.na(binary))

# The purpose of this line of code is to remove all NA values
# Some people may have not been comfortable sharing sensitive information such as income, so they may have refused to
# answer some questions. In order to avoid a distorted representation of our data, we removed all rows that contained an 
# NA value. 
tbdata <- na.omit(tbdata)

#Group all of the Asian and PAcific Islander Ethnicity options in to 3 categories
recode_key_race <- c(  
  "Asian (Asian Indian)" = "Asian or Pacific Islander",
  "Asian (Chinese)" = "Asian or Pacific Islander",
  "Asian (Filipino)" = "Asian or Pacific Islander",
  "Asian (Japanese)" = "Asian or Pacific Islander",
  "Asian (Korean)" = "Asian or Pacific Islander",
  "Asian (Vietnamese)" = "Asian or Pacific Islander",
  "Asian (Other)" = "Asian or Pacific Islander",
  "Pacific Islander (Native Hawaiian)" = "Asian or Pacific Islander",
  "Pacific Islander (Guamanian)" = "Asian or Pacific Islander",
  "Pacific Islander (Samoan)" = "Asian or Pacific Islander",
  "Pacific Islander (Other)" = "Asian or Pacific Islander"
)

# After the key is made use the recode function to create a new string based on the collumn being changed 
race_ethnicity0 <- recode(tbdata$race_ethnicity, !!!recode_key_race)

#Group the incomes in to groups that are easier to display
recode_key_income <- c(  
  "Less than $14,999" = "$25k or less",
  "$15,000 to $19,999" = "$25k or less",
  "$20,000 to $24,999" = "$25k or less",
  "$25,000 to $29,999" = "$25k to $50k",
  "$30,000 to $34,999" = "$25k to $50k",
  "$35,000 to $39,999" = "$25k to $50k",
  "$40,000 to $44,999" = "$25k to $50k",
  "$45,000 to $49,999" = "$25k to $50k",
  "$50,000 to $54,999" = "$50k to $75k",
  "$55,000 to $59,999" = "$50k to $75k",
  "$60,000 to $64,999" = "$50k to $75k",
  "$65,000 to $69,999" = "$50k to $75k",
  "$70,000 to $74,999" = "$50k to $75k",
  "$75,000 to $79,999" = "$75k to $100k",
  "$80,000 to $84,999" = "$75k to $100k",
  "$85,000 to $89,999" = "$75k to $100k",
  "$90,000 to $94,999" = "$75k to $100k",
  "$95,000 to $99,999" = "$75k to $100k",
  "$100,000 to $124,999" = "$100k to $150k",
  "$125,000 to $149,999" = "$100k to $150k",
  "$150,000 to $174,999" = "$150k or more",
  "$175,000 to $199,999" = "$150k or more",
  "$200,000 to $249,999" = "$150k or more",
  "$250,000 and above" = "$150k or more"
)

# After the keys is made use the recode function to create a new string based on the collumn being changed 
household_income0 <- recode(tbdata$household_income, !!!recode_key_income)


#Group the Hispanic responses into groups that match the ACS groups
recode_key_hispanic <- c(  
  "Argentinian" = "Other Hispanic",
  "Colombian" = "Other Hispanic",
  "Ecuadorian" = "Other Hispanic",
  "Salvadorean" = "Other Hispanic",
  "Guatemalan" = "Other Hispanic",
  "Nicaraguan" = "Other Hispanic",
  "Panamanian" = "Other Hispanic",
  "Peruvian" = "Other Hispanic",
  "Spanish" = "Other Hispanic",
  "Venezuelan" = "Other Hispanic"
)

# After the keys is made use the recode function to create a new string based on the collumn being changed 
hispanic0 <- recode(tbdata$hispanic, !!!recode_key_hispanic)

#Group the Education responses into groups that match the ACS groups
recode_key_education <- c(  
  "Middle School - Grades 4 - 8" = "Less than HS",
  "3rd Grade or less" = "Less than HS",
  "Associate Degree" = "Completed 1 Higher Education Degree",
  "Completed some graduate, but no degree" = "Completed 1 Higher Education Degree or more",
  "Completed some high school" = "Completed some HS",
  "High school graduate" = "Completed HS",
  "Completed some college, but no degree" = "Participated in Higher Education",
  "College Degree (such as B.A., B.S.)" = "Completed 1 Higher Education Degree",
  "Other post high school vocational training" = "Participated in Higher Education",
  "Masters degree" = "Completed 1 Higher Education Degree or more",
  "Doctorate degree" = "Completed 1 Higher Education Degree or more"
)

# After the keys is made use the recode function to create a new string based on the collumn being changed 
educ0 <- recode(tbdata$education, !!!recode_key_education)



# Adjust the actual collumns in the data set 
# Also group age in to Age-groups for post-stratification
tbdata <- tbdata %>% 
  mutate(
    race_ethnicity = race_ethnicity0,
    hispanic = hispanic0,
    household_income_grouped = household_income0,
    education_grouped = educ0
  ) %>% 
  mutate(
    age_group = case_when(
      as.numeric(age) >=18 & as.numeric(age) <=35 ~ "18-35",
      as.numeric(age) >=36 & as.numeric(age) <=55 ~ "36-55",
      as.numeric(age) >=56 & as.numeric(age) <=75 ~ "56-75",
      as.numeric(age) >=76 ~ "76 or Older",
    )
  )




write_csv(tbdata, "outputs/clean-survey.csv")


#### What else???? ####
# Maybe make some as.numeric(age)-groups?
# Maybe check the values?
# Is vote a binary? If not, what are you going to do?


# The vote is not a binary variable, it contains 758 "Don't Know", 2626 "Donald Trump", 3075 "Joe Biden" and 20 NAs. 
# We resolved this by deleting the "Don't know" and NA responses, since it was a relatively small (12%) part of our
# data set.

