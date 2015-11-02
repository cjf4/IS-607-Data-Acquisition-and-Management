library(RCurl)
library(httr)
library(jsonlite)

m_key <- "&api-key=24cf73bd0d79a879f2c726186680b1c7:4:73355908"
cb_uri <- "http://api.nytimes.com/svc/movies/v2/reviews/search.json?query=joel+ethan+coen"

#coen brothers search
coen_bros <- fromJSON(paste0(cb_uri, m_key))

coen_bros <- coen_bros$results

#wes anderson search
wa_uri <- "http://api.nytimes.com/svc/movies/v2/reviews/search.json?query=wes+anderson"

wes <- fromJSON(paste0(wa_uri, m_key))
wes <- wes$results

#get rid of the non wes anderson movies
wes$display_title
wes_df <- wes[1:8,]

#do the same for coen brothers
coen_bros$display_title
coen_df <- coen_bros[1:17,]

#whittle down to just the columns I want
wes_df <- data.frame(title = wes_df$display_title, 
                      rating = wes_df$mpaa_rating, 
                      critics_pick = wes_df$critics_pick, 
                      top1000 = wes_df$thousand_best)

coen_df <- data.frame(title = coen_df$display_title, 
                       rating = coen_df$mpaa_rating, 
                       critics_pick = coen_df$critics_pick, 
                       top1000 = coen_df$thousand_best)

table(coen_df$critics_pick)

table(wes_df$critics_pick)