library(httr)
library(XML)
library(RCurl)

editing_url <- 'https://en.wikipedia.org/wiki/Academy_Award_for_Best_Film_Editing'

editing_data <- readHTMLTable(getURL(editing_url))