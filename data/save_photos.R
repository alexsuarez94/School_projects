source("data/player.id")
#save photos
library(png)


# selected top player from nba
selected_players <- c("lebron", "harden", "curry", "durant")

#scrapping photos from web
for (i in 1:length(selected_players)){
  download.file(player_photo[i], paste0("images/", selected_players[i], ".png"), mode = "wb")
}
