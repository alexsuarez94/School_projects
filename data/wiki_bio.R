library(rvest)
library(magrittr)

#read HTML code from the websites

web_links <- c("https://en.wikipedia.org/wiki/LeBron_James", "https://en.wikipedia.org/wiki/James_Harden", 
               "https://en.wikipedia.org/wiki/Stephen_Curry", "https://en.wikipedia.org/wiki/Kevin_Durant")


webpage <- read_html(web_links[1])

table <- webpage %>%
  html_nodes("table.vcard") %>%
  html_table(header=F, fill = T)


table1 <- table[[1]]$X1
table2 <- table[[1]]$X2

#as.data.frame
table3 <- as.data.frame(cbind(table1, table2))

lbj_bio <- table3[c(3, 5, 6, 7, 8, 10, 11), ]
names(lbj_bio) <- c("FIELD", "PLAYER")

#harden 
webpage <- read_html(web_links[2])

table <- webpage %>%
  html_nodes("table.vcard") %>%
  html_table(header=F, fill = T)


table1 <- table[[1]]$X1
table2 <- table[[1]]$X2

#as.data.frame
table3 <- as.data.frame(cbind(table1, table2))


hrd_bio <- table3[c(3, 5, 6, 7, 8, 10, 11), ]
names(hrd_bio) <- c("FIELD", "PLAYER")


#curry
webpage <- read_html(web_links[3])

table <- webpage %>%
  html_nodes("table.vcard") %>%
  html_table(header=F, fill = T)


table1 <- table[[1]]$X1
table2 <- table[[1]]$X2

#as.data.frame
table3 <- as.data.frame(cbind(table1, table2))


stp_bio <- table3[c(3, 5, 6, 7, 8, 10, 11), ]
names(stp_bio) <- c("FIELD", "PLAYER")

#durant

webpage <- read_html(web_links[4])

table <- webpage %>%
  html_nodes("table.vcard") %>%
  html_table(header=F, fill = T)


table1 <- table[[1]]$X1
table2 <- table[[1]]$X2

#as.data.frame
table3 <- as.data.frame(cbind(table1, table2))


dur_bio <- table3[c(3, 5, 6, 7, 8, 10, 11), ]
names(dur_bio) <- c("FIELD", "PLAYER")

save(lbj_bio , file ="lbj_bio.RData")
save(hrd_bio ,file ="hrd_bio.RData")
save(stp_bio, file ="stp_bio.RData")
save(dur_bio, file ="dur_bio.RData")
