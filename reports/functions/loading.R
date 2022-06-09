load_report_data <- function(language = "all"){
  df_processed <- load_processed() %>%
    filter(!is.na(ended) | source == "paper",
           vek > 35)
  if(language == "all") return(df_processed)
  
  df_processed <- df_processed %>%
    filter(language == language)
  
  return(df_processed)
}

