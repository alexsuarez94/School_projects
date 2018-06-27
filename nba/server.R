#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  
  #inside the reactive part should be all the preprocesing and the source to other codes, 
  #then i should just create plot and boxes. 
  nba_reactive <- reactive({
    
     source("nba_shot_stats.R")
    
    player <- switch(
      as.integer(input$playerID),
      1,
      2
    )
    
    # season <- switch(
    #   as.integer(input$season),
    #   1,
    #   2
    # )
    
    #df.player <- shotDataf[[player]][[season]]
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
