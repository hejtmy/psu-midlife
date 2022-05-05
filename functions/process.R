library(tidyverse)
#' processes data 
#'
#' @param df_all data to process
#' @param df_error data with erroneous participants to remove
#'
#' @return
#' @export
#'
#' @examples
process_data <- function(df_all, df_error){
  # should be run first before any calculations are added
  df_all <- remove_erroneous_recordings(df_all, df_error)
  df_all <- df_all %>%
    add_missing_values() %>% 
    process_demographics() %>%
    process_work_scale() %>%
    process_finance_scale() %>%
    process_health_scale() %>% 
    process_partner_scale() %>%
    process_family_scale() %>%
    process_friends_scale() %>%
    process_lcis_kol() %>%
    process_lcis_values() %>%
    process_bfi2s() %>% 
    process_brs() %>% 
    process_bpns() %>% 
    process_cesd() %>%
    process_dids() %>% 
    process_gbc() %>% 
    process_goals() %>% 
    process_gse_scale() %>% 
    process_lgs() %>% 
    process_mlq() %>% 
    process_panas() %>%
    process_pss() %>% 
    process_pwb() %>% 
    process_rheis() %>% 
    process_swls() %>% 
    process_zftp()
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
  
  df_all$vzdel <-  recode(df_all$vzdel, `1`="elementary", 
                          `2`="high school", `3`="university")
  
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

## LCIS
process_lcis_kol <- function(df_all){
  LCIS_QUESTIONS <- 45
  for(i in seq_len(LCIS_QUESTIONS)){
    checked_yes <- df_all[[sprintf("lcis%d", i)]] == 1
    old_value <- df_all[[sprintf("lcis%d_kol", i)]]
    new_kol_name <- sprintf("lcis%d_s_computedkol", i)
    df_all[[new_kol_name]] <- ifelse(checked_yes & is.na(old_value), 1, old_value)
  }
  return(df_all)
}

process_lcis_values <- function(df_all){
  ## ADD MULTIPLIERS HERE
  MULTIPLIERS <- rep(100, 73, 65, 63, 63, 53, 50, 75, 48, 47, 45, 45, 44, 40, 
                     39, 39, 39, 38, 37, 36, 35, 31, 30, 29, 29, 29, 28, 26, 
                     26, 25, 24, 23, 20, 20, 20, 19, 19, 19, 17, 16, 15, 15, 
                     13, 12, 11)
  for(i in seq_len(length(MULTIPLIERS))){
    weight_name <- sprintf("lcis%d_s_weight", i)
    computed_weight_name <- sprintf("lcis%d_s_computedweigth", i)
    df_all[[weight_name]] <- df_all[[sprintf("lcis%d_kol", i)]] * MULTIPLIERS[i]
    df_all[[computed_weight_name]] <- 
      df_all[[sprintf("lcis%d_s_computedkol", i)]] * MULTIPLIERS[i]
  }
  return(df_all)
}

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

remove_erroneous_recordings <- function(df_all, df_error){
  df_error$ident <- toupper(df_error$ident)
  df_all <- df_all %>% 
    mutate(temp_ident = toupper(ident)) %>%
    anti_join(df_error, by=c("temp_ident" = "ident", "source" = "source")) %>%
    select(-temp_ident)
  return(df_all)
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

##FINANCIAL SITUATION
process_finance_scale <- function(df_all){
  df_all <- df_all %>%
    mutate(finance_s_total = e1 + e2)
  return(df_all)
}

##HEALTH SCALE -----
process_health_scale <- function(df_all){
  #reversed z2, z3
  df_all <- df_all %>%
    mutate(health_s_total = z1 + reversed(z2, 6) + reversed(z3, 6) + z4 + z5)
  return(df_all)
}

##PARTNER SCORE ------
process_partner_scale <- function(df_all){
  #reversed p7-p12
  df_all <- df_all %>%
    mutate(partner_s_total = p1 + p2 + p3 + p4 + p5 + p6 + reversed(p7, 6) + 
             reversed(p8, 6) + reversed(p9, 6) + reversed(p10, 6) + 
             reversed(p11, 6) + reversed(p12, 6))
  return(df_all)
}

##FAMILY SCALE -----
process_family_scale <- function(df_all){
  #reversed f5-f8
  df_all <- df_all %>%
    mutate(family_s_total = f1 + f2 + f3 + f4 + reversed(f5, 6) + reversed(f6, 6) +
             reversed(f7, 6) + reversed(f8, 6))
  return(df_all)
}

##FRIENDS SCALE -----
process_friends_scale <- function(df_all){
  #reversed f5-f8
  df_all <- df_all %>%
    mutate(friends_s_total = fs1 + fs2 + fs3 + fs4 + reversed(fs5, 6) + 
             reversed(fs6, 6) + reversed(fs7, 6) + reversed(fs8, 6))
  return(df_all)
}

## SWLS ------
process_swls <- function(df_all){
  #SATISFACTION (swls_01 + swls_02 +…+ swls_05)/ 5
  df_all <- df_all %>% 
    mutate(swls_s_satifaction = (swls_01 + swls_02 + swls_03 + swls_04 + swls_05) / 5)
  return(df_all)
}

##BRS -----
process_brs <- function(df_all){
  # reversed 2,4,6
  df_all <- df_all %>%
    mutate(brs_s_total = brs_01 + reversed(brs_02, 5) + brs_03 + 
                            reversed(brs_04, 5) + brs_05 + reversed(brs_06, 5),
           brs_s_average = brs_s_total / 6)
  return(df_all)
}

##MEANING IN LIFE ----
process_mlq <- function(df_all){
  #reversed mlq_09
  #Presence (mlq_01 + mlq_04 + mlq_05 + mlq_06 + mlq_09rev)
  #Search (mlq_02 + mlq_03 + mlq_07 + mlq_08 + mlq_10)
  df_all <- df_all %>%
    mutate(mlq_s_presence = mlq_01 + mlq_04 + mlq_05 + mlq_06 + reversed(mlq_09, 7),
           mlq_s_search = mlq_02 + mlq_03 + mlq_07 + mlq_08 + mlq_10)
  return(df_all)
}

##GENERAL SELF-EFFICACY -----
process_gse_scale <- function(df_all){
  df_all <- df_all %>%
    mutate(gse_s_total = gse_01 + gse_02 + gse_03 + gse_04 + gse_05 + 
             gse_06 + gse_07 + gse_08 + gse_09 + gse_10)
  return(df_all)
}

## DEPRESSION ------
process_cesd <- function(df_all){
  #DEPRESSION reverse coded 5 and 8
  df_all <- df_all %>%
    mutate(cesd_s_total = cesd_01 + cesd_02 + cesd_03 + cesd_04 + 
             reversed(cesd_05, 4) + cesd_06 + cesd_07 +
             reversed(cesd_08, 4) + cesd_09 + cesd_10)
  return(df_all)
}

##PERCEIVED STRESS -----
process_pss <- function(df_all){
  # reversed 4,5,7,8
  df_all <- df_all %>%
    mutate(pss_s_total = pss_01 + pss_02 + pss_03 + reversed(pss_04, 5) + 
             reversed(pss_05, 5) + pss_06 + reversed(pss_07, 5) + 
             reversed(pss_08, 5) + pss_09 + pss_10)
  return(df_all)
}

##PERSONAL WELL-BEING
process_pwb <- function(df_all){
  #reversed items: # 3, 5, 10, 13,14,15,16,17,18,19, 23, 26, 27, 30,31,32, 34, 36, 39, 41
  # Autonomy: 1,7,13,19,25, 31, 37
  # Environmental mastery: 2,8,14,20,26,32,38
  # Personal Growth: 3,9,15,21,27,33,39
  # Positive Relations: 4,10,16,22,28,34,40
  # Purpose in life: 5,11,17,23,29,35,41
  # Self-acceptance: 6,12,18,24,30,36,42
  df_all <- df_all %>%
    mutate(pwb_s_autonomy = pwb_01 + pwb_07 + reversed(pwb_13, 6) + reversed(pwb_19, 6) + pwb_25 +
             reversed(pwb_31, 6) + pwb_37,
           pwb_s_environmental_mastery = pwb_02 + pwb_08 + reversed(pwb_14, 6) + pwb_20 + reversed(pwb_26, 6) +
             reversed(pwb_32, 6) + pwb_38,
           pwb_s_personal_growth = reversed(pwb_03, 6) + pwb_09 + reversed(pwb_15, 6) + pwb_21 +
             reversed(pwb_27, 6) + pwb_33 + reversed(pwb_39, 6),
           pwb_s_positive_relations = pwb_04 + reversed(pwb_10, 6) + reversed(pwb_16, 6) + pwb_22 +
             pwb_28 + reversed(pwb_34, 6) + pwb_40,
           pwb_s_purpose_in_life = reversed(pwb_05, 6) + pwb_11 + reversed(pwb_17, 6) + reversed(pwb_23, 6) +
             pwb_29 + pwb_35 + reversed(pwb_41, 6),
           pwb_s_self_acceptance = pwb_06 + pwb_12 + reversed(pwb_18, 6) + pwb_24 + reversed(pwb_30, 6) +
             reversed(pwb_36, 6) + pwb_42)
  return(df_all)
}

#BIG FIVE BFI2S -----
process_bfi2s <- function(df_all){
  # Extraversion: bfi2s_01rev + bfi2s_06 + bfi2s_11 + bfi2s_16 + bfi2s_21rev + bfi2s_26rev 
  # Agreeableness: bfi2s_02 + bfi2s_07rev + bfi2s_12 + bfi2s_17rev + bfi2s_22 + bfi2s_27rev 
  # Conscientiousness: bfi2s_03rev + bfi2s_08rev + bfi2s_13 + bfi2s_18 + bfi2s_23 + bfi2s_28rev 
  # Negative Emotionality: bfi2s_04 + bfi2s_09 + bfi2s_14rev + bfi2s_19rev + bfi2s_24rev + bfi2s_29 
  # Open-Mindedness: bfi2s_05 + bfi2s_10rev + bfi2s_15 + bfi2s_20 + bfi2s_25 + bfi2s_30rev
  df_all <- df_all %>%
    mutate(bfi2s_s_extraversion = reversed(bfi2s_01, 5) + bfi2s_06 + bfi2s_11 +
             bfi2s_16 + reversed(bfi2s_21, 5) + reversed(bfi2s_26, 5),
           bfi2s_s_agreeableness = bfi2s_02 + reversed(bfi2s_07, 5) + bfi2s_12 +
             reversed(bfi2s_17, 5) + bfi2s_22 + reversed(bfi2s_27, 5),
           bfi2s_s_conscientiousness = reversed(bfi2s_03, 5) + reversed(bfi2s_08, 5) +
             bfi2s_13 + bfi2s_18 + bfi2s_23 + reversed(bfi2s_28, 5),
           bfi2s_s_negative_emotionality = bfi2s_04 + bfi2s_09 + reversed(bfi2s_14, 5) + 
             reversed(bfi2s_19, 5) + reversed(bfi2s_24, 5) + bfi2s_29,
           bfi2s_open_mindedness = bfi2s_05 + reversed(bfi2s_10, 5) + bfi2s_15 + 
             bfi2s_20 + bfi2s_25 + reversed(bfi2s_30, 5))
  return(df_all)
}

## BASIC NEEDS ------
process_bpns <- function(df_all){
  # REVERSE CODED ITEMS: 03, 04, 07, 11, 15, 16, 18, 19, 20
  df_all <- df_all %>%
    mutate(bpns_s_total = (bpns_01 + bpns_02 + reversed(bpns_03, 7) + reversed(bpns_04, 7) + bpns_05 + bpns_06 +
                       reversed(bpns_07, 7) + bpns_08 + bpns_09 + bpns_10 + reversed(bpns_11, 7) + bpns_12 +
                       bpns_13 + bpns_14 + reversed(bpns_15, 7) + reversed(bpns_16, 7) + bpns_17 +
                       reversed(bpns_18, 7) + reversed(bpns_19, 7) + reversed(bpns_20, 7) + bpns_21),
           bpns_s_average = bpns_s_total / 21)
  return(df_all)
}

##GENERATIVE BEHAVIOR -----
process_gbc <- function(df_all){
  df_all <- df_all %>%
    mutate(gbc_s_total = (gbc_01 + gbc_02 + gbc_03 + gbc_04 + gbc_05 + gbc_06 + gbc_07 + gbc_08 + gbc_09 + gbc_10 +
                      gbc_11 + gbc_12 + gbc_13 + gbc_14 + gbc_15 + gbc_16 + gbc_17 + gbc_18 + gbc_19 + gbc_20 +
                      gbc_21 + gbc_22 + gbc_23 + gbc_24 + gbc_25 + gbc_26 + gbc_27 + gbc_28 + gbc_29 + gbc_30 +
                      gbc_31 + gbc_32 + gbc_33 + gbc_34 + gbc_35 + gbc_36 + gbc_37 + gbc_38 + gbc_39 + gbc_40),
           gbc_s_average = gbc_s_total / 40)
  return(df_all)
}

##GOALS -----
process_goals <- function(df_all){
  df_all <- df_all %>%
    mutate(goals_s_achievement_importance= (goals_01_dul + goals_07_dul + goals_13_dul + goals_19_dul) / 4,
           goals_s_affection_importance = (goals_02_dul + goals_08_dul + goals_14_dul + goals_20_dul) / 4,
           goals_s_hedonism_importance = (goals_03_dul + goals_09_dul + goals_15_dul + goals_21_dul) / 4,
           goals_s_altruism_importance = (goals_04_dul + goals_10_dul + goals_16_dul + goals_22_dul) / 4,
           goals_s_power_importance = (goals_05_dul + goals_11_dul + goals_17_dul + goals_23_dul) / 4,
           goals_s_intimacy_importance = (goals_06_dul + goals_12_dul + goals_18_dul + goals_24_dul) / 4,
           goals_s_achievement_attainability = (goals_01_dos + goals_07_dos + goals_13_dos + goals_19_dos) / 4,
           goals_s_affection_attainability = (goals_02_dos + goals_08_dos + goals_14_dos + goals_20_dos) / 4,
           goals_s_hedonism_attainability = (goals_03_dos + goals_09_dos + goals_15_dos + goals_21_dos) / 4,
           goals_s_altruism_attainability = (goals_04_dos + goals_10_dos + goals_16_dos + goals_22_dos) / 4,
           goals_s_power_attainability = (goals_05_dos + goals_11_dos + goals_17_dos + goals_23_dos) / 4,
           goals_s_intimacy_attainability = (goals_06_dos + goals_12_dos + goals_18_dos + goals_24_dos) / 4,
           goals_s_achievement_succeeding = (goals_01_usp + goals_07_usp + goals_13_usp + goals_19_usp) / 4,
           goals_s_affection_succeeding = (goals_02_usp + goals_08_usp + goals_14_usp + goals_20_usp) / 4,
           goals_s_hedonism_succeeding = (goals_03_usp + goals_09_usp + goals_15_usp + goals_21_usp) / 4,
           goals_s_altruism_succeeding = (goals_04_usp + goals_10_usp + goals_16_usp + goals_22_usp) / 4,
           goals_s_power_succeeding = (goals_05_usp + goals_11_usp + goals_17_usp + goals_23_usp) / 4,
           goals_s_intimacy_succeeding = (goals_06_usp + goals_12_usp + goals_18_usp + goals_24_usp) / 4)
  return(df_all)
}

##LOYOLA GENERATIVITY SCALE -----
process_lgs <- function(df_all){
  #reverse coded ITEMS: 02, 05, 09, 13, 14, 15
  df_all <- df_all %>%
    mutate(lgs_s_total = (lgs_01 + reversed(lgs_02, 4) + lgs_03 + lgs_04 +
                          reversed(lgs_05, 4) + lgs_06 + lgs_07 + lgs_08 +
                          reversed(lgs_09, 4) + lgs_10 + lgs_11 + lgs_12 +
                          reversed(lgs_13, 4) + reversed(lgs_14, 4) +
                          reversed(lgs_15, 4) + lgs_16 + lgs_17 + lgs_18 + 
                          lgs_19 + lgs_20),
           lgs_s_average = lgs_s_total / 20)
  return(df_all)
}

##TIME PERSPECTIVE -----
process_zftp <- function(df_all){
  df_all <- df_all %>%
    mutate(zftp_s_past_negative = zftp_02 + zftp_10 + zftp_17,
           zftp_s_past_positive = zftp_01 + zftp_03 + zftp_07,
           zftp_s_pres_hedonism = zftp_08 + zftp_13 + zftp_16,
           zftp_s_present_fatalism = zftp_06 + zftp_11 + zftp_18,
           zftp_s_future_positive = zftp_05 + zftp_12 + zftp_14,
           zftp_s_future_negative = zftp_04 + zftp_09 + zftp_15)
  return(df_all)
}

##DIDS (IDENTITY DEVELOPMENT) -----
process_dids <- function(df_all){
  df_all <- df_all %>%
    mutate(dids_s_commitment_making = dids_01 + dids_02 + dids_03 + dids_04 + dids_05,
           dids_s_exploration_breadth = dids_06 + dids_07 + dids_08 + dids_09 + dids_10,
           dids_s_ruminative_exploration = dids_11 + dids_12 + dids_13 + dids_14 + dids_15,
           dids_s_identification_with_commitment = dids_16 + dids_17 + dids_18 + dids_19 + dids_20,
           dids_s_exploration_depth = dids_21 + dids_22 + dids_23 + dids_24 + dids_25)
  return(df_all)
}

##EGO INTEGRITY
process_rheis <- function(df_all){
  #reverse coded items: 3, 6, 7, 9, 11, 12, 13, 14, 16
  df_all <- df_all %>%
    mutate(rheis_s_egointegrity = (rheis_01 + rheis_02 + reversed(rheis_03, 6) +
                                    rheis_04 + rheis_05 + reversed(rheis_06, 6) +
                                    reversed(rheis_07, 6) + rheis_08 + reversed(rheis_09, 6) +
                                    rheis_10 + reversed(rheis_11, 6) + reversed(rheis_12, 6) + 
                                    reversed(rheis_13, 6) + reversed(rheis_14, 6) + 
                                    rheis_15 + reversed(rheis_16, 6)) / 16,
           rheis_s_egointegrity_positive = (rheis_01 + rheis_02 + rheis_04 + 
                                            rheis_05 + rheis_08 + rheis_10 + rheis_15) / 7,
           rheis_s_egointegrity_negative = (reversed(rheis_03, 6) + reversed(rheis_06, 6) + reversed(rheis_07, 6) +
                                    reversed(rheis_09, 6) + reversed(rheis_11, 6) + reversed(rheis_12, 6) +
                                    reversed(rheis_13, 6) + reversed(rheis_14, 6) + reversed(rheis_16, 6)) / 9)
  return(df_all)
}