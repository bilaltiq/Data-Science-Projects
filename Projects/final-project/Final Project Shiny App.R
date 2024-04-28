library(shiny)
library(leaflet)
library(dplyr)
library(sf)

# Reading the dataset with countries and their corresponding coordinates and cases
COVIDCasesLatLong<- readRDS("Saved RDS Files/CountryCases.rds")

####################################

ui <- fluidPage(
  titlePanel("COVID Cases in each Country"),
  leafletOutput("map")
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
      addMarkers(~Longitude, ~Latitude, popup = ~paste("Country: ", Countries, "<br>Cases: ", Cases), 
                  icon = leaflet::makeIcon(
                  iconUrl = "Assets/icon.png",
                  iconWidth = 38, iconHeight = 38
                  ))
  })
  
  output$coords <- renderText({
    paste("Latitude:", input$map_click$lat, "\nLongitude", input$map_click$lng)
  })
}


shinyApp(ui, server)
