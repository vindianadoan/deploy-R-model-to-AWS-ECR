# serve.R
library(plumber)
library(randomForest)

# Load the pre-trained model (make sure model.rds is in the same directory)
model <- readRDS("model.rds")

#* Return model prediction
#* @post /predict
#* @param data:json
#* @json
function(data) {
  # Convert the incoming JSON (a list) to a data.frame.
  # It’s assumed that the JSON keys match the column names (except the target) used during training.
  input_data <- as.data.frame(data)
  
  # Perform prediction using the loaded model
  prediction <- predict(model, input_data)
  
  # Return the prediction result as a list
  list(prediction = as.character(prediction))
}
