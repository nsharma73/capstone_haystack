library(shiny)
library(shinydashboard)
library(dplyr)
library(googleway)



api_key <- "input keys"
clusters <-read.csv(file = '~/Desktop/Bootcamp/Capstone Project /Georgia_Clusters_final/cluster_output_5cls.csv', stringsAsFactors = F)



ui <- fluidPage(
  tags$h1("Clusters On Georgia Map"),
  fluidRow(
    column(
      width = 5,
      selectInput(inputId = "inputClusterNumber", label = "Select cluster:", multiple = TRUE, choices = sort(clusters$ClusterNumber),
                  selected = c("1", "2", "3", "4", "5"))
    ),
    column(
      width = 10,
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
      add_circles(lat = "latitude", lon = "longitude", mouse_over = "INFO",load_interval = 3, 
                  stroke_weight = 6, stroke_colour = "ClusterCategory",
                  legend = c(stroke_colour = T), 
                  legend_options = list(position = "TOP_RIGHT", css = "max-height: 125px;"))
    
  })
}

shinyApp(ui = ui, server = server)