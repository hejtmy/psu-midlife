library(stringr)

get_question <- function(question_code){
  if(!exists("QUESTIONS")){
    load_questions()
  }
  question <- QUESTIONS$items[QUESTIONS$items$name == question_code, ]
  if(nrow(question) != 1) return(NULL)
  label <- gsub("[_]", "", question$label)
  label <- stringr::str_trim(label)
  return(label)
}

load_questions <- function(){
  QUESTIONS <<- jsonlite::fromJSON(file("data/MIDLIFE.json"))
}

load_questions()