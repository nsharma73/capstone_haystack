library(shiny)
library(shinydashboard)
library(dplyr)
library(googleway)



api_key <- "Input your key"
clusters <-read.csv(file = '~/Desktop/Bootcamp/Capstone Project /Georgia_Clusters_final/cluster_output_5cls.csv', stringsAsFactors = F)



ui <- fluidPage(
  tags$h1("Clusters On Georgia Map"),
  fluidRow(
    column(
      width = 3,
      selectInput(inputId = "inputClusterNumber", label = "Select cluster:", multiple = TRUE, choices = sort(clusters$ClusterNumber),
                  selected = "1")
    ),
    column(
      width = 9,
      google_mapOutput(outputId = "map")
    )
  )
)

server <- function(input, output) {
  
  data <- reactive({
    clusters %>%
      filter(ClusterNumber %in% input$inputClusterNumber) %>%
      mutate(INFO = paste0(ClusterNumber, " | ", city, ", ", zip))
  })
  output$map <- renderGoogle_map({
    google_map(data = data(), key = api_key) %>%
      add_circles(lat = "latitude", lon = "longitude", mouse_over = "INFO", stroke_colour = "ClusterCategory", 
                    stroke_weight = 6, load_interval = 3)
    
  })
}

shinyApp(ui = ui, server = server)
