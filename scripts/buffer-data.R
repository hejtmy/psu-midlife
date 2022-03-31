#' This loads, processes and saves data so that they are prepared for the shiny app and 
#' reports
library(googlesheets4)
library(tidyverse)
source("functions/fetch-online-data.R")

df_online <- fetch_data_online()
df_paper <- fetch_data_paper()
df_german <- fetch_german_data()

source("scripts/merge-german-online-data.R")
source("scripts/merge-paper-online-data.R")

dir.create("data/processed", showWarnings = FALSE)
write.table(df_all, "data/processed/all-data-raw.csv", sep=";", row.names = FALSE)

source("scripts/process-data.R")

df_question_categories <- fetch_question_categories() 
write.table(df_question_categories, "data/processed/question-categories.csv", sep=";")
