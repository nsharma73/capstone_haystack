library(shiny)
library(shinydashboard)
library(shinythemes)
library(dplyr)
library(googleway)




api_key <- "input your keys"
clusters <-read.csv(file = '~/Desktop/Bootcamp/Capstone Project /Georgia_Clusters_final/cluster_output_5cls.csv', stringsAsFactors = F)



ui <- fluidPage(
  theme = shinytheme("cerulean"),
  tags$h1(strong("Clusters On Georgia Map")),
  fluidRow(
    sidebarPanel(
      br(),
      width = 3,
      selectInput(inputId = "inputClusterNumber", label = "Select cluster:", multiple = TRUE, choices = sort(clusters$ClusterNumber),
                  selected = c("1", "2", "3", "4", "5")),
      br(),
      h4("info box includes:"),
      p("\ - cluster, zestimate"),
      p("\ - address"),
      p("\ - city, zip code"),
      br()
    ),
    mainPanel(
      width = 9,
      google_mapOutput(outputId = "map", width = "100%", height = "800px")
    )
  )
)

server <- function(input, output) {
  
  data <- reactive({
    clusters %>%
      filter(ClusterNumber %in% input$inputClusterNumber) %>%
      mutate(INFO = paste0(ClusterNumber, " | ", zestimate,
                           br(),
                           address, 
                           br(),
                           city, ", ", zip))
  })
  
  
  
  output$map <- renderGoogle_map({
    google_map(data = data(), key = api_key) %>%
      add_circles(lat = "latitude", lon = "longitude", mouse_over = "INFO",load_interval = 3, 
                  stroke_weight = 6, stroke_colour = "ClusterNumber", 
                  legend = T, 
                  legend_options = list(position = "RIGHT_BOTTOM", css = "max-height: 125px;", title = "Cluster Category"),
                  update_map_view = T)
    
  })
}

shinyApp(ui = ui, server = server)
