
text1 <- "The current year is 2017"
my_pattern <- "[[:upper:][:digit:]]"
grepl(my_pattern,text1)
str_locate_all(text1, my_pattern)
str_extract_all(text1, my_pattern)
