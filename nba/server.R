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
library(shinydashboard)
library(ggplot2)
library(RCurl)
library(grid)
library(jpeg)
library(hexbin)


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
    
    season <- switch(
      as.integer(input$season),
      1,
      2, 
      3, 
      4
    )
    
    chart <- switch(
      as.integer(input$chart), 
      "a",
      "b", 
      "c"
    )
  
    
    df.player <- shotDataf[[player]][[season]]
    
    resp <- list(df.player, chart)
    resp
  })

  
  

    output$shotChart <- renderPlot({

      if(nba_reactive()[[2]] == "a"){


      #generate plot from input$playerID from ui.R
      data <- nba_reactive()[[1]]

    #ggplot of made vs missed shots (without court for the moment)
      ggplot(data, aes(x=LOC_X, y=LOC_Y)) +
        geom_point(aes(colour = EVENT_TYPE))

      } else if(nba_reactive()[[2]] == "b"){
      
       # half court image
        data <- nba_reactive()[[1]]
        courtImg.URL <- "https://thedatagame.files.wordpress.com/2016/03/nba_court.jpg"
        court <- rasterGrob(readJPEG(getURLContent(courtImg.URL)),
                   width=unit(1,"npc"), height=unit(1,"npc"))
    
        # plot using NBA court background and colour by shot zone
        ggplot(data, aes(x=LOC_X, y=LOC_Y)) +
          annotation_custom(court, -250, 250, -50, 420) +
          geom_point(aes(colour = SHOT_ZONE_BASIC, shape = EVENT_TYPE)) +
          xlim(250, -250) +
          ylim(-50, 420) +
          # geom_rug(alpha = 0.2) +
          # coord_fixed() +
          ggtitle(paste("Shot Chart\n", unique(data$PLAYER_NAME), sep = "")) +
          theme(line = element_blank(),
                axis.title.x = element_blank(),
                axis.title.y = element_blank(),
                axis.text.x = element_blank(),
                axis.text.y = element_blank(),
                legend.title = element_blank(),
                plot.title = element_text(size = 15, lineheight = 0.9, face = "bold"))
        


        } else if (nba_reactive()[[2]] == "c"){

          data <- nba_reactive()[[1]]
          courtImg.URL <- "https://thedatagame.files.wordpress.com/2016/03/nba_court.jpg"
          court <- rasterGrob(readJPEG(getURLContent(courtImg.URL)),
                              width=unit(1,"npc"), height=unit(1,"npc"))

          # plot shots using ggplot, hex bins, NBA court backgroung image.
          ggplot(data, aes(x=LOC_X, y=LOC_Y)) + 
            annotation_custom(court, -250, 250, -52, 418) +
            stat_binhex(bins = 25, colour = "gray", alpha = 0.7) +
            scale_fill_gradientn(colours = c("yellow","orange","red")) +
            guides(alpha = FALSE, size = FALSE) +
            xlim(250, -250) +
            ylim(-52, 418) +
            #for resizing
            # geom_rug(alpha = 0.2) +
            # coord_fixed() +
            ggtitle(paste("Shot Chart\n", unique(data$PLAYER_NAME), sep = "")) +
            theme(line = element_blank(),
                  axis.title.x = element_blank(),
                  axis.title.y = element_blank(),
                  axis.text.x = element_blank(),
                  axis.text.y = element_blank(),
                  legend.title = element_blank(),
                  plot.title = element_text(size = 17, lineheight = 1.2, face = "bold"))
          
          
          }#close else if statement
     })
    
  
    
    
    
    
  
})
