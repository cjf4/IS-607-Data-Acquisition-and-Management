library(jsonlite)
library(httr)


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
           
            
            
