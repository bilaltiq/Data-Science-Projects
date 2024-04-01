library(shiny)

#Define UI ---

ui <- fluidPage(
  titlePanel(strong("My Shiny App")),
  
  sidebarLayout(
    position = "left",
    sidebarPanel(span("Crete demographic maps with information from the
                      2010 US Census.", style = "color:gray", align = "right"),
                 br(),
                 strong("Choose a variable to display"),
                 selectInput("select", h3("Select box"),
                             choices = list("Percent White" = 1,
                                            "Percent Black" = 2,
                                            "Percent Hispanic" = 3,
                                            "Percent Asian" = 4)),
                 sliderInput("mySlider", h3("Range of Interest"),
                             min = 0, max = 100, value = c(0,100))
                 
                 
                 
      
      
      
    ),
    mainPanel(
              textOutput("selected_var"),
              textOutput("byrh")
              )
  )
  
  
  
)

#Define server logic --- 

server <- function(input, output){
  
  output$selected_var <- renderText({
    paste("You have selected this", input$select)
  })
  
  output$byrh <- renderText({
    paste("Your selected range is:", input$mySlider[1], "to",
          input$mySlider[2])
  })
  
}


#Run the app ---
shinyApp(ui = ui, server = server)

