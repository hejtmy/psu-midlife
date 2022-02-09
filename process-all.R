df_all$pohl <- recode(df_all$pohl, `1`="F", `2`="M", `3`="O")
df_all$pohl <- ifelse(df_all$source == "paper", df_all$gender, df_all$pohl)
df_all$gender <- NULL

## SWLS ------
#SATISFACTION (swls_01 + swls_02 +…+ swls_05)/ 5
df_all <- df_all %>% 
  mutate(swls_satifaction = swls_01 + swls_02 + swls_03 + swls_04 + swls_05)

df_all %>% 
  select(starts_with("swls")) %>% 
  View()

df_all %>% 
  ggplot(aes(swls_satifaction)) + geom_histogram()

## LCIS

