#' This expects the FORMR midlife data to be downloaded and placed in data folder
#' IT processes and uploads the data online.
#' 
#' this script was run only a single time,
#' all the consecutive analyses are done on the online data

library(tidyverse)
source("functions/fetch-online-data.R")

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

# GERMAN DATA ----
source("functions/fetch-online-data.R")

df_german <- readxl::read_excel("Midlife_ger28022022.xlsx")
SENSITIVE_COLS <- c("kont_name", "kont_tel", "kont_mail", "kont_adr", "email_giveaway")

df_german <- df_german %>%
  select(-SENSITIVE_COLS)
  
write_sheet(df_german, ss = GS_SHEET, sheet = "Original-german")