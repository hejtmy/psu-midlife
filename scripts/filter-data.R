filter_processed <- function(df_processed){
  

## Weird age
df_processed <- df_processed %>%
  filter(age > 30)

}