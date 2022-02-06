df_all$pohl <- recode(df_all$pohl, `1`="F", `2`="M", `3`="O")
df_all$pohl <- ifelse(df_all$source == "paper", df_all$gender, df_all$pohl)
df_all$gender <- NULL
