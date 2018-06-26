films <- c("http://www.imdb.com/title/tt1490017/", "https://www.imdb.com/title/tt0121765/?ref_=ttls_li_tt",
           "https://www.imdb.com/title/tt0121766/?ref_=ttls_li_tt", "https://www.imdb.com/title/tt0076759/?ref_=ttls_li_tt")

star_wars <- list()
for ( i in 1:length(films)){
  star_wars[[i]] <- read_html(films[i])
}

## ----eval=FALSE----------------------------------------------------------

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





#para intentar recoger las url 
# url <- prueba %>%
#   html_nodes(".free") %>%
#   html_attr('href') 
# url
# 




