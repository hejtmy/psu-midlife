library(googlesheets4)
GS_SHEET <- "1pPdD8Q3r9DLZuKAfFrm95W14GHbUw6NOIipgxYJRUeI"

fetch_data_paper <- function(){
  df_paper <- read_sheet(ss = GS_SHEET, sheet = "Original-paper", na = c("na", "nr"))
  return(df_paper)
}

fetch_data_online <- function(){
  df_online <- read_sheet(ss = GS_SHEET, sheet = "Original-online")
  return(df_online)
}

fetch_question_categories <- function(){
  df <- read_sheet(GS_SHEET, sheet = "Question-categories")
  return(df)
}
