#' Adds happiness pca score to the data
#'
#' @description This builds a PCA model with swls_satisfaction, hedonic, cesd and pwb total scores.
#' Missing values are replaced with median values for the PCA analysis
#' @param df_report data to be modified. Need to have the necessary scores
#'
#' @return same dataframe with pca_happiness score column
#' @export
#'
#' @examples
add_happiness_pca <- function(df_data){
  df_happiness_scores <- df_data %>%
    select(swls_s_satifaction, panas_s_hedonic, cesd_s_total, pwb_s_total) %>%
    mutate(across(everything(), ~replace_na(.x, median(.x, na.rm = TRUE))))
  pca_happiness <- prcomp(df_happiness_scores[complete.cases(df_happiness_scores),],
                          center = TRUE,scale. = TRUE)
  df_data$pca_happiness <- NA
  df_data[complete.cases(df_happiness_scores),]$pca_happiness <- pca_happiness$x[, 1]
  return(df_data)
}
