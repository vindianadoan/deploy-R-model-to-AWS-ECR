# train.R
library(randomForest)
library(logger)

# Create a timestamp for the log file name
timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
log_file <- paste0("outside_container_logs/R_logs/",timestamp,"training_.log")

# Configure logger with a unique file name for each run
log_appender(appender_file(log_file))

log_info("Starting model training...")

# Train a random forest model to classify iris species
data(iris)
model <- randomForest(Species ~ ., data = iris, ntree = 100)

log_info("Model training complete.")

# Capture the output of print(model)
model_output <- capture.output(print(model))
# Log the captured output
log_info("Model details:\n{paste(model_output, collapse = '\n')}")

# Save the trained model to disk
saveRDS(model, file = "model.rds")
log_info("Model saved to model.rds.")
