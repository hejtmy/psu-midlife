library(tidyverse)

## Recodes online varialbes -----
df_online <- df_online %>%
  filter(povol != "thank the formr monkey")

# Conversts data types after error rows are removed

df_online <- readr::type_convert(df_online)

## Creates renaming cols -------
# NEEDS to happen first, as we are modyfying the order of the columns later on
df_online <- select(df_online, ident, everything())
i_start <- which(colnames(df_online) == "e1")
online_colnames <- colnames(df_online[i_start:ncol(df_online)])
online_colnames <- online_colnames[!grepl("_cont", online_colnames)]
online_colnames <- online_colnames[!grepl("kont_", online_colnames)]

i_start <- which(colnames(df_paper) == "e01")
paper_colnames <- colnames(df_paper[i_start:ncol(df_paper)])
paper_colnames <- paper_colnames[!grepl("lcis_jine", paper_colnames)]

paper_rename_cols <- data.frame(orig = paper_colnames, new = online_colnames)


## ID ----- 
paper_rename_cols <- rbind(paper_rename_cols,
    c("id", "ident"),
    c("age1", "vek"),
    c("edu01", "vzdel"),
    c("edu02", "vzdel_roky"))

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
paper_rename_cols <- rbind(paper_rename_cols,
      c("relig01", "vira"),
      c("relig02", "cira_vyz"),
      c("relig03", "vira_zal"))

## family and partner ----
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

## bydlení ----
paper_rename_cols <- rbind(paper_rename_cols,
    c("home01", "byd_pok"),
    c("home02", "byd_vlast"),
    c("home03", "byd_osob"))

## kids ------
paper_rename_cols <- rbind(paper_rename_cols,
    c("kids01", "deti"),
    c("kids02", "deti_poc"))

## Renaming of paper data -----
renaming_func <- function(cols){
  out <- sapply(cols, function(x){
    if(x %in% paper_rename_cols$orig){
      return(paper_rename_cols$new[paper_rename_cols$orig == x])
    }
    return(x)
  })
  return(out)
}

df_paper <- df_paper %>%
  rename_with(renaming_func)


## paper preprocessing -----
df_paper <- df_paper %>%
  mutate(mar_len = as.character(mar_len),
         div_len = as.character(div_len),
         wid_len = as.character(wid_len),
         partner_vek = as.character(partner_vek),
         partner_vzd = as.double(partner_vzd),
         byd_pok = as.character(byd_pok),
         deti_poc = as.numeric(as.character(deti_poc)),
         deti_vek = paste0(kids02a, kids02b, kids02c, kids02d, collapse = ",")) %>%
  select(-matches("kids02[abcd]")) %>%
  mutate_at(vars(matches("da\\d")), ~as.double(as.character(.))) %>%
  mutate_at(vars(starts_with("lcis")), ~as.double(as.character(.)))

df_online <- df_online %>%
  mutate(byd_osob = as.double(byd_osob)) %>%
  mutate_at(vars(matches("da\\d")), ~as.double(as.character(.))) %>%
  mutate_at(vars(starts_with("lcis")), ~as.double(.))

df_all <- bind_rows(df_online, df_paper)
df_all$source <- ifelse(is.na(df_all$created), "paper", "online")

rm(df_paper, df_online, paper_rename_cols, i_start, online_colnames, paper_colnames)
