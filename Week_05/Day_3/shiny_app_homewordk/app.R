library(tidyverse)
library(shiny)
library(shinythemes)

winners <- read_csv("data/winners.csv")

# Aim - to produce a simple look up to show what film won best 
# picture by decade


ui <- fluidPage(
  
  theme = shinytheme("united"),
  titlePanel(tags$h1("Best Picture Winners")),
  
  sidebarLayout(
    sidebarPanel((tags$h4("Make your selection")),
                 HTML("<br>"),    
                 selectInput("decade_input",
                              "Which Decade?",
                              choices = c("1920s", "1930s", "1940s", "1950s",
                                          "1960s", "1970s", "1980s", "1990s",
                                          "2000s", "2010s")
                 ),
                 
                 radioButtons("category_input",
                              "Which Category?",
                              choices = c("Best Film", "Best Actress", 
                                          "Best Actor")
                 )
    ),
    
    mainPanel(
      renderTable("film_table")
    )
  )
)

server <- function(input, output) {
  
  output$film_table <- renderTable({
   winners %>%
      filter(decades == input$decade_input) %>%
      filter(category == input$category_input) %>% 
      table(winners$entity, list(winners$decade_input))
    
  })
  
}

shinyApp(ui = ui, server = server)




