library(stringr)

chess_table <- readLines("tournamentinfo.txt")

tail(chess_table)

first_line <- unlist(lapply(chess_table, str_detect, 
                              pattern = "^\\s+\\d{1,2}.+"))
second_line <- unlist(lapply(chess_table, str_detect,
                              pattern = "^\\s+[[:upper:]]{2}.+"))

chess_data <- data.frame(chess_table, 
                         first_line, 
                         second_line, 
                         stringsAsFactors = FALSE)

first_vector <- subset(chess_data$chess_table, first_line == TRUE)
second_vector <- subset(chess_data$chess_table, second_line == TRUE)

tourny_data <- data.frame(ID = 1:64, 
                          line1 = first_vector, 
                          line2 = second_vector, 
                          stringsAsFactors = FALSE)

tourny_data[,"player_name"] <- str_extract(tourny_data$line1, 
                           "(\\b[[:upper:]-]+\\b\\s)+(\\b[[:upper:]-]+\\b){1}")

tourny_data[,"state"] <- str_extract(tourny_data$line2, "[[:upper:]]{2}" )

tourny_data[,"points"] <- as.numeric(str_extract(tourny_data$line1, 
                                                  "\\d(.)\\d"))

tourny_data[,"pre_rating"] <- as.numeric(str_extract(tourny_data$line2,
                                                     perl("(?<=\\s)(\\d){3,4}\\b")))
tourny_data[is.na(tourny_data$pre_rating), 
                            "pre_rating"] <- as.numeric(
                                              str_extract(
                                              subset(
                                                tourny_data$line2, 
                                                is.na(tourny_data$pre_rating)), 
                                              perl("\\b\\d{3,4}(?=P)")))

opponents <- str_extract_all(tourny_data$line1, perl("(\\d){1,2}(?=[|])"))
opponents <- lapply(opponents, as.numeric)

avg_score_lookup <- function(opponents) {
  num_of_opponents <- length(opponents)
  total_rating <- 0
  for (i in opponents){
      total_rating <- total_rating + tourny_data[i, "pre_rating"]
  }
  return(total_rating/num_of_opponents)
}

tourny_data[,"avg_opp_prerate"] <- unlist(lapply(opponents, avg_score_lookup))

