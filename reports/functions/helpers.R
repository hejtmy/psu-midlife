# Takes ls column in a pivoted table
add_ls_range <- function(df_pivoted){
  df_pivoted %>%
    mutate(name = str_remove(name, "ls")) %>%
    separate(name, c("ls_min", "ls_max"), "_")
}