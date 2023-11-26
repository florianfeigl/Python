#!/usr/bin/env R 

library(ggplot2)
library(stats)

# Read CSV file - Assuming no headers in the file
data <- read.csv('Template-TM-determination.csv', header = FALSE)

# Select the specific rows and columns starting from the third column
selected_data <- data[10:120, 3:15]

# Manually set column names for selected_data with custom names
colnames(selected_data) <- c('Temperature', '250 µM', '125 µM', '62.5 µM', '31.25 µM', '15.63 µM', '7.81 µM', '3.91 µM', '1.95 µM', '0.98 µM', '0.49 µM', '0.24 µM', '0 µM')

# Replace "#N/A" with NA and convert to numeric for all selected columns
selected_data[] <- lapply(selected_data, function(x) {
  x <- as.character(x)
  x[x == "#N/A"] <- NA
  return(as.numeric(x))
})

# Remove rows with any NA values
selected_data <- selected_data[complete.cases(selected_data), ]

# Define the Boltzmann sigmoid function
boltzmann_sigmoid <- function(x, x0, s) {
  1 / (1 + exp(-(x - x0) / s))
}

# Function to fit the Boltzmann sigmoid function and return the V50 (x0) value
fit_boltzmann_and_get_v50 <- function(fluo, temp) {
  # Perform curve fitting
  fit <- nls(fluo ~ boltzmann_sigmoid(temp, x0, s), 
             start = list(x0 = median(temp), s = 1), 
             algorithm = "port",
             control = nls.control(maxiter = 100, minFactor = 1/1024))
  
  # Extract the estimated x0 parameter
  coef(fit)["x0"]
}

# Calculate V50 values for each fluorescence column
v50_values <- sapply(2:ncol(selected_data), function(i) {
  fit_boltzmann_and_get_v50(selected_data[, i], selected_data[, 1])
})

# Create a dataframe for V50 values
v50_data <- data.frame(Variable = colnames(selected_data)[-1], V50 = v50_values)

# Write V50 values to a CSV file
write.csv(v50_data, 'V50.csv', row.names = FALSE)
