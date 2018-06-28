library(twitteR)


twitter_key <- "JooeFz2g7i4VbWAIwpddOL4dr"
twitter_secret <- "d4FP2t9O8Nxa8lAcoNu8x3YtQpJWE41dJ0B6aeVhQnazEt0j44"

access_token <- "463023825-aTRXAw2V3WYXjWhMCOpOHEWrTe2yVOGGvdwyI0E8"
access_secret <- "Yy5FnjsYD34jCablVxY1AviescYo1ryD843lJrTGytP4t"


oauth <- setup_twitter_oauth(twitter_key,
                             twitter_secret, 
                             access_token,
                              access_secret)

###

search.string <- "#Trump"
no.of.tweets <- 1000
myTweets <- searchTwitter(search.string, n=no.of.tweets, 
                        since='2017-05-01', until='2017-05-12', lang="en")
head(myTweets)

































