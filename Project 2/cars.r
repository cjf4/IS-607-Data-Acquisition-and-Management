library(XML)
library(tidyr)
library(plyr)
library(dplyr)
library(stringr)
library(ggplot2)

#read in the data, removing junk columns
mlb <- subset(read.csv('mlb.csv', stringsAsFactors = FALSE), Year != 'Year')

#change factors to numeric (junk columns forced everything as factors)

mlb <- as.data.frame.list(lapply(mlb, function (x) as.numeric(x)))

#tidy the data
tidy_mlb <- gather(mlb, team, wins, ARI:WSN)

#add a "win pct" column
tidy_mlb[,'win_pct'] <- tidy_mlb$wins / tidy_mlb$G

#best regular season win percentages since 1980
head(arrange(subset(tidy_mlb, Year >= 1980), desc(win_pct)))

#a look at the red sox
#best seasons since 1980:
head(arrange(subset(tidy_mlb, Year >= 1980 & team == 'BOS'), desc(win_pct)))

#worst seasons since 1980:
head(arrange(subset(tidy_mlb, Year >= 1980 & team == 'BOS'), win_pct))

#interesting: Boston had its worst season in the past 25 years in 2012,
#it's second best in the same time period in 2013, and its 2nd worst in
#2014

mlb_80 <- subset(tidy_mlb, Year >= 1980)

#comparing the red sox to the yankees
boston <- subset(mlb_80, team == 'BOS')
nyy <- subset(mlb_80, team == 'NYY')
table(boston$wins > nyy$wins)