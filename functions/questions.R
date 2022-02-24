library(stringr)

get_question_text <- function(question_codes){
  func <- function(question_code){
    question_data <- get_question_data(question_code)
    label <- gsub("[_]", "", question_data$label)
    label <- stringr::str_trim(label)
    return(label)
  }
  return(sapply(question_codes, func))
}

get_question_max_value <- function(question_codes){
  func <- function(question_code){
    question_data <- get_question_data(question_code)
    val <- sum(!is.na(select(question_data, starts_with("choices"))))
    return(val)
  }
  return(sapply(question_codes, func))
}

get_question_labels <- function(question_codes){
  func <- function(question_code){
    question_data <- get_question_data(question_code)
    vals <- select(question_data, starts_with("choices"))
    vals <- vals[!is.na(vals)]
    return(vals)
  }
  return(sapply(question_codes, func))
}

get_question_data <- function(question_codes){
  if(!exists("QUESTIONS")){
    load_questions()
  }
  questions <- QUESTIONS$items[QUESTIONS$items$name %in% question_codes, ]
  if(nrow(questions) != 1) return(NULL)
  return(questions)
}

load_questions <- function(){
  QUESTIONS <<- jsonlite::fromJSON(file("data/MIDLIFE.json"))
}
