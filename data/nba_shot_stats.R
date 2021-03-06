# sourcing player ids
source("data/player_id.R") 

# shot data for Stephen Curry
playerID <- player_id
season <- c("2014-15", "2015-16", "2016-17", "2017-18")


# scrapping data from JSON database with rjson() package

shotData <- rep( list(rep(list(list()), length(season))), length(playerID) ) 

for (i in 1:length(playerID)){
  for (j in 1:length(season)){
    
shotData[[i]][[j]] <- rjson::fromJSON(file = paste0("http://stats.nba.com/stats/shotchartdetail?Period=0&VsConference=&LeagueID=
00&LastNGames=0&TeamID=0&Position=&Location=&Outcome=&ContextMeasure=FGA&DateFrom=&StartPeriod=
&DateTo=&OpponentTeamID=0&ContextFilter=&RangeType=&Season=",season[j],"&AheadBehind=&PlayerID=", playerID[i],"&EndRange=
&VsDivision=&PointDiff=&RookieYear=&GameSegment=&Month=0&ClutchTime=&StartRange=&EndPeriod=&SeasonType=Regular
+Season&SeasonSegment=&GameID=&PlayerPosition=", sep = ""), method="C")

  }
}

#preprocessing data
shotDataf <- rep( list(rep(list(list()), length(season))), length(playerID) )

# unlist shot data, save into a data frame
for (i in 1:length(playerID)){
  for (j in 1:length(season)){
    
    shotDataf[[i]][[j]] <- data.frame(matrix(unlist(shotData[[i]][[j]]$resultSets[[1]][[3]]), ncol=24, byrow = TRUE))
    # shot data headers
    colnames(shotDataf[[i]][[j]]) <- shotData[[i]][[j]]$resultSets[[1]][[2]]
    
    # covert x and y coordinates into numeric to plot them in court charts. 
    shotDataf[[i]][[j]]$LOC_X <- as.numeric(as.character(shotDataf[[i]][[j]]$LOC_X))
    shotDataf[[i]][[j]]$LOC_Y <- as.numeric(as.character(shotDataf[[i]][[j]]$LOC_Y))
    shotDataf[[i]][[j]]$SHOT_DISTANCE <- as.numeric(as.character(shotDataf[[i]][[j]]$SHOT_DISTANCE))
  }
}












