library(jsonlite)
library(httr)
library(Rcurl)
library(XML)
library(plyr)
library(reshape2)

json_try <- fromJSON("https://inventory.data.gov/api/action/datastore_search?resource_id=1705fe89-ffc3-420d-a385-f365f75fa7eb&filters={%22Status%22:%22Active%22}")


buffalo_math <- fromJSON('https://inventory.data.gov/api/action/datastore_search?resource_id=b4e7f148-3afc-4782-84a3-dfaca3156e8b&q=buffalo+city+school')

req <- POST('https://inventory.data.gov/api/action/datastore_search',
            body = "{
                    resource_id: 'b4e7f148-3afc-4782-84a3-dfaca3156e8b', 
    limit: 5, 
    q: 'jones' 
  }",
            encode = 'json'

          
)

'https://inventory.data.gov/api/action/datastore_search?resource_id=b4e7f148-3afc-4782-84a3-dfaca3156e8b&q=buffalo'


req <- POST("https://inventory.data.gov/api/action/datastore_search_sql?api_key=W7KRCyAf29uIuiklIvJaSgJliE6GrRpR01ObMUh6&sql=SELECT * from 'b4e7f148-3afc-4782-84a3-dfaca3156e8b' WHERE 'leanm11' LIKE 'jones'")
           
            
#write function that does search API query for each school, than isolates the data frame
#build up a dataframe object



#read data from github



#pulling data from nces.ed.gov/programes/stateprofiles

url <- getURL('https://nces.ed.gov/programs/stateprofiles/sresult.asp?mode=full&displaycat=7&s1=05')
alabama <- readHTMLTable(url, stringsAsFactors = FALSE)

alabama_stats <- alabama[[9]]

url1 <- getURL('https://nces.ed.gov/programs/stateprofiles/sresult.asp?mode=full&displaycat=7&s1=10')

state1 <- readHTMLTable(url1, stringsAsFactors = FALSE)
state1 <- state1[[9]]

#building 01-55 character vector for url query

state_ids <- as.character(rep(1:55))
state_ids <- unlist(lapply(state_ids, function(x) if(nchar(x) < 2) paste0("0", x) else x ))

#base url
url <- 'https://nces.ed.gov/programs/stateprofiles/sresult.asp?mode=full&displaycat=7&s1='


#function to go through above vector and download all the state data
#takes one two digit character code (01-55) as argument
per_data_dl <- function(state_id) {
  state_uri <- getURL(paste0(url, state_id))
  state_table <- readHTMLTable(state_uri, stringsAsFactors = FALSE)
  state_df <- state_table[[9]]
  return(state_df)
}

#function to extract correct data from downloaded data frame

data_extract <- function(df) {
  state_name <- colnames(df)[3]
  math_scale <- as.integer(df[6,3])
  math_basic <- as.integer(df[7,3])
  math_pro <- as.integer(df[8,3])
  math_adv <- as.integer(df[9,3])
  return(data.frame(state_name, math_scale, math_basic, math_pro, math_adv))
}

df_List <- lapply(state_ids, per_data_dl)
extracted <- lapply(df_list, data_extract)
math_data <- ldply(extracted, data.frame)

###Finance Data
fed_data <- read.csv('https://raw.githubusercontent.com/cjf4/IS-607-Data-Acquisition-and-Management/master/Final%20Project/elsec11.csv', stringsAsFactors = FALSE)

