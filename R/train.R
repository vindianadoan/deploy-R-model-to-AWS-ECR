# train.R
library(randomForest)
library(logger)

# Choose the log directory based on whether /app/logs exists (inside container) or not (outside)
log_dir <- if (dir.exists("/app/logs")) {
  "/app/logs/R_logs"
} else {
  "logs/outside_container_logs/R_logs"
}

# Ensure the directory exists; create it if necessary
if (!dir.exists(log_dir)) {
  dir.create(log_dir, recursive = TRUE)
}

# Create a timestamp for the log file name
timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
log_file <- file.path(log_dir, paste0(timestamp, "_training.log"))

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
saveRDS(model, file = "data/model.rds")
log_info("Model saved to model.rds.")
