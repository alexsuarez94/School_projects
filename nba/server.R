#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
#    https://gist.github.com/Ray901/656f4314d00a7b00a05f#file-ui-r-L14


# http://www.gregreda.com/2015/02/15/web-scraping-finding-the-api/

library(shiny)



# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  
  #inside the reactive part should be all the preprocesing and the source to other codes, 
  #then i should just create plot and boxes. 
  nba_reactive <- reactive({
    
    player <- switch(
      as.integer(input$playerID),
      1,
      2
    )
  
    df.player <- shotDataf[[player]][[1]]
    
    resp <- list(df.player)
    resp
  })

  
  output$shotChart <- renderPlot({
    
    # generate plot from input$playerID from ui.R
    x <- as.integer(input$playerID)
    data <- nba_reactive()[[1]]
    
    #ggplot of made vs missed shots (without court for the moment)
    ggplot(data, aes(x=LOC_X, y=LOC_Y)) +
      geom_point(aes(colour = EVENT_TYPE))
  
  })
  
})
