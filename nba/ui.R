
library(shiny)
library(shinydashboard)
library(ggplot2)
library(RCurl)
library(grid)
library(jpeg)
library(hexbin)
library(plyr)
library(shinyjs)
library(gridExtra)
library(rjson)
library(jsonlite)

#library(rvest)

source("nba_shot_stats.R")

dashboardPage(
  
 
  
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