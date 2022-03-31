source("functions/process.R")
source("functions/fetch-online-data.R")
df_error <- fetch_error_data()
df_processed <- process_data(df_all, df_error)
dir.create("processed", showWarnings = FALSE)
write.table(df_processed, "processed/all-data-processed.csv", sep=";",
            row.names = FALSE)
