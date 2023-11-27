library(ggplot2)

# Read the specific columns from the CSV file
concentration_data <- read.csv('Template-Normalization.csv', skip = 87, nrows = 13, header = TRUE)[, 16]
percent_unfolded_data <- read.csv('Template-Normalization.csv', skip = 87, nrows = 13, header = TRUE)[, 17]

# Convert the concentration data to numeric
concentration_data <- as.numeric(gsub("[^0-9.]", "", concentration_data))

# Apply logarithmic transformation to the concentration data
log_concentration <- log10(concentration_data)

# Combine the data into a new dataframe
plot_data <- data.frame(Concentration = log_concentration, PercentUnfolded = percent_unfolded_data)

# Remove rows with missing values
plot_data <- na.omit(plot_data)

# Create the plot with a trendline
ggplot(plot_data, aes(x = Concentration, y = PercentUnfolded)) +
    geom_point() +  # Scatter points
    geom_smooth(method = "loess", formula = "y ~ x", se = FALSE, color = "blue") +  # Linear model trendline
    labs(title = "Unfolding Percentage depending on Maltose Concentration",
         x = "Log Maltose Concentration (µM)",
         y = "% Unfolded") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

