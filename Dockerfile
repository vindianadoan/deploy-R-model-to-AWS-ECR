# Use the official R base image
FROM r-base:latest

# Install required R packages from CRAN
RUN R -e "install.packages(c('plumber', 'randomForest'), repos='http://cran.rstudio.com/')"

# Create an application directory
WORKDIR /app

# Copy the R scripts into the container
COPY train.R /app/train.R
COPY serve.R /app/serve.R

# Run the training script to generate model.rds
RUN Rscript train.R

# Expose port 8080 for the plumber API
EXPOSE 8080

# Start the plumber API server
CMD ["R", "-e", "pr <- plumber::plumb('serve.R'); pr$run(host='0.0.0.0', port=8080)"]
