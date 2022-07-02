#' Returns table for a particular questionnaire
#'
#' @param data 
#' @param code 
#' @param include_summaries 
#'
#' @return
#' @export
#'
#' @examples
get_data_questionnaire <- function(df_data, code, raw = TRUE,
                                   summaries = TRUE){
  if(!raw & !summaries){
    warning("no data is returned")
    return(NULL)
  }
  if(summaries & !raw) return(select(df_data, ident, contains(paste0(code, "_s_"))))
  df_questionnaire <- select(df_data, ident, contains(code), -contains("_cont"))
  if(raw & summaries) return(df_questionnaire)
  return(select(df_questionnaire, -contains("_s_")))
}

get_demographic_data <- function(df_data){
  select(df_data, ident, vek, pohl, vzdel)
}