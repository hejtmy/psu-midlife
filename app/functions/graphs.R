#' Title
#'
#' @param data processed data for the participants
#' @param question_code code for the question data to plot
#' @param split which variable to split the data on
#'
#' @return
#'
#' @examples
plot_question_results <- function(data, question_code, splitvar = "none"){
  if(splitvar != "none"){
    out <- plot_question_results_split(data, question_code, splitvar)
  } else {
    out <- plot_question_results_nosplit(data, question_code)
  }
  plt <- out$plot +
    geom_bar(aes(y=..prop..), position = position_identity()) +
    scale_y_continuous(labels = scales::label_percent()) +
    theme_classic() +
    labs(title = str_wrap(get_question_text(question_code), 60), y = "Proportion",
         x = "") +
    guides(fill = "none") +
    geom_vline(data = out$summary, aes(xintercept = value, linetype = name),
                color = "black", size = 1) +
    scale_linetype_manual(values=c("solid", "dashed"))
  return(plt)
}

plot_question_results_nosplit <- function(data, question_code){
  df_plt <- data %>%
    select(variable = all_of(question_code))
  
  df_sum <- df_plt %>%
    summarise(mean = mean(variable, na.rm=TRUE),
            median = median(variable, na.rm=TRUE)) %>%
    pivot_longer(cols=everything())
  
  plt <- ggplot(df_plt, aes(x = variable))
  return(list(plot = plt, summary = df_sum))
}

plot_question_results_split <- function(data, question_code, splitvar){
  df_plt <- data %>%
    select(variable = all_of(question_code),
           splitvar = all_of(splitvar))
  df_sum <- df_plt %>%
    group_by(splitvar) %>%
    summarise(mean = mean(variable, na.rm=TRUE),
              median = median(variable, na.rm=TRUE)) %>%
    pivot_longer(cols=-splitvar)
    
  plt <- ggplot(df_plt, aes(x = variable, fill = splitvar)) +
    facet_wrap(~splitvar, dir="v")
  return(list(plot = plt, summary = df_sum))
} 