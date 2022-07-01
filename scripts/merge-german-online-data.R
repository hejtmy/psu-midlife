# This expects the xlsx file to be present
df_german <- df_german %>%
  filter(!is.na(session)) %>%
  select(-c(giveaway, interview_consent, longterm_consent,
            charity, partner_widow_age)) %>%
  mutate(ident = substr(session, 1, 5))

# Adding lcis columns --------
df_german <- df_german %>%
  add_column(lcis1_freq = NA, .after = "lcis1") %>%
  add_column(lcis2_freq = NA, .after = "lcis2") %>% 
  add_column(lcis4_freq = NA, .after = "lcis4") %>% 
  add_column(lcis7_freq = NA, .after = "lcis7") %>% 
  add_column(lcis12_freq = NA, .after = "lcis12")

colnames(df_german) <- colnames(df_online)

df_german <- df_german %>%
  mutate(vek=as.character(vek),
         wid_len=as.character(wid_len),
         vzdel_roky = as.character(vzdel_roky)) %>%
  mutate_at(vars(starts_with("lcis")), ~as.character(.))

df_online <- df_online %>%
  mutate_at(vars(starts_with("lcis")), ~as.character(.)) %>%
  mutate(vzdel_roky = as.character(vzdel_roky))

# Language ------
df_german <- df_german %>%
  mutate(language = "german")
df_online <- df_online %>%
  mutate(language = "czech")

# Final merge ---------
df_online <- bind_rows(df_german, df_online)
rm(df_german)
