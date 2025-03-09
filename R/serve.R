# serve.R
library(plumber)
library(randomForest)
library(logger)
library(jsonlite)

# Configure logger to write API logs to logs/R_logs/requests.log
log_appender(appender_file("/app/logs/R_logs/requests.log"))

# Load the trained model
model <- readRDS("model.rds")

# Create a new Plumber router
pr <- plumber$new()

# Log incoming requests (pre-route hook)
pr$registerHook("preroute", function(req){
  log_info("Incoming request: {req$REQUEST_METHOD} {req$PATH_INFO}")
  # Uncomment to log the request body:
  # log_info("Request body: {req$postBody}")
})

# Define the /predict endpoint
#* @post /predict
#* @serializer json
function(req) {
  # Parse the JSON request body
  data <- fromJSON(req$postBody)
  input_data <- as.data.frame(data)
  
  # Generate a prediction from the model
  pred <- predict(model, input_data)
  log_info("Prediction: {paste(pred, collapse=', ')}")
  
  # Return the prediction as a JSON response
  list(prediction = as.character(pred))
}

# Log after processing each request (post-route hook)
pr$registerHook("postroute", function(req, res){
  log_info("Response status: {res$status}")
})

# Run the API server
pr$run(host='0.0.0.0', port=8080)

