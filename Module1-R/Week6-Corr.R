# View the 'traveldf' dataset
library(readxl)
traveldf <- read_excel("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/MSc_DA_Code_Files/Datasets/Assignment1 Dataset.xlsx", 
                       sheet = "Assignment Dataset - Main")
View(traveldf)

# Install necessary packages
install.packages(c("Hmisc", "polycor", "boot", "Rcmdr", "ggm"))

# Load required libraries
library(ggplot2)  # Load the ggplot2 library
library(Hmisc)    # Load the Hmisc library
library(polycor)  # Load the polycor library
library(boot)     # Load the boot library
library(Rcmdr)    # Load the Rcmdr library
library(ggm)      # Load the ggm library

# Apply functions to the 'traveldf' dataset

# Create a scatter plot of 'NumberOfPersonVisiting' vs. 'NumberOfFollowups'
scatter <- ggplot(traveldf, aes(NumberOfPersonVisiting, NumberOfFollowups))
scatter + geom_point() + geom_smooth(method = "lm", colour = "Red", fill = "Blue", alpha = 0.1)

# Calculate the Pearson correlation between 'NumberOfPersonVisiting' and 'NumberOfFollowups'
cor(traveldf$NumberOfPersonVisiting, traveldf$NumberOfFollowups, use = "complete.obs", method = "pearson")

# Calculate the Pearson correlation matrix for all numeric columns
cor(traveldf[sapply(traveldf, is.numeric)], use = "complete.obs", method = "pearson")

# Perform a Pearson correlation test between 'NumberOfPersonVisiting' and 'NumberOfFollowups'
cor.test(traveldf$NumberOfPersonVisiting, traveldf$NumberOfFollowups, alternative = "two.sided", method = "pearson", conf.level = 0.95)

# Calculate the Pearson correlation matrix using Hmisc::rcorr for all numeric columns
Hmisc::rcorr(as.matrix(traveldf[sapply(traveldf, is.numeric)]), type = "pearson")

# Calculate the Spearman correlation between 'OwnCar' and 'CityTier'
cor(traveldf$OwnCar, traveldf$CityTier, use = "everything", method = "spearman")

# Perform a Spearman correlation test between 'OwnCar' and 'CityTier'
cor.test(traveldf$OwnCar, traveldf$CityTier, method = "spearman")

# Calculate the Spearman correlation matrix using Hmisc::rcorr for all numeric columns
Hmisc::rcorr(as.matrix(traveldf[sapply(traveldf, is.numeric)]), type = "spearman")

# Perform a Kendall correlation between 'OwnCar' and 'CityTier'
cor(traveldf$OwnCar, traveldf$CityTier, use = "everything", method = "kendall")

# Perform a Kendall correlation test between 'OwnCar' and 'CityTier'
cor.test(traveldf$OwnCar, traveldf$CityTier, method = "kendall")

# Perform a Shapiro-Wilk normality test on 'OwnCar'
shapiro.test(traveldf$OwnCar)