lirbrary(RCurl)

ds_url <- getURL("https://raw.githubusercontent.com/fivethirtyeight/data/master/
                    daily-show-guests/daily_show_guests.csv")
daily_show <- read.csv(text=ds_url)

daily_show_guests <- daily_show[,c(1, 4:5)]