library(googlesheets4)

SHEET_ID <- "1pPdD8Q3r9DLZuKAfFrm95W14GHbUw6NOIipgxYJRUeI"
df_question_categories <- read_sheet(SHEET_ID, "Question-categories")
write.table(df_question_categories, "processed/question-categories.csv", sep=";")
