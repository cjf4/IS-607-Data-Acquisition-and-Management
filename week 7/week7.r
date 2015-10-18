library(XML)
library(jsonlite)

#JSON
json_books <- fromJSON("books.json", simplifyDataFrame = TRUE)[[1]]

#XML
books_root <- xmlRoot(xmlParse("books.xml"))
xml_books <- xmlToDataFrame(books_root)

#HTML
html_books <- readHTMLTable("books.html")[[1]]

#The three data frames are not identical. A little bit of this is
#due to the fact that I didn't do a perfect job of keeping the 
#files structured exactly the same, if that is even possible.

#Beyond that, the other major difference is the JSON data frame
#differentiated between data types, where as the HTML and XML
#frames treated everything as strings. 