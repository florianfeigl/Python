library(ggplot2)

# Read the specific columns from the CSV file
concentration_data <- read.csv('Template-Normalization.csv', skip = 87, nrows = 13, header = TRUE)[, 16]
percent_unfolded_data <- read.csv('Template-Normalization.csv', skip = 87, nrows = 13, header = TRUE)[, 17]

# Convert the concentration data to numeric and remove non-numeric characters
concentration_data <- as.numeric(gsub("[^0-9.]", "", concentration_data))

# Remove any rows where concentration data is not positive or is NA
valid_indices <- concentration_data > 0 & !is.na(concentration_data)
concentration_data <- concentration_data[valid_indices]
percent_unfolded_data <- percent_unfolded_data[valid_indices]

# Apply logarithmic transformation to the concentration data
log_concentration <- log10(concentration_data)

# Combine the data into a new dataframe
plot_data <- data.frame(Concentration = log_concentration, PercentUnfolded = percent_unfolded_data)

# Fit a logistic curve using nonlinear regression
logistic_model <- nls(PercentUnfolded ~ B/(1 + exp((log_EC50 - Concentration) * Slope)), 
                      data = plot_data, 
                      start = list(log_EC50 = median(plot_data$Concentration), 
                                   Slope = 1, B = max(plot_data$PercentUnfolded)),
                      control = nls.control(maxiter = 100))

# Extract the EC50 value
ec50_log_estimate <- coef(logistic_model)["log_EC50"]
ec50_estimate <- 10^ec50_log_estimate

# Print the EC50 value for checking, debugging
#print(paste("EC50 estimate (log scale):", ec50_log_estimate))
#print(paste("EC50 estimate:", ec50_estimate))

# Create the plot with a nonlinear regression line, EC50 line, and EC50 label
if(nrow(plot_data) > 0) {
    plot <- ggplot(plot_data, aes(x = Concentration, y = PercentUnfolded)) +
        geom_point() +
        geom_line(data = data.frame(Concentration = plot_data$Concentration, 
                                    Fit = predict(logistic_model)), aes(y = Fit), color = "blue") +
        geom_vline(xintercept = ec50_log_estimate, linetype = "dashed", color = "grey") +
        annotate("text", x = ec50_log_estimate, y = max(plot_data$PercentUnfolded), 
                 label = paste("EC50: ", round(ec50_estimate, 2), " "), 
                 hjust = 1, vjust = 1, color = "red") +
        labs(title = "Unfolding Percentage depending on Maltose Concentration",
             x = "Log Maltose Concentration (µM)",
             y = "% Unfolded") +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))

    print(plot)
} else {
    stop("No valid data available for plotting.")
}
