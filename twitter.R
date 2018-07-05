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
myTweets <- searchTwitter("refugees", n = 100)

tweets.text <- sapply(myTweets, function(x) x$getText())
# Replace @UserName
 tweets.text <- gsub("@\\w+", "", tweets.text)
 # Remove punctuation
tweets.text <- gsub("[[:punct:]]", "", tweets.text)
# Remove links
tweets.text <- gsub("http\\w+", "", tweets.text)
# Remove tabs
tweets.text <- gsub("[ |\t]{2,}", "", tweets.text)
# remove codes that are neither characters nor digits
tweets.text<-  gsub( '[^A-z0-9_]', ' ', tweets.text)
# Set characters to lowercase
tweets.text <- tolower(tweets.text)
# Replace blank space ("rt")
tweets.text <- gsub("rt", "", tweets.text)
# Remove blank spaces at the beginning
tweets.text <- gsub("^ ", "", tweets.text)
# Remove blank spaces at the end
tweets.text <- gsub(" $", "", tweets.text)
head(tweets.text)

require("tm")
tweets.text.corpus <- Corpus(VectorSource(tweets.text))
head(stopwords())

tweets.text.corpus <- tm_map(tweets.text.corpus, function(x) removeWords(x, stopwords()))
head(tweets.text.corpus)

require(wordcloud)

wordcloud(tweets.text.corpus, min.freq = 2, scale= c(7,0.5), colors=brewer.pal(8, "Dark2"),random.color= TRUE, random.order = FALSE, max.words = 150)
























