library(shiny)
library(leaflet)


ui <- fluidPage(
  titlePanel("Map of the World"),
  leafletOutput("map")
)
server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = -50, lat = 50, zoom = 1)
  })
  
  output$coords <- renderText({
    paste("Latitude:", input$map_click$lat, "\nLongitude", input$map_click$lng)
  })
}


shinyApp(ui, server)
