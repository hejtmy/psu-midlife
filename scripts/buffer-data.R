#' This loads, processes and saves data so that they are prepared for the shiny app and reports
library(googlesheets4)
library(tidyverse)
source("functions/fetch-online-data.R")

USE_BUFFERED <- FALSE

df_online <- fetch_data_online(USE_BUFFERED)
df_paper <- fetch_data_paper(USE_BUFFERED)
df_german <- fetch_german_data(USE_BUFFERED)

source("scripts/merge-german-online-data.R")

## Recodes online variables -----
df_online <- filter(df_online, povol != "thank the formr monkey")
df_online <- readr::type_convert(df_online)

source("scripts/merge-paper-online-data.R")

dir.create("data/processed", showWarnings = FALSE)
write.table(df_all, "data/processed/all-data-raw.csv", sep=";",
            row.names = FALSE)

source("scripts/process-data.R")

df_question_categories <- fetch_question_categories() 
write.table(df_question_categories, "data/processed/question-categories.csv",
            sep=";")
