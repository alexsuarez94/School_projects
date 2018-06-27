######################################################################################

if (!require(rjson)) install.packages("rjson")

######################################################################################


# shot data for Stephen Curry
playerID <- c(201939, 2544)
season <- c("2014-15", "2015-16", "2016-17", "2017-18")
shotURL <- paste0("http://stats.nba.com/stats/shotchartdetail?Period=0&VsConference=&LeagueID=
00&LastNGames=0&TeamID=0&Position=&Location=&Outcome=&ContextMeasure=FGA&DateFrom=&StartPeriod=
&DateTo=&OpponentTeamID=0&ContextFilter=&RangeType=&Season=",season,"&AheadBehind=&PlayerID=", playerID,"&EndRange=
&VsDivision=&PointDiff=&RookieYear=&GameSegment=&Month=0&ClutchTime=&StartRange=&EndPeriod=&SeasonType=Regular
+Season&SeasonSegment=&GameID=&PlayerPosition=", sep = "")


# import from JSON

shotData <- rep( list(rep(list(list()), length(season))), length(playerID) ) 

for (i in 1:length(playerID)){
  for (j in 1:length(season)){
    
shotData[[i]][[j]] <- fromJSON(file = paste0("http://stats.nba.com/stats/shotchartdetail?Period=0&VsConference=&LeagueID=
00&LastNGames=0&TeamID=0&Position=&Location=&Outcome=&ContextMeasure=FGA&DateFrom=&StartPeriod=
&DateTo=&OpponentTeamID=0&ContextFilter=&RangeType=&Season=",season[j],"&AheadBehind=&PlayerID=", playerID[i],"&EndRange=
&VsDivision=&PointDiff=&RookieYear=&GameSegment=&Month=0&ClutchTime=&StartRange=&EndPeriod=&SeasonType=Regular
+Season&SeasonSegment=&GameID=&PlayerPosition=", sep = ""), method="C")

  }
}


shotDataf <- rep( list(rep(list(list()), length(season))), length(playerID) )
# unlist shot data, save into a data frame
for (i in 1:length(playerID)){
  for (j in 1:length(season)){
    
    shotDataf[[i]][[j]] <- data.frame(matrix(unlist(shotData[[i]][[j]]$resultSets[[1]][[3]]), ncol=24, byrow = TRUE))
    # shot data headers
    colnames(shotDataf[[i]][[j]]) <- shotData[[i]][[j]]$resultSets[[1]][[2]]
    
    # covert x and y coordinates into numeric
    shotDataf[[i]][[j]]$LOC_X <- as.numeric(as.character(shotDataf[[i]][[j]]$LOC_X))
    shotDataf[[i]][[j]]$LOC_Y <- as.numeric(as.character(shotDataf[[i]][[j]]$LOC_Y))
    shotDataf[[i]][[j]]$SHOT_DISTANCE <- as.numeric(as.character(shotDataf[[i]][[j]]$SHOT_DISTANCE))
  }
}


# have a look at the data to check if the loop are ok. 
View(shotDataf[[1]][[3]])

###############################################################################################
#plotting results

###############################################################################################

library(ggplot2)
ggplot(shotDataf, aes(x=LOC_X, y=LOC_Y)) +
  geom_point(aes(colour = EVENT_TYPE))

library(RCurl)
library(grid)
library(jpeg)

# half court image
courtImg.URL <- "https://thedatagame.files.wordpress.com/2016/03/nba_court.jpg"
court <- rasterGrob(readJPEG(getURLContent(courtImg.URL)),
                    width=unit(1,"npc"), height=unit(1,"npc"))

# plot using NBA court background and colour by shot zone
ggplot(shotDataf, aes(x=LOC_X, y=LOC_Y)) + 
  annotation_custom(court, -250, 250, -50, 420) +
  geom_point(aes(colour = SHOT_ZONE_BASIC, shape = EVENT_TYPE)) +
  xlim(-250, 250) +
  ylim(-50, 420)

#coord fixed plot
#
# plot using ggplot and NBA court background image
ggplot(shotDataf, aes(x=LOC_X, y=LOC_Y)) +
  annotation_custom(court, -250, 250, -50, 420) +
  geom_point(aes(colour = SHOT_ZONE_BASIC, shape = EVENT_TYPE)) +
  xlim(250, -250) +
  ylim(-50, 420) +
  geom_rug(alpha = 0.2) +
  coord_fixed() +
  ggtitle(paste("Shot Chart\n", unique(shotDataf$PLAYER_NAME), sep = "")) +
  theme(line = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        legend.title = element_blank(),
        plot.title = element_text(size = 15, lineheight = 0.9, face = "bold"))

library(hexbin)

# plot shots using ggplot, hex bins, NBA court backgroung image.
ggplot(shotDataf, aes(x=LOC_X, y=LOC_Y)) + 
  annotation_custom(court, -250, 250, -52, 418) +
  stat_binhex(bins = 25, colour = "gray", alpha = 0.7) +
  scale_fill_gradientn(colours = c("yellow","orange","red")) +
  guides(alpha = FALSE, size = FALSE) +
  xlim(250, -250) +
  ylim(-52, 418) +
  geom_rug(alpha = 0.2) +
  coord_fixed() +
  ggtitle(paste("Shot Chart\n", unique(shotDataf$PLAYER_NAME), sep = "")) +
  theme(line = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        legend.title = element_blank(),
        plot.title = element_text(size = 17, lineheight = 1.2, face = "bold"))

# exclude backcourt shots
shotDataS <- shotDataf[which(!shotDataf$SHOT_ZONE_BASIC=='Backcourt'), ]

# summarise shot data
library(plyr)
shotS <- ddply(shotDataS, .(SHOT_ZONE_BASIC), summarize, 
               SHOTS_ATTEMPTED = length(SHOT_MADE_FLAG),
               SHOTS_MADE = sum(as.numeric(as.character(SHOT_MADE_FLAG))),
               MLOC_X = mean(LOC_X),
               MLOC_Y = mean(LOC_Y))

# calculate shot zone accuracy and add zone accuracy labels
shotS$SHOT_ACCURACY <- (shotS$SHOTS_MADE / shotS$SHOTS_ATTEMPTED)
shotS$SHOT_ACCURACY_LAB <- paste(as.character(round(100 * shotS$SHOT_ACCURACY, 1)), "%", sep="")

# plot shot accuracy per zone
ggplot(shotS, aes(x=MLOC_X, y=MLOC_Y)) + 
  annotation_custom(court, -250, 250, -52, 418) +
  geom_point(aes(colour = SHOT_ZONE_BASIC, size = SHOT_ACCURACY, alpha = 0.8), size = 8) +
  geom_text(aes(colour = SHOT_ZONE_BASIC, label = SHOT_ACCURACY_LAB), vjust = -1.2, size = 8) +
  guides(alpha = FALSE, size = FALSE) +
  xlim(250, -250) +
  ylim(-52, 418) +
  coord_fixed() +
  ggtitle(paste("Shot Accuracy\n", unique(shotDataf$PLAYER_NAME), sep = "")) +
  theme(line = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        legend.title = element_blank(),
        legend.text=element_text(size = 12),
        plot.title = element_text(size = 17, lineheight = 1.2, face = "bold"))

