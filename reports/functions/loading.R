load_report_data <- function(lang = "all"){
  df_processed <- load_processed() %>%
    filter(!is.na(ended) | source == "paper",
           vek > 35)
  if(lang == "all") return(df_processed)
  
  df_processed <- df_processed %>%
    filter(language == lang)
  
  return(df_processed)
}

