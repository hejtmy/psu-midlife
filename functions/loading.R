library(here)

load_raw <- function(){
  out <- read.table(here("data/processed/all-data-raw.csv"),
                    sep =";", header = TRUE)
  return(out)
}

load_processed <- function(){
  out <- read.table(here("data/processed/all-data-processed.csv"),
                         sep = ";", header = TRUE)
  return(out)
}

load_question_categories <- function(){
  out <- read.table(here("data/processed/question-categories.csv"),
                                     sep=";", header=TRUE)
  return(out)
}