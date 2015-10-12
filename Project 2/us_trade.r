library(tidyr)
library(plyr)
library(dplyr)
library(stringr)
library(ggplot2)

#read in data
trade_data <- read.csv("International Trade in Goods and Services.csv", 
                          stringsAsFactors = FALSE)

#remove blank rows
trade_data <- subset(trade_data, X2013 != "")

#fill in missing months
trade_data$Period[c(3,5,7,9)] <- c("January", "February","March","April")

#rename some column names
colnames(trade_data)[2] <- "goods_services"
colnames(trade_data)[3:8] <- c("2013 Exports","2013 Imports","2014 Exports",
                               "2014 Imports","2015 Exports", "2015 Imports")
trade_data <- trade_data[2:9,]

#reset the row names
rownames(trade_data) <- 1:8

#run a gather function
tidy_trade <- gather(trade_data, "Year/Type", "Total", -Period, -goods_services)

tidy_trade <- separate(tidy_trade, "Year/Type", 
                       into = c("year", "import_export"), 
                       sep = "[[:space:]]")


tidy_trade <- spread(tidy_trade, goods_services, Total)


#convert the goods and services vectors to numeric
tidy_trade$'Goods ' <- as.numeric(str_replace(tidy_trade$'Goods ', ",", ""))
tidy_trade$Services  <- as.numeric(str_replace(tidy_trade$Services , ",", ""))





#I think this a place where Tidy Data does have a rigid definition. I was debating
#whether or not to spread out the import_export column. I decided not to because

exports <- subset(tidy_trade, import_export == 'Exports')
imports <- subset(tidy_trade, import_export == 'Imports')

#analysis
#1. average goods exported for each month
mean(exports$Goods)

#2. avegage goods imported for each month
mean(imports$Goods)

#3. average services exported for each month
mean(exports$Services)

#4. average services imported for each month
mean(imports$Services)