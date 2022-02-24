library(lubridate)
library(tidyverse)
df_data <- readxl::read_xlsx("data/Copy of MIDLIFE 221121-notencrypted.xlsx", 
                             sheet="Sparovano")
str(df_data)

df_data$vek[is.na(as.numeric(df_data$vek))]

table(df_data$pohl)

TIME_FORMAT <- "%Y-%m-%d %H:%M:%S"

df_data <- df_data %>%
  mutate(vek = as.numeric(vek),
         pohl = recode(pohl, `1`="male", `2`="female", `3`="other"),
         created = ymd_hms(created),
         modified = ymd_hms(modified),
         ended = ymd_hms(ended),
         filling_duration_hours = interval(created, ended)/hours(1))
         
summary(df_data$filling_duration_hours)

## Uploads variables online
df_variables <- data.frame(variable = colnames(df_all))
write_sheet(df_variables, ss = GS_SHEET, sheet = "Question-categories")


# Quesitons getting ------
get_question_text(colnames(df_all)[grepl("panas", colnames(df_all))])

## Processing process ----
colnames(df_all)

df_all %>%
  mutate(cs_s_score = reversed(cs1, 6) + cs2 + reversed(cs3,6) + reversed(cs4, 6)) %>%
  select(starts_with("cs"))