library(tidyverse)
library(shiny)
library(shinythemes)

winners <- read_csv("data/winners.csv",col_types = cols(decades = "c"))

# Aim - to produce a simple look up to show what film won best 
# picture by decade


ui <- fluidPage(
  
  theme = shinytheme("darkly"),
  titlePanel(tags$h1("Best Picture Winners")),

  fluidRow(
    
    column(6, radioButtons("category_input",
                           "Category",
                           choices = unique(winners$winning_category),
                           inline = TRUE
          )
    ),
    
    column(6, selectInput(
                        inputId = "decades_input",
                        label = "Which Decade?",
                        choices = unique(winners$decades)
            )
        )
    
  ),
  # ---------------------------------
  # ADD AN ACTION BUTTON
  
  actionButton("update","Update Dashboard"),


  # -------------------------------------
  # TABLE
  
  DT::dataTableOutput("table_output")
  
)  
  
# Define server logic required to draw a histogram
server <- function(input, output) {
  
  #NEED A BUTTON THAT IT WAITS FOR
  filtered_data <- eventReactive(input$update, {
   winners %>% 
      filter(winning_category == input$category_input) %>% 
      filter(decades == input$decades_input) %>% 
      select(year, entity)
  })
  
# Create the data table
  output$table_output <- DT::renderDataTable({
    filtered_data() 
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)