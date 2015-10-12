library(XML)
library(tidyr)
library(plyr)
library(dplyr)
library(stringr)
library(ggplot2)

if (false) {
gop <- readHTMLTable('http://www.realclearpolitics.com/epolls/2016/president/
                     us/2016_republican_presidential_nomination-3823.html#polls')

gop_data <- gop[[6]]



vector_to_num <- function(dataframe, column) {
  dataframe$column <- as.numeric()
}
}

gop <- read.csv('gop.csv', na.strings = "--")

#get rid of last years data, because theres no year value
gop <- gop[1:55,]

#
gop <- gather(gop, candidate, points, Trump:Pataki)

#drop the spread column
gop <- cbind(gop[1:2], gop[4:5])

#get the dates in an enddate, thus more usable format
gop$Date <- str_extract(gop$Date, "[[:digit:]]{1,2}/[[:digit:]]{1,2}$")

#change the dates to POSIX dates (so i can order them)
gop$Date <- strptime(gop$Date,"%m/%d")

#change points to numeric
gop$points <- as.numeric(gop$points)


trump <- subset(gop, candidate == "Trump" & !is.na(points))
rubio <- subset(gop, candidate == "Rubio" & !is.na(points))
bush <- subset(gop, candidate == "Bush" & !is.na(points))
carson <- subset(gop, candidate == "Carson" & !is.na(points))
fiorina <- subset(gop, candidate == "Fiorina" & !is.na(points))
cruz <- subset(gop, candidate == "Cruz" & !is.na(points))

gg <- ggplot(data=trump, aes(x=Date, y=points))
gg + geom_point()

gg + geom_point(data=bush, colour ='red') + geom_point(data=rubio, colour='blue')

horse_race <- gg +  geom_point(data=fiorina, colour ='black') + 
                    geom_point(data=rubio, colour='blue') + 
                    geom_point(data=trump, colour='gold') + 
                    geom_point(data=carson, colour='green') + 
                    geom_point(data=bush, colour='red')

#draw some vertical lines for the debates, refactor/dry out that code above