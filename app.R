library(shiny)
library(tidyverse)
source("app/components/sidebar.R")
source("functions/questions.R")

df_question_categories <- read.table("processed/question-categories.csv", sep=";", header=TRUE)
df_all <- read.table("processed/all-data.csv", sep=";", header=TRUE)

ui <- shinyUI(fluidPage(
  navbarPage(
    windowTitle = "Automated EDA",
    title = "Automated EDA",
    collapsible = TRUE,
    
    tabPanel(title = "EDA",
             icon = icon("edit"),
             fluidRow(
               column(
                width = 12,
                sidebarLayout(
                  appSidebarPanel(df_question_categories),
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
    question_names <- filter(df_question_categories,
                             category == input$question_category) %>% 
      pull(variable)
    dat <- select(df_all, any_of(question_names))
    dat <- select_if(dat, is.numeric)
    rv$data_filtered <- dat
  })
  
  observeEvent(rv$data_filtered, {
    uniPlot <- lapply(names(rv$data_filtered), function(col_i){
      ggplot(rv$data_filtered, aes_string(x=col_i)) + 
        geom_bar(aes(y=..prop..)) +
        theme_classic() +
        scale_y_continuous(labels = scales::label_percent()) +
        labs(title = str_wrap(get_question(col_i), 60)) +
        ylab("Proportion")
    })
    
    output$univariate_plots <- renderUI({
      plot_output_list <- lapply(seq_along(1:length(uniPlot)),function(plot_i){
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
