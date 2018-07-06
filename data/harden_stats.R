# shot data for harden
source("data/player_id.R")

playerID <- player_id[2]
season <- c("2014-15", "2015-16", "2016-17", "2017-18")

# scrapping the data with rjson() package
basic_stat <- rep( list(rep(list(list()), length(season))), length(playerID) ) 

for (i in 1:length(playerID)){
  for (j in 1:length(season)){
    
    basic_stat[[i]][[j]] <- rjson::fromJSON(file = paste0("https://stats.nba.com/stats/playerdashboardbyyearoveryear?DateFrom=&DateTo=&GameSegment=&LastNGames=0&LeagueID=00&Location=&MeasureType=Base&Month=0&OpponentTeamID=0&Outcome=&PORound=0&PaceAdjust=N&PerMode=PerGame&Period=0&PlayerID=", playerID[i], "&PlusMinus=N&Rank=N&Season=", season[j],"&SeasonSegment=&SeasonType=Regular+Season&ShotClockRange=&Split=yoy&VsConference=&VsDivision=", sep = ""), method = "C")
    
  }
}

# preprocessing data

basic_Stats <- rep( list(rep(list(list()), length(season))), length(playerID) )
# unlist shot data, save into a data frame
for (i in 1:length(playerID)){
  for (j in 1:length(season)){
    
    basic_Stats[[i]][[j]] <- data.frame(matrix(unlist(basic_stat[[i]][[j]]$resultSets[[1]][[3]]), ncol=65, byrow = TRUE))
    # shot data headers
    colnames(basic_Stats[[i]][[j]]) <- basic_stat[[i]][[j]]$resultSets[[1]][[2]]
    
  }
}

#to create dataframe for harden 
df_hrd <- ldply(basic_Stats[[1]], data.frame)[ , c(2, 4, 6, 7, 8,22, 23, 24, 25, 26, 29, 31)]

#save to avoid reloading 
save(df_hrd, file = "harden_stats.RData")
