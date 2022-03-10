# This expects the xlsx file to be present

df_german <- df_german %>%
  select(-c(giveaway, interview_consent, longterm_consent, charity))

# Adding lcis columns
df_german <- df_german %>%
  add_column(lcis1_freq = NA, .after = "lcis1") %>%
  add_column(lcis2_freq = NA, .after = "lcis2") %>% 
  add_column(lcis4_freq = NA, .after = "lcis4") %>% 
  add_column(lcis7_freq = NA, .after = "lcis7") %>% 
  add_column(lcis12_freq = NA, .after = "lcis12")

df_german <- select(df_german, -partner_widow_age)
colnames(df_german) <- colnames(select(df_online, -ident))

bind_rows(df_german, df_online)
