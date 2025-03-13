# serve.R
library(plumber)
library(randomForest)
library(logger)
library(jsonlite)

# Set up logging
log_dir <- if (dir.exists("/app/logs")) {
  "/app/logs/R_logs"
} else {
  "logs/outside_container_logs/R_logs"
}
if (!dir.exists(log_dir)) {
  dir.create(log_dir, recursive = TRUE)
}
# Create a timestamp for the log file name
timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
log_file <- file.path(log_dir, paste0(timestamp, "_request.log"))
log_appender(appender_file(log_file))

# Load the trained model
model <- readRDS("data/model.rds")

#* @filter log_requests
function(req, res) {
  log_info("Incoming request: {req$REQUEST_METHOD} {req$PATH_INFO}")
  log_info("Request body: {req$postBody}")
  plumber::forward()
}


# Health check endpoint for SageMaker
#* @get /ping
function() {
  list(status = "Healthy")
}


# Inference endpoint
#* @post /invocations
#* @serializer json
function(req) {
  data <- fromJSON(req$postBody)
  input_data <- as.data.frame(data)
  pred <- predict(model, input_data)
  log_info("Prediction: {paste(pred, collapse=', ')}")
  list(prediction = as.character(pred))
}

