#!/usr/bin/env R 

library(ggplot2)

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

# Boltzmann Sigmoid Function
x0 <- 0  # Modify as needed
s <- 1   # Modify as needed
boltzmann_sigmoid <- function(x) {
  1 / (1 + exp(-(x - x0) / s))
}

# Apply function to the fluorescence columns
selected_data[, -1] <- sapply(selected_data[, -1], boltzmann_sigmoid, simplify = "data.frame")

# Reshape data for plotting
temp_column <- selected_data[, 1]
fluorescence_data <- selected_data[, -1]
long_data <- data.frame(Temperature = rep(temp_column, times = ncol(fluorescence_data)),
                        Fluorescence = unlist(fluorescence_data, use.names = FALSE),
                        Variable = rep(names(fluorescence_data), each = nrow(selected_data)))

# Manually adjust the factor levels for the legend order
long_data$Variable <- factor(long_data$Variable, levels = c('250 µM', '125 µM', '62.5 µM', '31.25 µM', '15.63 µM', '7.81 µM', '3.91 µM', '1.95 µM', '0.98 µM', '0.49 µM', '0.24 µM', '0 µM'))

# Plot
plot <- ggplot(long_data, aes(x = Temperature, y = Fluorescence, color = Variable)) +
        geom_line() +
        labs(title = 'Boltzmann Sigmoid Function Applied to Fluorescence Data',
             x = 'Temperature',
             y = 'Normalized Fluorescence (Boltzmann Transformed)') +
        scale_color_discrete(breaks = c('250 µM', '125 µM', '62.5 µM', '31.25 µM', '15.63 µM', '7.81 µM', '3.91 µM', '1.95 µM', '0.98 µM', '0.49 µM', '0.24 µM', '0 µM'))

print(plot)
