library(tm)
library(caTools)
library(RTextTools)

set.seed(500)

#get a list of file names
easy_h_files <- paste0("easy_ham/", list.files("easy_ham"))
hard_h_files <- paste0("hard_ham/", list.files("hard_ham"))
spam_files <- paste0("spam/", list.files("spam"))
spam_2_files <- paste0("spam_2/", list.files("spam_2"))

#read each file in as one string each
read_lines_string <- function(x) {
  paste(readLines(x), collapse=" ")
}

easy_h_corp <- unlist(lapply(easy_h_files, read_lines_string))
hard_h_corp <- unlist(lapply(hard_h_files, read_lines_string))
spam_corp <- unlist(lapply(spam_files, read_lines_string))
spam_2_corp <- unlist(lapply(spam_2_files, read_lines_string))

#combine spam and ham
ham_corpus <- c(easy_h_corp, hard_h_corp)
spam_corpus <- c(spam_corp, spam_2_corp)

#add classifiers
ham_id <- rep(1, length(ham_corpus))
spam_id <- rep(0, length(spam_corpus))

#create one big corpus
ham_frame <- data.frame(text=ham_corpus, h_or_s=ham_id, stringsAsFactors = FALSE)
spam_frame <- data.frame(text=spam_corpus, h_or_s=spam_id, stringsAsFactors = FALSE)
emails <- rbind(ham_frame, spam_frame)

#convert to standard format
emails$text <- iconv(emails$text, to="UTF-8")

#convert to lower case (maybe pipe this)
emails$text <- lapply(emails$text, tolower)
emails$text <- lapply(emails$text, removePunctuation)
emails$text <- lapply(emails$text, removeWords, stopwords("english"))
emails$text <- lapply(emails$text, stemDocument)
emails$text <- unlist(emails$text)

email_corp <- Corpus(VectorSource(emails$text))

docterm_mat <- DocumentTermMatrix(email_corp)

docterm_mat <- removeSparseTerms(docterm_mat, 0.97)

#probably can get rid of this
spamTerms <- as.data.frame(as.matrix(docterm_mat))
spamTerms$h_or_s <- emails$h_or_s

split_up <- sample.split(spamTerms$h_or_s, 0.8)
training_set <- subset(spamTerms, split_up == TRUE)
testing_set <- subset(spamTerms, split_up == FALSE)

#pick back up here

container <- create_container(docterm_mat, trainSize = 1:3700, testSize = 3701:4700, labels = spamTerms$h_or_s, virgin = FALSE)

svm_trainer <- train_model(container, "SVM")
svm_output <- classify_model(container, svm_trainer)

tree_trainer <- train_model(container, "TREE")
tree_output <- classify_model(container, tree_trainer)

maxent_trainer <- train_model(container, "MAXENT")
maxent_output <- classify_model(container, maxent_trainer)

model_performance <- data.frame(
                        correct_label = spamTerms$h_or_s[3701:4700],
                        svm = as.character(svm_output[,1]),
                        tree = as.character(tree_output[,1]),
                        maxent = as.character(maxent_output[,1]),
                        stringsAsFactors = FALSE)

prop.table(table(model_performance$correct_label == model_performance$svm))
prop.table(table(model_performance$correct_label == model_performance$tree))
prop.table(table(model_performance$correct_label == model_performance$maxent))

