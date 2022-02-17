library(tidyverse)
source("app/functions/graphs.R")
source("functions/process.R")
source("functions/questions.R")

df_question_categories <- read.table("processed/question-categories.csv", 
                                     sep=";", header=TRUE)
df_app <- read.table("processed/all-data-raw.csv", sep=";", header=TRUE)
df_app <- process_data(df_app)

df_app <- df_all %>%
  filter(pohl != "O",
         vzdel != "elementary")
