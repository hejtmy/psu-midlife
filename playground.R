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


df_data %>%
  filter(filling_duration_hours < 48) %>%
  ggplot(aes(filling_duration_hours)) + geom_histogram()

df_data %>%
  filter(filling_duration_hours < 48) %>%
  mutate(month_year_finished = format_ISO8601(ended, precision = "ym")) %>%
  group_by(month_year_finished) %>%
  count()

## 
table(is.na(df_data$ended))

## 
df_data$created[1:10]

## 
ggplot(df_data, aes(vek, fill=pohl)) + 
  geom_histogram() +
  facet_wrap(~pohl)


## Uploads variables online
df_variables <- data.frame(variable = colnames(df_all))
write_sheet(df_variables, ss = GS_SHEET, sheet = "Question-categories")


# 
get_question(colnames(df_all)[grepl("panas", colnames(df_all))])

                              