#' This loads, processes and saves data so that they are prepared for the shiny app and 
#' reports
library(googlesheets4)
source("functions/fetch-online-data.R")

df_online <- fetch_data_online()
df_paper <- fetch_data_paper()

source("scripts/merge-german-online-data.R")
df_german <- fetch_german_data()

source("scripts/merge-paper-online-data.R")

dir.create("processed", showWarnings = FALSE)
write.table(df_all, "processed/all-data-raw.csv", sep=";", row.names = FALSE)

df_question_categories <- fetch_question_categories() 
write.table(df_question_categories, "processed/question-categories.csv", sep=";")
