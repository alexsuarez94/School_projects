# 
 # library(shiny)
 # library(shinydashboard)
# library(ggplot2)
# library(RCurl)
# library(grid)
# library(jpeg)
# library(hexbin)
# library(plyr)
# library(shinyjs)
# library(gridExtra)
# library(rjson)
# library(jsonlite)

#library(rvest)

list.of.packages <- c("ggplot2", "shiny", "shinydashboard", "RCurl", "grid", "jpeg", 
                      "hexbin", "plyr", "shinyjs", "gridExtra", "rjson", "jsonlite", "rvest", "dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only = TRUE)


source("data/nba_shot_stats.R")

ui <- dashboardPage(
  
  
  
  dashboardHeader(title = "NBA shot analytics"),
  
  
  
  #Sidebar content
  dashboardSidebar(
    selectInput("playerID", "Select a player:", choices = list("Lebron James" = 1, "James Harden" = 2, "Stephen Curry" = 3, "Kevin Durant" = 4), selected = 1),
    selectInput("season", "Select a season", choices = list("2014-15" = 1, "2015-16" = 2, "2016-17" = 3, "2017-18" = 4), selected = 4),
    selectInput("chart", "Select shotChart", choices = list("Distances Histogram" = 1, "Shots by Zone" = 2, "Distance Chart" = 3, "Accuracy Chart" = 4), selected = 1)
    
  ), #close dashboard sidebar
  
  dashboardBody(
    
    useShinyjs(),
    tags$head(
      
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    
    
    fluidRow(
      box(status = "primary", plotOutput("shotChart"), width = 8, solidHeader = T),
      box(status = "primary", imageOutput("myImage"), width = 4, align = "center", height = 200, solidHeader = T)
      , 
      
      box(status = "primary", width = 4, solidHeader = T, tableOutput("wiki_bio"))  
      
    ), #close fluid Row
    
    
    fluidRow(
      
      box(status = "primary", title = "Season statistics", width = 8, 
          
          tableOutput("table"))
      ,
      box( heigth = 200, width = 4, title = "More details",  textOutput("bio"), solidHeader = T)
      
      
      
    ) #close fluidRow
    
  ) #close dashboardbody
  
  
) #close dashboardPage 



#=======================================

#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  
  #inside the reactive part should be all the preprocesing and the source to other codes, 
  #then i should just create plot and boxes. 
  nba_reactive <- reactive({
    
    player <- switch(
      as.integer(input$playerID),
      1,
      2,
      3,
      4
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
      "c",
      "d"
    )
    
    
    
    df.player <- shotDataf[[player]][[season]]
    
    resp <- list(df.player, chart, player)
    resp
  })
  
  output$wiki_bio <- renderTable(
    
    
    
    #This is where the image is set
    if(nba_reactive()[[3]] == 1){
      
      load("data/lbj_bio.RData")
      lbj_bio
      
    }
    else if(nba_reactive()[[3]] ==  2){
      
      load("data/hrd_bio.RData")
      hrd_bio
    }
    else if(nba_reactive()[[3]] ==  3){
      load("data/stp_bio.RData")
      stp_bio
    }
    else if(nba_reactive()[[3]] ==  4){
      load("data/dur_bio.RData")
      dur_bio
    }
    
  )
  
  output$bio <- renderText({
    
    #This is where the image is set 
    if(nba_reactive()[[3]] == 1){            
      
      "LeBron Raymone James (born December 30, 1984) is an American 
      basketball player with the Los Angeles Lakers. James first garnered national 
      attention as the top high school basketball player in the country. 
      With his unique combination of size, athleticism and court vision, 
      he became a four-time NBA MVP.  After leading the Miami Heat to titles in
      2012 and 2013, James returned to Cleveland and helped the franchise claim 
      its first championship in 2016."
      
    }                                        
    else if(nba_reactive()[[3]] ==  2){
      "Born in 1989 in Los Angeles, California, basketball star James Harden
      is known as much for his prominent beard as he is for his stellar play.
      The No. 3 pick in the 2009 NBA draft, he began his career with the Oklahoma
      City Thunder, before a stunning trade to the Houston Rockets in 2012.
      Harden has since emerged as a perennial MVP candidate, thanks in part to
      the sort of play that produced a record-setting 60-point triple-double in January 2018."
    }
    else if(nba_reactive()[[3]] ==  3){
      "Wardell Stephen Curry II (born March 14, 1988), better known as Stephen Curry,
      is a professional American basketball player with the Golden State Warriors. The son 
      of former NBA player Dell Curry, Stephen first garnered national attention for his 
      impressive play at Davidson College. He was drafted in 2009 by Golden State and eventually
      developed into one of pro basketball's top players with his stellar shooting skills."
    }
    else if(nba_reactive()[[3]] ==  4){
      "Born on September 29, 1988 in Suitland, Maryland, just outside of Washington, D.C., 
      Kevin Wayne Durant is a high-profile professional basketball player. After playing 
      college basketball for only one season at the University of Texas, Austin, he was 
      chosen second overall in the first round of the 2007 NBA draft by the Seattle SuperSonics. 
      Durant is a three-time NBA All-Star and three-time NBA scoring champion. In 2017, he helped 
      lead the Warriors to another NBA championship, defeating the Cleveland Cavaliers."
    }
    
    })
  
  output$myImage <- renderImage({ 
    
    
    
    #This is where the image is set 
    if(nba_reactive()[[3]] == 1){            
      list(src = "images/lebron.png", alt = "Face")
    }                                        
    else if(nba_reactive()[[3]] ==  2){
      list(src = "images/harden.png", alt = "Face")
    }
    else if(nba_reactive()[[3]] ==  3){
      list(src = "images/curry.png", alt = "Face")
    }
    else if(nba_reactive()[[3]] ==  4){
      list(src = "images/durant.png", alt = "Face")
    }
  }, deleteFile = FALSE) #close image, no se ven por el momento
  
  
  
  
  output$shotChart <- renderPlot({
    
    if(nba_reactive()[[2]] == "a"){
      
      source("ggplot_func/theme_black_ggplot.R")
      
      #generate plot from input$playerID from ui.R
      data <- nba_reactive()[[1]]
      
      ggplot(data, aes((data$SHOT_DISTANCE/3.28084))) + 
        geom_histogram(col = "skyblue", aes(fill = ..count..)) +
        labs(x="Distance (m)", y="Count") + 
        ggtitle(paste("Shot Distances Chart\n", unique(data$PLAYER_NAME), sep = "")) +
        theme_black()
      
    } else if(nba_reactive()[[2]] == "b"){
      
      source("ggplot_func/theme_black_ggplot.R")
      
      data <- nba_reactive()[[1]]
      # half court image
      court <- rasterGrob(readJPEG("images/court3.jpeg"),
                          width=unit(1,"npc"), height=unit(1.2,"npc"))
      
      # plot using NBA court background and colour by shot zone
      ggplot(data, aes(x=LOC_X, y=LOC_Y)) +
        annotation_custom(court, -250, 250, -50, 420) +
        geom_point(aes(colour = SHOT_ZONE_BASIC, shape = EVENT_TYPE), size = 2.5) +
        xlim(250, -250) +
        ylim(-50, 420) + 
        ggtitle(paste("Shot Chart\n", unique(data$PLAYER_NAME), sep = "")) +
        theme_black()
      
      
      
    } else if (nba_reactive()[[2]] == "c"){
      
      
      source("ggplot_func/theme_black_ggplot.R")
      
      data <- nba_reactive()[[1]]
      
      data <- data[which(!data$SHOT_ZONE_BASIC=='Restricted Area'), ]
      
      court <- rasterGrob(readJPEG("images/court3.jpeg"),
                          width=unit(1,"npc"), height=unit(1.2,"npc"))
      
      # plot shots using ggplot, hex bins, NBA court backgroung image.
      ggplot(data, aes(x=LOC_X, y=LOC_Y)) + 
        annotation_custom(court, -250, 250, -52, 418) +
        stat_binhex(bins = 35, colour = "black", alpha = 0.8) +
        scale_fill_gradientn(colours = c("yellow", "darkgoldenrod1","orange", "orangered4","red", "darkred", "black")) +
        guides(alpha = FALSE, size = FALSE) +
        xlim(250, -250) +
        ylim(-52, 418) +
        ggtitle(paste("Shot Chart\n", unique(data$PLAYER_NAME), sep = "")) +
        theme_black()
      
      
    } else if (nba_reactive()[[2]] == "d"){
      
      source("ggplot_func/theme_black_ggplot.R")
      
      data <- nba_reactive()[[1]]
      
      # exclude backcourt shots
      shotDataS <- data[which(!data$SHOT_ZONE_BASIC=='Backcourt'), ]
      
      shotS <- ddply(shotDataS, .(SHOT_ZONE_BASIC), summarize, 
                     SHOTS_ATTEMPTED = length(SHOT_MADE_FLAG),
                     SHOTS_MADE = sum(as.numeric(as.character(SHOT_MADE_FLAG))),
                     MLOC_X = mean(LOC_X),
                     MLOC_Y = mean(LOC_Y))
      
      # calculate shot zone accuracy and add zone accuracy labels
      shotS$SHOT_ACCURACY <- (shotS$SHOTS_MADE / shotS$SHOTS_ATTEMPTED)
      shotS$SHOT_ACCURACY_LAB <- paste(as.character(round(100 * shotS$SHOT_ACCURACY, 1)), "%", sep="")
      
      #loading court
      court <- rasterGrob(readJPEG("images/court3.jpeg"),
                          width=unit(1,"npc"), height=unit(1.2,"npc"))
      
      # plot shot accuracy per zone
      ggplot(shotS, aes(x=MLOC_X, y=MLOC_Y)) + 
        annotation_custom(court, -250, 250, -52, 418) +
        geom_point(aes(colour = SHOT_ZONE_BASIC, alpha = 0.8), size = 1) +
        geom_text(aes(colour = SHOT_ZONE_BASIC , label = SHOT_ACCURACY_LAB), vjust = -1.3, size = 8) +
        guides(alpha = FALSE, size = FALSE) +
        xlim(250, -250) +
        ylim(-52, 418) +
        ggtitle(paste("Shot Accuracy Chart\n", unique(shotDataf$PLAYER_NAME), sep = "")) +
        theme_black()
      
    } #close else if 
    
    
  })
  
  
  output$table <- renderTable(
    
    #This is where the image is set
    if(nba_reactive()[[3]] == 1){
      
      load("data/lebron_stats.RData")
      df_lbj
      
    }
    else if(nba_reactive()[[3]] ==  2){
      load("data/harden_stats.RData")
      df_hrd
    }
    else if(nba_reactive()[[3]] ==  3){
      load("data/curry_stats.RData")
      df_stp
    }
    else if(nba_reactive()[[3]] ==  4){
      load("data/durant_stats.RData")
      df_dur
    }
    
    
  ) #close table
  
  
  
  
    }

shinyApp(ui = ui, server = server)










