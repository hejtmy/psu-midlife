# This expects the xlsx file to be present
source("functions/fetch-online-data.R")
df_online <- fetch_data_online()

df_german <- readxl::read_excel("Midlife_ger28022022.xlsx")
SENSITIVE_COLS <- c("kont_name", "kont_tel", "kont_mail", "kont_adr", "email_giveaway")

df_german <- df_german %>%
  select(-SENSITIVE_COLS)
  
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
write_sheet(df_german, ss = GS_SHEET, sheet = "Original-german")
