library(shiny)
library(leaflet)
library(dplyr)
library(sf)

# Reading the dataset with countries and their corresponding coordinates and cases
COVIDCasesLatLong <- readRDS("Saved RDS Files/CountryCases.rds")


####################################

ui <- fluidPage(
  titlePanel("COVID Cases Per Country by the end of 2020"),
  leafletOutput("map"),
  plotOutput("linePlot")
)


server <- function(input, output, session) {
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = -50, lat = 50, zoom = 2)
  })
  
  observe({
    leafletProxy("map", data = COVIDCasesLatLong) %>%
      addProviderTiles("CartoDB.Voyager") %>%
      clearMarkers() %>%
      addCircleMarkers(~Longitude, ~Latitude, radius = 10, color = "red", fillOpacity = 0.5, 
                       popup = ~paste("Country: ", Countries, "<br>Cases: ", Cases))
  })
  
}


shinyApp(ui, server)
