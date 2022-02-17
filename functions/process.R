process_data <- function(df_all){
  df_all <- df_all %>%
    process_demographics() %>%
    process_swls() %>%
    process_panas()
  return(df_all)
}

# Returns reversed value for an input given min max
# reversed(6, 7) = 2
# reversed(2, 5) = 4
reversed <- function(value, maxValue, minValue = 1){
  return(minValue + (maxValue-value))
}

process_demographics <- function(df_all){
  df_all$pohl <- recode(df_all$pohl, `1`="F", `2`="M", `3`="O")
  df_all$pohl <- ifelse(df_all$source == "paper", df_all$gender, df_all$pohl)
  df_all$gender <- NULL
  
  df_all$vzdel <-  recode(df_all$vzdel, `1`="elementary", `2`="high school", `3`="university")
  
  return(df_all)
}

process_panas <- function(df_all){
  # The PANAS online has a bug with quesiton 13 missing and going to 21. So all 
  # questions from 13 and up need to be one higher
  df_all <- df_all %>%
    mutate(panas_s_positive = (panas_01 + panas_03 + panas_05 + panas_09 + panas_10 + 
                                 panas_12 + panas_15 + panas_17 + panas_18 + panas_20) / 10,
           panas_s_negative = (panas_02 + panas_04 + panas_06 + panas_07 + panas_08 + 
                                 panas_11 + panas_14 + panas_16 + panas_19 + panas_21) / 10,
           panas_s_hedonic = panas_s_positive - panas_s_negative)
  return(df_all)
}

## SWLS ------
process_swls <- function(df_all){
  #SATISFACTION (swls_01 + swls_02 +…+ swls_05)/ 5
  df_all <- df_all %>% 
    mutate(swls_s_satifaction = (swls_01 + swls_02 + swls_03 + swls_04 + swls_05) / 5)
  return(df_all)
}

## LCIS
