## Basic pipeline
Data are saved in google sheets and fetched with the get-online-data.R script.  The script load two dataframes, df_paper and df_online.

These can be processed and merged using the `process-data.R` script, which outputs `all-data.csv` file in a processed folder. 
These are semi edited files, basically just basic column renaming and class changes, necessary to merge paper and online datasets. 

New variables and recoding then happens in the `process-all.R` file. This creates `df_processed` dataframe and saves in `all-data-processed.csv` file in a processed folder

## Requirements
`tidyverse`, `googlesheets4`