# Use a specific R base image (e.g., 4.4.1)
FROM r-base:4.4.1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libsodium-dev \
    build-essential \
    pkg-config \
 && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy the renv lock file and, optionally, the renv directory
COPY renv.lock /app/renv.lock
# If you want to speed up restore or have local packages cached, copy the entire renv directory:
# COPY renv/ /app/renv/

# Copy your R scripts
COPY train.R /app/train.R
COPY serve.R /app/serve.R

# Install renv and restore package versions from renv.lock
RUN R -e "install.packages('renv', repos='http://cran.rstudio.com/'); \
           renv::restore(repos = c(CRAN = 'http://cran.rstudio.com/'))"

# Run the training script to generate model.rds
RUN Rscript train.R

# Expose the Plumber API port
EXPOSE 8080

# Start the Plumber API server
CMD ["R", "-e", "pr <- plumber::plumb('serve.R'); pr$run(host='0.0.0.0', port=8080)"]
