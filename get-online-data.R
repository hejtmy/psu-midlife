library(googlesheets4)
source("const.R")

df_paper <- read_sheet(ss = GS_SHEET, sheet = "Original-paper",
                      na=c("na", "nr"))

df_online <- read_sheet(ss = GS_SHEET, sheet = "Original-online")
