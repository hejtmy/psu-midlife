library(tidyverse)
library(googlesheets4)
source("const.R")

df_online <- read_csv("/Users/lukashejtmanek/Downloads/MIDLIFE.csv")
SENSITIVE_COLS <- c("naroz", "kont_jmeno", "kont_tel", "kont_mail", "kont_adr")

## Deals with sensitive information ----
df_sensitive <- df_online %>%
  select(session, all_of(SENSITIVE_COLS))
df_online <- df_online %>%
  select(-all_of(SENSITIVE_COLS))

df_online_rekrutace <- read_csv("/Users/lukashejtmanek/Downloads/REKR_MIDLIFE.csv")
df_online <- df_online %>%
  left_join(select(df_online_rekrutace, session, ident), by = "session")


View(data.frame(online = c(colnames(select(df_online, -c(1:5))), 1:9),
                paper = colnames(select(df_paper, -c(1:9)))))

df_paper %>%
  select(-starts_with("occup"),
         -starts_with("relig"),
         -starts_with("family"),
         -starts_with("home"),
         -starts_with("partner"),
         -starts_with("kids"))

TEMP_SHEET_NAME <- "online-original-temp"

write_sheet(df_online, ss = GS_SHEET, sheet = TEMP_SHEET_NAME)

