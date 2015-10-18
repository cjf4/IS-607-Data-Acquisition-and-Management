library(httr)
library(XML)
library(RCurl)
library(rvest)

editing_url <- 'http://awardsdatabase.oscars.org/ampas_awards/DisplayMain.jsp?curTime=1444906423141'

editing_data <- readHTMLTable(getURL(editing_url))

oscars <- read.csv(file='academy_awards.csv', stringsAsFactors = FALSE)
oscars <- oscars[,1:5]



cuadro <- POST(url = "http://www.cuadra.com/starweb/Movie-STAR/servlet.starweb",
                      encode="form",
                  body = body)
