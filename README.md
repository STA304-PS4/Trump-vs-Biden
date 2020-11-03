# Overview

This repo contains code and data for forecasting the US 2020 presidential election. It was created by Arjun Dhatt, Benjamin Draskovic, Yiqu Ding and Gantavya Gupta. The purpose is to create a report that summarises the results of a MRP model that we built. Some data is unable to be shared publicly. We detail how to get that below. The sections of this repo are: inputs, outputs, scripts.

Inputs contain data that are unchanged from their original. We use two datasets: 

- [Survey data - Download from https://www.voterstudygroup.org/publication/nationscape-data-set, we want ns20200625. You can download it as a zip file and extract the file to wherever your working directory is.]
- [ACS data - Go to https://usa.ipums.org/usa/index.shtml, you will need to register to submit a data request. You will need to select variables manually from 2018 ACS. We want age, race, educ and ftotinc.]

Outputs contain data that are modified from the input data, the report and supporting material.

- paper.Rmd, 
- clean0survey.csv,
- post_strat_cellcount.csv

Scripts contain R scripts that take inputs and outputs and produce outputs. These are:

- 01_data_cleaning-survey-2.R
- 01_data_cleaning-post-strat-2.R




