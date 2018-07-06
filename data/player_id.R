

library(jsonlite)
library(rvest)
library(httr)
library(dplyr)

#create a vector with the top players
selected_players <- c("James, LeBron", "Harden, James", "Curry, Stephen", "Durant, Kevin")

#select url after search in the web browser
players_url = "http://stats.nba.com/stats/commonallplayers?LeagueID=00&Season=2015-16&IsOnlyCurrentSeason=0"

#setting up the connection
request_headers = c(
  "accept-encoding" = "gzip, deflate, sdch",
  "accept-language" = "en-US,en;q=0.8",
  "cache-control" = "no-cache",
  "connection" = "keep-alive",
  "host" = "stats.nba.com",
  "pragma" = "no-cache",
  "upgrade-insecure-requests" = "1",
  "user-agent" = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9"
)

#making a request of data with package jsonlite()
request = GET(players_url, add_headers(request_headers))
players_data = jsonlite::fromJSON(content(request, as = "text"))

#select the fundamental part of the list 
players = tbl_df(data.frame(players_data$resultSets$rowSet[[1]], stringsAsFactors = FALSE))
names(players) = tolower(players_data$resultSets$headers[[1]])

players = mutate(players,
                 person_id = as.numeric(person_id),
                 rosterstatus = as.logical(as.numeric(rosterstatus)),
                 from_year = as.numeric(from_year),
                 to_year = as.numeric(to_year),
                 team_id = as.numeric(team_id)
)


top_players <- tbl_df(matrix(0L, nrow = 4, ncol = 13))
for (i in 1:length(selected_players)){
top_players[i, ]  <- dplyr::filter(players, grepl(selected_players[i], display_last_comma_first))
}
names(top_players) <- names(players)

player_id <- top_players$person_id 

#looking for links to scrap the player photo in the web
player_photo_url = function(player_id) {
  paste0("http://stats.nba.com/media/players/230x185/", player_id, ".png")
}

player_photo <- sapply(player_id, player_photo_url)


top_players <- top_players[, c(2, 5, 11)]




