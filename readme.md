## Setup

The scripts require `tidyverse`, `googlesheets4`, `here` packages to run
- You need to have access to the online sheet
- The scripts require the working directory to be set to the root of the project
- unless you are uploading new data, you do not need any other data files present


## Basic loading pipeline

The entire procedure (data loading, processing and saving) can be found in `scripts/buffer-data.R`.
In case you do not want to mess with the pipeline, you can simply source it to get your project ready.

```r
source("scripts/buffer-data.R")
```

This will create `df_all` and `df_question_categories` dataframes, make a folder `processed`
in your project and save the data there. You can simply load these files later

```r
df_all <- read.table("processed/all-data-raw.csv", sep=";", header=TRUE)
df_question_categories <- read.table("processed/question-categories.csv", sep=";", header=TRUE)
```

### Pipeline details
Data are saved in google sheets and fetched with the `fetch-data-` functions.

```r
source("functions/fetch-online-data.R")

df_online <- fetch_data_online()
df_paper <- fetch_data_paper()
```

These data frames be processed and merged using the `merge-paper-online-data.R` script,
which outputs `df_all` dataframe. This can be saved and loaded next time `df_all` is 
a semi edited file, basically just basic column renaming and class changes,
necessary to merge paper and online datasets.

```r
# If you have df_online and df_paper data loaded, you can call the following script
source("scripts/merge-paper-online-data.R")
```

## Preprocessing pipeline

New variables and recoding then happens in using functions in `functons/process.R` file.
These work only on the merged data!! They expect certain column names

```r
source("functions/process.R")
df_processed <- process_data(df_all)

## More granual
df_swls <- process_swls(df_all)
```

The processing is quite fast and can be run every time you run any script or start a day, 
but if you need to buffer the results, you can run `scripts/process-data.R`. This creates 
`df_processed` dataframe and saves in `all-data-processed.csv` file in a processed folder.

```r
source("scripts/process-data.R")
```