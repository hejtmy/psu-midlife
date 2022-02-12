process_data <- function(df_all){
  df_all <- df_all %>%
    process_demographics() %>%
    process_swls()
  return(df_all)
}

process_demographics <- function(df_all){
  df_all$pohl <- recode(df_all$pohl, `1`="F", `2`="M", `3`="O")
  df_all$pohl <- ifelse(df_all$source == "paper", df_all$gender, df_all$pohl)
  df_all$gender <- NULL
  
  df_all$vzdel <-  recode(df_all$vzdel, `1`="elementary", `2`="high school", `3`="university")
  
  return(df_all)
}

## SWLS ------
process_swls <- function(df_all){
  #SATISFACTION (swls_01 + swls_02 +…+ swls_05)/ 5
  df_all <- df_all %>% 
    mutate(swls_satifaction = swls_01 + swls_02 + swls_03 + swls_04 + swls_05)
  return(df_all)
}
## LCIS

