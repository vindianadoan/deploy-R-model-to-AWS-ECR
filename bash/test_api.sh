#!/bin/bash

curl -X POST "http://localhost:8080/predict" \
     -H "Content-Type: application/json" \
     -d '{"Sepal.Length": 5.1, "Sepal.Width": 3.5, "Petal.Length": 1.4, "Petal.Width": 0.2}'
