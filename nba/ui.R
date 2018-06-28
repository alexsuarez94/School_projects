
library(shiny)
library(shinydashboard)
library(ggplot2)
library(RCurl)
library(grid)
library(jpeg)
library(hexbin)

source("nba_shot_stats.R")


dashboardPage(
  
  dashboardHeader(title = "NBA shot analytics"),
  
  #Sidebar content
  dashboardSidebar(
    selectInput("playerID", "Select a player:", choices = list("Stephen Curry" = 1, "Lebron James" = 2), selected = 2),
    selectInput("season", "Select a season", choices = list("2014-15" = 1, "2015-16" = 2, "2016-17" = 3, "2017-18" = 4), selected = 4),
    selectInput("chart", "Select shotChart", choices = list("a" = 1, "b" = 2, "c" = 3), selected = 1)
    
  ), #close dashboard sidebar
  
  dashboardBody(
    
    fluidRow(
      box(status = "primary", plotOutput("shotChart"), width = 8),
      box(status = "primary", title = "info player", width = 4, 
          "Each player will have here a photo a some basic pshicical measures")
      
    ), #close fluid Row
    
    
    fluidRow(
      
      box(status = "primary", title = "basic statistics", width = 8, 
          
        "Here somo basic statistics of the season will be displayed")
      
    ) #close fluidRow
    
  ) #close dashboardbody
  
  
) #close dashboardPage