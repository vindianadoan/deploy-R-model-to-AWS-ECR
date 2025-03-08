# train.R
# Load the randomForest package
library(randomForest)

# Use the iris dataset to train a random forest model for classification
data(iris)
model <- randomForest(Species ~ ., data = iris, ntree = 100)

# Save the trained model to disk
saveRDS(model, file = "model.rds")
