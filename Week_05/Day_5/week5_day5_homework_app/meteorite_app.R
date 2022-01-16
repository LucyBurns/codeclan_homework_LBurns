library(tidyverse)
library(janitor)
library(stringr)
library(here)
library(shinythemes)

meteorites <- read_csv(here("data/meteorites.csv"))

meteorites <- meteorites %>% 
  mutate(pre_1900 = case_when(
    (year < 1900) ~ "before 1900",
    TRUE  ~ "1900 or later"))

meteorites <- meteorites %>% 
  mutate(mass_group = case_when(
    (mass_g < 1000000) ~ "1mn +",
    TRUE  ~ "less than 1mn"))

# Create plots of the meteorite data

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  theme = shinytheme("darkly"),
  titlePanel("Meteorites"),
  
# ---------------------------------

  fluidRow(
    
    column(4, selectInput(
      inputId = "size_input",
      label = "Size of Meteorite (g)",
      choices = unique(meteorites$mass_group)
         )
      ),
           
     column(4, radioButtons("year_input",
                           "Year",
                           choices = unique(meteorites$pre_1900),
                           inline = TRUE
         )
      ),
    
    column(4,
           actionButton("update",
                        "Update Dashboard")
           
      )
),
  
  # -------------------------------------
  # ADD IN A ROW HERE WITH LAT AND LONG PLOTS
  
  fluidRow(
    
    column(6,plotOutput("latitude_output")
           
          ),
    
    column(6,plotOutput("longitude_output")
          )
      ),

# -------------------------------------
# ADD IN A ROW HERE WITH COMBINED PLOT

  fluidRow( 
    tags$br(),
    column(12,plotOutput("combined_output")
          )
      )
    )

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  #NEED A BUTTON THAT IT WAITS FOR
  filtered_data <- eventReactive(input$update, {
    meteorites %>% 
      filter(pre_1900 == input$year_input) %>% 
      filter(mass_group == input$size_input)
  })

  # Make a latitude plot
  output$latitude_output <- renderPlot({
    filtered_data() %>% 
      ggplot() + 
      aes(x=year, y=latitude, size = mass_g) +
      geom_point(alpha=0.5, colour = "seagreen") +
      labs(
        x = "\nYear of Fall",
        y = "Latitiude",
        title = "Size of Meteorites",
        subtitle = "(by year and latitude)\n"
      ) +
      theme(legend.position = "none")
  })
  
  # Make a longitude plot
  output$longitude_output <- renderPlot({
    filtered_data() %>% 
      ggplot() + 
      aes(y=year, x=longitude, size = mass_g) +
      geom_point(alpha=0.5, colour = "steelblue") +
      labs(
        x = "\nLongitude",
        y = "Year",
        title = "Size of Meteorites",
        subtitle = "(by year and longitude)\n"
      ) +
      theme(legend.position = "none") 
  })
  
  # Make a longitude plot
  output$combined_output <- renderPlot({
    filtered_data() %>% 
      ggplot() +
      aes(y=latitude, x=longitude, size = mass_g) +
      geom_point(alpha=0.7, colour = "red") +
      labs(
        x = "Latitude",
        y = "Longitude",
        title = "Size of Meteorites",
        subtitle = "(by latitude and longitude)\n"
      ) +
      theme(legend.position = "none") 
  })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

