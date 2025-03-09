# Test 1: Testing the model directly by providing input data
if (FALSE) {
  # Load the model
  model <- readRDS("model.rds")
  
  # Input data
  input <- list(
    Sepal.Length = 5.1,
    Sepal.Width = 3.5,
    Petal.Length = 1.4,
    Petal.Width = 0.2
  )
  
  prediction <- predict(model, input)
  
  list(prediction = as.character(prediction))
  # $prediction
  # [1] "setosa"
}

# Test 2: Testing the model using the API
if (TRUE) {
  library(httr)
  library(jsonlite)
  # Load the model
  model <- readRDS("model.rds")
  
  # Input data
  input <- list(
    Sepal.Length = 5.1,
    Sepal.Width = 3.5,
    Petal.Length = 1.4,
    Petal.Width = 0.2
  )
  
  # Call the API
  response <- httr::POST(
    url = "http://localhost:8080/predict",
    body = jsonlite::toJSON(input, auto_unbox = TRUE),
    encode = "json",
    verbose()
  )
  
  # Print the response
  print(response)
  # Response [http://localhost:8000/predict]
  #   Date: 2021-07-07 14:00
  #   Status: 200
  #   Content-Type: application/json
  #   Size: 22 B
  # {
  #   "prediction": "setosa"
  # }
  
  # Extract the prediction
  prediction <- jsonlite::fromJSON(httr::content(response, as = "text"))
  
  list(prediction = prediction$prediction)
  # $prediction
  # [1] "setosa"
}
