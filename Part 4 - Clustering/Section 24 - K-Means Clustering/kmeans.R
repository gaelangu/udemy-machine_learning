# K-Means Clustering

# Importing the Mall dataset
setwd('/Users/Gaelan/Dropbox/Documents/# Courses/Machine Learning/Part 4 - Clustering/Section 24 - K-Means Clustering')
dataset = read.csv('Mall_Customers.csv')
x = dataset[4:5]

# Using the elbow method to find the optimal number of clusters
set.seed(6)
wcss = vector()
for (i in 1:10) wcss[i] = sum(kmeans(x, i)$withinss)
plot(1:10, wcss, type = 'b', 
     main = paste('Clusters of clients'), 
     xlab = 'Number of clusters',
     ylab = 'WCSS')

# optimal number of clusters is 5

# Applying k-means to the mall dataset
set.seed(29)
kmeans = kmeans(x, 5, iter.max = 300, nstart = 10)
y_kmeans = kmeans$cluster

# Visualizing the clusters (2-dimensional only)
library(cluster)
clusplot(x,
         y_kmeans,
         lines = 0,
         shade = TRUE,
         color = TRUE,
         labels = 2,
         plotchar = FALSE,
         span = TRUE,
         main = paste('Clusters of clients'),
         xlab = 'Annual Income',
         ylab = 'Spending Income')