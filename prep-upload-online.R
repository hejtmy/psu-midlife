library(tidyverse)
library(googlesheets4)
source("const.R")

df_online <- read_csv("data/MIDLIFE.csv")
SENSITIVE_COLS <- c("naroz", "kont_jmeno", "kont_tel", "kont_mail", "kont_adr")

## Gets column names to be renamed
# NEEDS to happen first, as we are modyfying the order of the columns later on
i_start <- which(colnames(df_online) == "e1")
online_colnames <- colnames(df_online[i_start:ncol(df_online)])
online_colnames <- online_colnames[!grepl("_cont", online_colnames)]
online_colnames <- online_colnames[!grepl("kont_", online_colnames)]

i_start <- which(colnames(df_paper) == "e01")
paper_colnames <- colnames(df_paper[i_start:ncol(df_paper)])
paper_colnames <- paper_colnames[!grepl("lcis_jine", paper_colnames)]

paper_rename_cols <- data.frame(orig = paper_colnames, 
                                new = online_colnames)

## Deals with sensitive information ----
df_sensitive <- df_online %>%
  select(session, all_of(SENSITIVE_COLS))
df_online <- df_online %>%
  select(-all_of(SENSITIVE_COLS))

df_online_rekrutace <- read_csv("data/REKR_MIDLIFE.csv")

df_online <- df_online %>%
  left_join(select(df_online_rekrutace, session, ident), by = "session")

## Recoding povolani ------
df_online <- df_online %>%
  mutate(occup_stable = grepl("1", zamest),
         occup_freelance = grepl("2", zamest),
         occup_unemployed = grepl("3", zamest),
         occup_socialwelfare = grepl("4", zamest))

paper_rename_cols <- rbind(paper_rename_cols, 
  c("occup01a", "occup_stable"),
  c("occup01b", "occup_freelance"), 
  c("occup01c", "occup_unemployed"),
  c("occup01d", "occup_socialwelfare"))

## Relig -----
paper_rename_cols <- rbind(rename_cols,
      c("relig01", "vira"),
      c("relig02", "cira_vyz"),
      c("relig03", "vira_zal"))

## family ----
df_online <- df_online %>%
  mutate(family_single = grepl("1", rodina),
         family_relationship = grepl("2", rodina),
         family_married = grepl("3", rodina),
         family_divorced  = grepl("4", rodina),
         family_widowed  = grepl("5", rodina))

paper_rename_cols <- rbind(paper_rename_cols,
      c("family01", "family_single"),
      c("family02", "family_relationship"),
      c("family03", "family_married"),
      c("family04", "family_divorced"),
      c("family05", "family_widowed"),
      c("family03a", "mar_len"),
      c("family04a", "div_len"),
      c("family05a", "wid_len"))

paper_rename_cols <- rbind(paper_rename_cols,
    c("partner01", "partner_vek"),
    c("partner02", "partner_pov"),
    c("partner03", "partner_vzd"))

## bydlení ---
paper_rename_cols <- rbind(paper_rename_cols,
    c("home01", "byd_pok"),
    c("home02", "byd_vlast"),
    c("home03", "byd_osob"))

## kids ------
paper_rename_cols <- rbind(paper_rename_cols,
    c("kids01", "deti"),
    c("kids02", "deti_poc"))


## Renaming of paper data -----

df_paper %>%
  rename_with(function(x){
    if(x %in% paper_rename_cols$orig){
      return(paper_rename_cols$new[paper_rename_cols$orig == x])
    }
    return(x)
  })

colnames(df_online)[1:40]
colnames(df_paper)[1:40]
df_paper_names <- df_paper %>%
  select(
         -starts_with("kids"),
         -c(1, 3:9),
         -contains("lcis_jine"))
head(colnames(df_paper_names), 20)

df_online_names <- df_online %>%
  select(-c(1:5), 
         -starts_with("vira"),
         -starts_with("deti")) %>%
  select(ident, ## shifts ident tot he first positions
         everything()) %>%
  select(-ends_with("_cont"))
head(colnames(df_online_names), 20)

df_names <- data.frame(online_names = colnames(df_online_names),
                       paper_names = colnames(df_paper_names))
View(df_names)
write_sheet(df_names, ss=GS_SHEET, sheet = "nazvy-sloupcu")
## -------


TEMP_SHEET_NAME <- "online-original-temp"

write_sheet(df_online, ss = GS_SHEET, sheet = TEMP_SHEET_NAME)

