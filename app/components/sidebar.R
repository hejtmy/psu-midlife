appSidebarPanel <- function(df_question_categories, split_vars){
  options <- unique(df_question_categories$category)
  options <- options[!is.na(options)]
  choices <- as.list(options)
  names(choices) <- options
  out <- sidebarPanel(
    selectInput("question_category", "Select question category", 
                choices),
    selectInput("split_variable", "Select split variable", 
            c("none", split_vars)),
    width = 2
  )
  return(out)
}
