childaggress <- read.delim("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/MSc_DA_Code_Files/Datasets/ChildAggression.dat", sep = " ")  # Read data from a .dat file using read.delim function
View(childaggress)  # View the contents of the data frame

library(Hmisc)    # Load the Hmisc library
library(polycor)  # Load the polycor library
library(boot)     # Load the boot library
library(Rcmdr)    # Load the Rcmdr library
library(ggm)      # Load the ggm library

# Create an empty list to store the plots
plots_list <- list()

# Define the independent variables in our dataframe
independent_vars <- c("Parenting_Style", "Computer_Games", "Television", "Diet", "Sibling_Aggression")

# Loop through each independent variable and create plots
for (var in independent_vars) {
  # Create a plot of y vs. the current independent variable
  plot <- ggplot(childaggress, aes_string(x = var, y = "Aggression")) +
    geom_point(alpha = 0.5, colour = "Blue") +
    geom_smooth(method = "lm", colour = "Red", fill = "Blue", alpha = 0.1) +
    ggtitle(paste("Scatter Plot of Aggression vs.", var)) +
    theme(plot.title = element_text(hjust = 0.5))
  
  ggsave(paste("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Aggression_vs_", var, "pie.png"))
  
  # Add the plot to the list
  plots_list[[var]] <- plot
}

# Display the plots
for (var in independent_vars) {
  print(plots_list[[var]])
}

# Create a scatter plot for 'Television' vs 'Aggression'
aggtv <- ggplot(childaggress, aes(x = Television, y = Aggression))
aggtv + geom_point(alpha = 0.5, colour = "Blue")

# View help documentation for 'geom_point' function
help("geom_point")

# Create a new column 'Screen_Time' by adding 'Television' and 'Computer_Games'
childaggress$Screen_Time <- childaggress$Television + childaggress$Computer_Games

# Create a scatter plot for 'Screen_Time' vs 'Aggression'
agg_vs_scrntm <- ggplot(childaggress, aes(x = Screen_Time, y = Aggression))
agg_vs_scrntm + geom_point(colour = "Blue", alpha = 0.5) + geom_smooth(method = "lm", colour = "Red", fill = "Blue", alpha = 0.05) +
  ggtitle("Scatter Plot of Agrression vs Screen_Time") + theme(plot.title = element_text(hjust = 0.5))

ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Aggression_vs_Screen_Time.png")

# Perform Pearson correlation test between 'Aggression' and 'Screen_Time'
cor.test(childaggress$Aggression, childaggress$Screen_Time, alternative = "two.sided", method = "pearson", conf.level = 0.95)

# Calculate Pearson correlation matrix for all variables in 'childaggress'
cor(childaggress, use = "complete.obs", method = "pearson")
Hmisc::rcorr(as.matrix(childaggress), type = "pearson")

# Create a new data frame 'childaggress2' with selected columns
childaggress2 <- childaggress[, c("Aggression", "Sibling_Aggression", "Diet", "Parenting_Style", "Screen_Time")]
View(childaggress2)

# Perform linear regression on 'Aggression' using selected independent variables
chags_lrm <- lm(Aggression ~ Sibling_Aggression + Parenting_Style + Screen_Time, data = childaggress2)
summary(chags_lrm)

# Calculate standardized residuals and Cook's distances
childaggress2$standardres <- rstandard(chags_lrm)
View(childaggress2)

childaggress2$is_vlargeres <- childaggress2$standardres > 3 | childaggress2$standardres < -3
sum(childaggress2$is_vlargeres)

childaggress2$cook <- cooks.distance(chags_lrm)
childaggress2[childaggress2$is_vlargeres,]
#childaggress2$is_cooked <- childaggress2$cook > 1


test_data <- data.frame(
  Sibling_Aggression = c(1.364),  
  Parenting_Style = c(-0.471),
  Screen_Time = c(0.192)  
)

# Make predictions for aggression using the model and test data
predictions <- predict(chags_lrm, newdata = test_data)