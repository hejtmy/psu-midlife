source("functions/process.R")
df_processed <- process_data(df_all)
dir.create("processed", showWarnings = FALSE)
write.table(df_processed, "processed/all-data-processed.csv", sep=";", row.names = FALSE)
