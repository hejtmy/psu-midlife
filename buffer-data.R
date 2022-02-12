#' This loads, processes and saves data so that they are prepared for the shiny app and 
#' reports
library(googlesheets4)
source("get-online-data.R")
source("process-data.R")

dir.create("processed", showWarnings = FALSE)
write.table(df_all, "processed/all-data.csv", sep=";", row.names = FALSE)

SHEET_ID <- "1pPdD8Q3r9DLZuKAfFrm95W14GHbUw6NOIipgxYJRUeI"
df_question_categories <- read_sheet(SHEET_ID, "Question-categories")
write.table(df_question_categories, "processed/question-categories.csv", sep=";")
