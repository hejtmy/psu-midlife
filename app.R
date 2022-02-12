library(shiny)
library(tidyverse)
source("app/components/sidebar.R")
source("functions/questions.R")
source("process-all.R")

df_question_categories <- read.table("processed/question-categories.csv", sep=";", header=TRUE)
df_all <- read.table("processed/all-data.csv", sep=";", header=TRUE)
df_all <- process_data(df_all)

df_all <- df_all %>%
  filter(pohl != "O",
         vzdel != "elementary")

split_vars <- c("pohl", "vzdel")

ui <- shinyUI(fluidPage(
  navbarPage(
    windowTitle = "Midlife EDA",
    title = "Midlife EDA",
    collapsible = TRUE,
    
    tabPanel(title = "EDA",
             icon = icon("edit"),
             fluidRow(
               column(
                width = 12,
                sidebarLayout(
                  appSidebarPanel(df_question_categories, split_vars),
                  mainPanel(
                    uiOutput('univariate_plots'),
                    width = 10
                    ))
             )))
  )
))

server <- function(input, output,session) {
  rv <- reactiveValues()
  
  observe({
    rv$question_names <- filter(df_question_categories,
                             category == input$question_category) %>% 
      pull(variable)
    dat <- select(df_all, any_of(split_vars),
                  any_of(rv$question_names))
    rv$data_filtered <- dat
  })
  
  observeEvent(rv$data_filtered, {
    uniPlot <- lapply(rv$question_names, function(col_i){
      if(!is.numeric(rv$data_filtered[[col_i]])) return(NULL)
      if(input$split_variable == "none"){
        plt <- ggplot(rv$data_filtered, aes_string(x=col_i)) +
          geom_bar(aes(y=..prop..), position = position_identity()) +
          scale_y_continuous(labels = scales::label_percent())
      } else {
        plt <- ggplot(rv$data_filtered, aes_string(x=col_i, fill = input$split_variable)) + 
          geom_boxplot()
      }
      plt <- plt + 
        theme_classic() +
        labs(title = str_wrap(get_question(col_i), 60)) +
        ylab("Proportion")
      return(plt)
    })
    
    uniPlot <- uniPlot[!sapply(uniPlot, is.null)]
    
    output$univariate_plots <- renderUI({
      plot_output_list <- lapply(seq_along(1:length(uniPlot)), function(plot_i){
        column(width = 4,
               tags$div(style = "margin-top: 10px; margin-bottom: 10px;",
                        plotOutput(outputId = paste0("uni_", plot_i))
               ))
      })
      do.call(tagList, plot_output_list)
    })
    
    rv$uniPlot <- uniPlot
  })
  
  observeEvent(rv$uniPlot, {
    lapply(seq_along(1:length(rv$uniPlot)), function(plot_i) {
      output[[paste0("uni_", plot_i)]] <- renderPlot({
        rv$uniPlot[[plot_i]]
      })
    })
  }, ignoreInit = FALSE)
  
}

shinyApp(ui, server)
