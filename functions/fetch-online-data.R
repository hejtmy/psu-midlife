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

fetch_error_data <- function(){
  df <- read_sheet(GS_SHEET, sheet = "Error-data")
  return(df)
}

#' Updates the list 
#'
#' @param df_all table with all the columns
update_question_categories <- function(df_all){
  df_categories <- fetch_question_categories()
  existing_questions <- df_categories[[1]]
  new_questions <- setdiff(colnames(df_all), existing_questions)
  df_new_questions <- data.frame(matrix(ncol = ncol(df_categories), nrow = length(new_questions)))
  colnames(df_new_questions) <- colnames(df_categories)
  df_new_questions[,1] <- new_questions
  sheet_append(GS_SHEET, df_new_questions, sheet = "Question-categories")
}