source("functions/process.R")
source("functions/fetch-online-data.R")
df_error <- fetch_error_data()
df_processed <- process_data(df_all, df_error)
dir.create("data/processed", showWarnings = FALSE)
write.table(df_processed, "data/processed/all-data-processed.csv",
            sep=";", row.names = FALSE)
