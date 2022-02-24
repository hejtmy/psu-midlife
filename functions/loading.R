load_raw <- function(){
  out <- read.table("processed/all-data-raw.csv", sep =";", header = TRUE)
  return(out)
}

load_processed <- function(){
  out <- read.table("processed/all-data-processed.csv", sep = ";", header = TRUE)
  return(out)
}