library(googlesheets4)

GS_SHEET <- "1pPdD8Q3r9DLZuKAfFrm95W14GHbUw6NOIipgxYJRUeI"

fetch_data_paper <- function(){
  df_paper <- read_sheet(ss = GS_SHEET,sheet = "Original-paper", na = c("na", "nr"))
  return(df_paper)
}

fetch_data_paper_edited <- function(use_buffered=TRUE){
  return(fetch_sheet("Edited-paper", use_buffered))
}

fetch_data_online <- function(use_buffered=TRUE){
  return(fetch_sheet("Original-online", use_buffered))
}
fetch_data_online_edited <- function(use_buffered=TRUE){
  return(fetch_sheet("Edited-online", use_buffered))
}

fetch_question_categories <- function(use_buffered=TRUE){
  return(fetch_sheet("Question-categories", use_buffered))
}

fetch_error_data <- function(use_buffered=TRUE){
  return(fetch_sheet("Error-data", use_buffered))
}

fetch_german_data <- function(use_buffered=TRUE){
  return(fetch_sheet("Original-german", use_buffered, na=c("?")))
}

fetch_sheet <- function(sheet_name, use_buffered, ...){
  filepath <- paste0(file.path("data", "buffered", sheet_name), ".csv",
                     collapse = "")
  if(use_buffered & file.exists(filepath)){
    sh <- read.table(filepath, sep=";", header=TRUE)
  } else {
    dir.create(dirname(filepath), showWarnings = FALSE)
    sh <- read_sheet(ss=GS_SHEET, sheet=sheet_name, ...)
    write.table(sh, filepath, sep=";")
  }
  return(sh)
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

update_work_categories <- function(categories){
  sheet_
}