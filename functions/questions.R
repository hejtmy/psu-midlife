library(stringr)


#' Returns the question's exact wording
#'
#' @param question_codes 
#'
#' @return
#' @export
#'
#' @examples
get_question_text <- function(question_codes){
  func <- function(question_code){
    question_data <- get_question_data(question_code)
    label <- gsub("[_]", "", question_data$label)
    label <- stringr::str_trim(label)
    return(label)
  }
  return(sapply(question_codes, func))
}

#' Returns what was the maximum value of the question options
#'
#' @param question_codes 
#'
#' @return
#' @export
#'
#' @examples
get_question_max_value <- function(question_codes){
  func <- function(question_code){
    question_data <- get_question_data(question_code)
    val <- sum(!is.na(select(question_data, starts_with("choices"))))
    val <- as.numeric(val)
    return(val)
  }
  return(sapply(question_codes, func))
}

#' Returns labels of the quetion options
#'
#' @param question_codes 
#'
#' @return
#' @export
#'
#' @examples
get_question_labels <- function(question_codes){
  func <- function(question_code){
    question_data <- get_question_data(question_code)
    vals <- select(question_data, starts_with("choices"))
    vals <- vals[!is.na(vals)]
    return(vals)
  }
  return(sapply(question_codes, func))
}

#' returns raw data from the quesiton JSON file
#'
#' @param question_codes 
#'
#' @return
#' @export
#'
#' @examples
get_question_data <- function(question_codes){
  if(!exists("QUESTIONS")){
    load_questions()
  }
  questions <- QUESTIONS$items[QUESTIONS$items$name %in% question_codes, ]
  if(nrow(questions) != 1) return(NULL)
  return(questions)
}

#' Loads the raw json data into QUESTIONS file and saves it in the .GlobalEnv
#'
#' @return
#' @export
#'
#' @examples
load_questions <- function(){
  QUESTIONS <<- jsonlite::fromJSON(file(here("data/MIDLIFE.json")))
}

#' Returns codes of valid questions (minus controls, summaries)
#'
#' @param questionnaire 
#' @param df_data 
#'
#' @return
#' @export
#'
#' @examples
get_question_codes <- function(questionnaire, df_data){
  cols <- select(df_data, matches(questionnaire), -contains("_s_"),
                 -ends_with("_cont")) %>%
    colnames(.)
  return(cols)
}
