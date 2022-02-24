library(tidyverse)
process_data <- function(df_all){
  # should be run first before any calculations are readded
  df_all <- remove_duplicit_online_participants(df_all)
  df_all <- df_all %>%
    add_missing_values() %>% 
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

## Work scale ----
# reverzní skórování položek cs01; cs03; cs04; cs05; cs11; cs12; cs13; cs14; cs15; cs16
process_work_scale <- function(df_all){
  df_all <- df_all %>% 
    mutate(cs_s_score = reversed(cs1, 6) + cs2 + reversed(cs3,6) + 
             reversed(cs4, 6) + reversed(cs5, 6) + cs6 + cs7 + cs8 + cs9 + cs10 + 
             reversed(cs11, 6) + reversed(cs12, 6) + reversed(cs13, 6) + 
             reversed(cs14, 6) + reversed(cs15, 6) + reversed(cs16, 6))
  return(df_all)
}

remove_duplicit_online_participants <- function(df){
  DUPLICIT_PARTICIPANTS <- toupper(c("janciz1362", "petkri1070", "markal1678",
                                     "gabtyr0673", "marhro0870", "gabkli3166",
                                     "petwal0769"))
  df <- filter(df, source == "paper" | 
                  !(toupper(ident) %in% DUPLICIT_PARTICIPANTS))
  return(df)
}

add_missing_values <- function(df_all){
  longest_missing <- function(row){
    res <- rle(as.logical(is.na(row)))
    out <- max(res$lengths[res$values == 1])
    return(out)
  }
  df_all <- df_all %>%
    rowwise() %>%
    mutate(n_missing = sum(as.logical(cur_data())),
           longest_missing = longest_missing(cur_data()))
  return(df_all)
}

