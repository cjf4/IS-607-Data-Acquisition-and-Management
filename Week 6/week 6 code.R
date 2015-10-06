w6 <- read.csv('week_6.csv')
w6[2,1] <- 'ALASKA'
w6[5,1] <- 'AM WEST'
w6 <- filter(w6, w6[,1] != "")
names(w6)[1] <- "Airline"
names(w6)[2] <- "timeliness"
w6_tidy <- w6 %>% gather(city, frequency, -Airline, -timeliness) %>%
                  spread(timeliness, frequency) 
