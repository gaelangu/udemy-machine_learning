# Natural Language Processing

# Importing the dataset
dataset_original = read.delim('Restaurant_Reviews.tsv', quote = '', stringsAsFactors = FALSE)

# CLeaning the tests
# install.packages('tm')
# install.packages('SnowballC')
library(tm)
library(SnowballC)
corpus = VCorpus(VectorSource(dataset$Review))

# Corpus to lowercase
corpus = tm_map(corpus, content_transformer(tolower))

# Corpus to remove numbers
corpus = tm_map(corpus, removeNumbers)

# Corpus to remove punctuation
corpus = tm_map(corpus, removePunctuation)

# Corpus to remove irrelevant words (SnowballC package required)
corpus = tm_map(corpus, removeWords, stopwords())

# Stemming the Corpus
corpus = tm_map(corpus, stemDocument)

# Corpus to remove extra spaces
corpus = tm_map(corpus, stripWhitespace)

# Creating the Bag of Words model (matrix)
dtm = DocumentTermMatrix(corpus)

# Remove 99.9% of most frequent words from sparse matrix
dtm = removeSparseTerms(dtm, 0.999)

# Convert matrix to dataframe for Random Forest
dataset = as.data.frame(as.matrix(dtm))
dataset$Liked = dataset_original$Liked

# Encoding the target feature as factor
dataset$Liked = factor(dataset$Liked, levels = c(0, 1))

# Splitting the dataset into the Training set and Test set
# install.packages('caTools')
library(caTools)
set.seed(123)
split = sample.split(dataset$Liked, SplitRatio = 0.8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

# Fitting Random Forest Classification to the Training set
library(randomForest)
classifier = randomForest(x = training_set[-692],
                          y = training_set$Liked,
                          ntree = 10)

# Predicting the Test set results
y_pred = predict(classifier, newdata = test_set[-692])

# Making the Confusion Matrix
cm = table(test_set[, 692], y_pred)
