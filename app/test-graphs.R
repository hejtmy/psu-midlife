source("app/test-setup.R")
source("app/functions/graphs.R")

question_names <- df_question_categories %>% 
  filter(category == input$question_category) %>%
  pull(variable)
dat <- select(df_all, any_of(split_vars), any_of(rv$question_names))
data_filtered <- dat

QUESTION <- "panas_04"
SPLIT <- "pohl"

plot_question_results(df_app, QUESTION, splitvar = SPLIT)
