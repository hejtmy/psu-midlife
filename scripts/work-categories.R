source("functions/fetch-online-data.R")
df_online_edited <- fetch_data_online_edited()
df_paper_edited <- fetch_data_paper_edited()

occup <- c(df_paper_edited$occup_kategorie, df_paper_edited$partner02_kategorie,
           df_online_edited$povol_kategorie, df_online_edited$partner_pov_kategorie)

occup<-paste0(occup, collapse=", ")
occup <- strsplit(occup, ", ")[[1]]
unique(occup)
df_occup <- as.data.frame(table(occup))

sheet_write(df_occup, ss=GS_SHEET, sheet = "occupation-categories")

