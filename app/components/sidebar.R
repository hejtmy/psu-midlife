appSidebarPanel <- function(df_question_categories){
  options <- unique(df_question_categories$category)
  options <- options[!is.na(options)]
  choices <- as.list(options)
  names(choices) <- options
  out <- sidebarPanel(
    selectInput("question_category", "Select question category", 
                choices),
    width = 2
  )
  return(out)
}
