# Parsing the name of main actors from star wars movies

movies_list <- read_html("https://www.imdb.com/list/ls070150896/")

url <- movies_list %>%
  html_nodes(" h3 a") %>%
  html_attr('href') %>%
  na.exclude()

url <- grep("/title/", url, value = TRUE)
url

#assign main path to every movie
for (i in 1:length(url)){
films <- paste0("http://www.imdb.com", url, sep = "")
}

star_wars <- list()
for ( i in 1:length(films)){
  star_wars[[i]] <- read_html(films[i])
}

cast_star <- list()
for(i in 1:length(films)){
cast_star[[i]] <- star_wars[[i]] %>%
  html_nodes("#titleCast .itemprop span") %>%
  html_text()
cast_star
}

cast_star

vector <- table(unlist(cast_star))
which.max(vector)











