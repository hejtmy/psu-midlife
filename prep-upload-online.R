library(tidyverse)
library(googlesheets4)
source("const.R")

df_online <- read_csv("data/MIDLIFE.csv")

## Deals with sensitive information ----
SENSITIVE_COLS <- c("naroz", "kont_jmeno", "kont_tel", "kont_mail", "kont_adr")

df_sensitive <- df_online %>%
  select(session, all_of(SENSITIVE_COLS))
df_online <- df_online %>%
  select(-all_of(SENSITIVE_COLS))

df_online_rekrutace <- read_csv("data/REKR_MIDLIFE.csv")

df_online <- df_online %>%
  left_join(select(df_online_rekrutace, session, ident), by = "session") %>%
  select(ident, everything())

TEMP_SHEET_NAME <- "Original-online-temp"
write_sheet(df_online, ss = GS_SHEET, sheet = TEMP_SHEET_NAME)
