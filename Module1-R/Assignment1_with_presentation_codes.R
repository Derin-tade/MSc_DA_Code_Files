library(readxl)
traveldf <- read_excel("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/MSc_DA_Code_Files/Datasets/Assignment1 Dataset.xlsx", 
                                  sheet = "Assignment Dataset - Main")
View(traveldf)



library(Hmisc)    # Load the Hmisc library
library(polycor)  # Load the polycor library
library(boot)     # Load the boot library
library(Rcmdr)    # Load the Rcmdr library
library(ggm)      # Load the ggm library
library(visdat)   # Load the visdat library
library(ggplot2)  # Load the ggplot2 library
library(dplyr)

# Display the structure of the traveldf (columns, data types)
str(traveldf)

# Get summary statistics for numeric columns
summary(traveldf)

# View the first few rows of the dataset
head(traveldf)

# View the last few rows of the dataset
tail(traveldf)

# Check for missing values
colSums(is.na(traveldf))

# Create a matrix indicating NA values in the dataframe
na_matrix <- is.na(traveldf)
View(na_matrix)


# Convert NA matrix to a numeric matrix (1 for NA, 0 for non-NA)
na_numeric_matrix <- ifelse(is.na(traveldf), 1, 0)


#rename columns for easy referencing, also to make plots a little easy on the eye
# List of old and new column names
column_rename_list <- list("CustomerID" = "id", "Age" = "age", "TypeofContact" = "contact_type",
                           "CityTier" = "city_tier", "Occupation" = "occupation", "Gender" = "gender",
                           "NumberOfPersonVisiting" = "no_of_visitors", "NumberOfFollowups" = "no_followups", 
                           "PreferredPropertyStar" = "pref_prop_star","MaritalStatus" = "marital_stat", "Passport" = "passport", 
                           "PitchSatisfactionScore" = "satisfaction_score","OwnCar" = "own_car",
                           "NumberOfChildrenVisiting" = "no_child_visitors", "Income" = "income",
                           "NumberOfTrips" = "no_of_trips")
# create a copy data to work with moving forward
traveldf_colsrenamed <- traveldf

# Rename columns using the list
names(traveldf_colsrenamed) <- column_rename_list[names(traveldf_colsrenamed)]

View(traveldf_colsrenamed)



# options(repr.plot.width = 120, repr.plot.height = 6)

install.packages('devEMF') # just once
library(devEMF)

setwd("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/")
png(filename="simple_graphic2.png", units="in", res=400, width=10, height=7)
vis_miss(traveldf_colsrenamed, sort_miss = TRUE)
dev.off()
emf(filename="simple_graphic.emf", width=1024, height=800)
vis_miss(traveldf_colsrenamed, sort_miss = TRUE)
dev.off()
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/assignment_Na_tab.png")


#                                         UNIVARIATE PLOTS
# Histograms
# Bar Plots


# histograms for numeric columns
# histogram 1. Age
age_histplot <- ggplot(traveldf_colsrenamed, aes(x = traveldf_colsrenamed$age)) 
age_histplot + geom_histogram(binwidth = 5, colour = "blue") +
  labs(title = "Age Distribution of Customers", x="Age", y="Frequency")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/assignment1_histage.png")

# histogram 2. Number of Visitors
nov_histplot <- ggplot(traveldf_colsrenamed, aes(x = traveldf_colsrenamed$no_of_visitors)) 
nov_histplot + geom_histogram(binwidth = 1, colour = "blue") +
  labs(title = "Distribution of Number of Visitors per Customer", x="Numer of Visitors", y="Frequency")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/assignment1_histnov.png")

# histogram 3. Number of Followups
nof_histplot <- ggplot(traveldf_colsrenamed, aes(x = traveldf_colsrenamed$no_followups)) 
nof_histplot + geom_histogram(binwidth = 1, colour = "blue", fill = "lightblue") +  # Histogram layer +  # Density plot layer) +
  labs(title = "Distribution of Number of Followups per Customer", x="Number of Followups", y="Frequency")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/assignment1_histnof.png")

# histogram 4. Number of Child Visitors
noc_histplot <- ggplot(traveldf_colsrenamed, aes(x = traveldf_colsrenamed$no_child_visitors)) 
noc_histplot + geom_histogram(binwidth = 1, colour = "blue") +
  labs(title = "Distribution of Number of Children Visisting Customers", x="Number of Children Visisting", y="Frequency")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/assignment1_histnoc.png")

# histogram 5. Income
income_histplot <- ggplot(traveldf_colsrenamed, aes(x = traveldf_colsrenamed$income)) 
income_histplot + geom_histogram(binwidth = 1000, colour = "blue") +
  labs(title = "Income Distribution of Customers", x="Income", y="Frequency")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/assignment1_histincome.png")

# histogram 6. Number of Trips
not_histplot <- ggplot(traveldf_colsrenamed, aes(x = traveldf_colsrenamed$no_of_trips)) 
not_histplot + geom_histogram(binwidth = 1, colour = "blue") +
  labs(title = "Distribution of Number of Trips by Customers", x="Number of Trips", y="Frequency")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/assignment1_histnot.png")

#Plot 5 and 6 above indicate presence of outliers 
# treat them using a subset of data without outliers
# we'll use z-scores greater than 3 to detect outliers

#Create copy of the data fr income
traveldf_income_zscore <- traveldf_colsrenamed
# Calculate the z-scores for your column
traveldf_income_zscore$income_zscores <- scale(traveldf_income_zscore$income)

# Filter the dataset based on z-scores greater than 3.29 or less than -3.29
income_filtered_data <- traveldf_income_zscore[abs(traveldf_income_zscore$income_zscores) <= 3.29, ]
View(income_filtered_data)
# histogram 7. Plot the histogram of the filtered data
income_histplot2 <- ggplot(income_filtered_data, aes(x = income_filtered_data$income)) 
income_histplot2 + geom_histogram(binwidth = 1000, colour = "blue") +
  labs(title = "Income Distribution of Customers without Outliers", x="Income", y="Frequency")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/assignment1_histincomefiltered.png")

#Create copy of the data for number of trips(not)
traveldf_not_zscore <- traveldf_colsrenamed
# Calculate the z-scores for your column
traveldf_not_zscore$not_zscores <- scale(traveldf_not_zscore$no_of_trips)

# Filter the dataset based on z-scores greater than 3.29 or less than -3.29
not_filtered_data <- traveldf_not_zscore[abs(traveldf_not_zscore$not_zscores) <= 3.29, ]
View(not_filtered_data)
# histogram 8.Plot the histogram of the filtered data
not_histplot2 <- ggplot(not_filtered_data, aes(x = not_filtered_data$no_of_trips)) 
not_histplot2 + geom_histogram(binwidth = 1, colour = "blue") +
  labs(title = "Distribution of Number of Trips by Customers without Outliers", x="Number of Trips", y="Frequency")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/assignment1_histnotfiltered.png")

# Bar Plots for Categorical Data
# Bar plot 1. Contact Type Without NA's
filtered_data <- na.omit(traveldf_colsrenamed[, c("contact_type")])
ct_barplot <- ggplot(filtered_data, aes(x = contact_type)) 
ct_barplot + geom_bar(fill = "lightblue", color = "black")+
  geom_text(stat = "count", aes(label = ..count..), vjust = -0.5) + 
  labs(title = "Bar Plot Showing Contact Types", x="Contact Types", y="Frequency")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/contact_typebc.png")

# Bar plot 2. City Tier
ctiers_barplot <- ggplot(traveldf_colsrenamed, aes(x = city_tier)) 
ctiers_barplot + geom_bar(fill = "lightblue", color = "black")+
  geom_text(stat = "count", aes(label = ..count..), vjust = -0.5) + 
  labs(title = "Bar Plot Showing City Tiers", x="City Tiers", y="Frequency")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/city_tiers_bc.png")


# Barplot 3. Occupation
occ_barplot <- ggplot(traveldf_colsrenamed, aes(x = occupation)) 
occ_barplot + geom_bar(fill = "lightblue", color = "black")+
  geom_text(stat = "count", aes(label = ..count..), vjust = -0.5) + 
  labs(title = "Bar Plot Showing Occupation Types", x="Occupation", y="Frequency")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/occupation_bc.png")


# Barplot 4. Gender
# Replacing the typo in the 'gender' column
traveldf_colsrenamed$gender <- gsub("Fe Male", "Female", traveldf_colsrenamed$gender)
gender_barplot <- ggplot(traveldf_colsrenamed, aes(x = gender)) 
gender_barplot + geom_bar(fill = "lightblue", color = "black")+
  geom_text(stat = "count", aes(label = ..count..), vjust = -0.5) + 
  labs(title = "Bar Plot Gender Types of Customers", x="Gender", y="Frequency")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/gender_bc.png")


# Barplot 5. Preferred Property Star

pps_barplot <- ggplot(traveldf_colsrenamed, aes(x = pref_prop_star)) 
pps_barplot + geom_bar(fill = "lightblue", color = "black")+
  geom_text(stat = "count", aes(label = ..count..), vjust = -0.5) + 
  labs(title = "Bar Plot of Preferred Property Star Ratings", x="Property Star Ratings", y="Frequency")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/prefpropstar_bc.png")

# Barplot 6. Marital Status
marstat_barplot <- ggplot(traveldf_colsrenamed, aes(x = marital_stat)) 
marstat_barplot + geom_bar(fill = "lightblue", color = "black")+
  geom_text(stat = "count", aes(label = ..count..), vjust = -0.5) + 
  labs(title = "Bar Plot Showing Marital Status", x="Marital Status", y="Frequency")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/marstat_bc.png")


# Barplot 7. Passport
traveldf_colsrenamed$passport <- as.character(traveldf_colsrenamed$passport)
passport_barplot <- ggplot(traveldf_colsrenamed, aes(x = passport)) 
passport_barplot + geom_bar(fill = "lightblue", color = "black")+
  geom_text(stat = "count", aes(label = ..count..), vjust = -0.5) + 
  scale_fill_manual(values = c("1" = "blue", "0" = "red"), labels = c("1" = "Yes", "0" = "No"))+
  labs(title = "Bar Plot Showing Customers with Passports", x="Passport", y="Frequency")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/passpport_bc.png")


# Barplot 8. Pitch Satisfaction Score
pss_barplot <- ggplot(traveldf_colsrenamed, aes(x = satisfaction_score)) 
pss_barplot + geom_bar(fill = "lightblue", color = "black")+
  geom_text(stat = "count", aes(label = ..count..), vjust = -0.5) + 
  labs(title = "Bar Plot Showing Pitch Satisfaction Score of Customers", x="Pitch Satisfaction Score", y="Frequency")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/satscore_bc.png")


# Barplot 9. Own Car
traveldf_colsrenamed$own_car <- as.character(traveldf_colsrenamed$own_car)
owncar_barplot <- ggplot(traveldf_colsrenamed, aes(x = own_car)) 
owncar_barplot + geom_bar(fill = "lightblue", color = "black")+
  geom_text(stat = "count", aes(label = ..count..), vjust = -0.5) + 
  labs(title = "Bar Plot Showing Customers Who Own a Car", x="Own's a Car?", y="Frequency")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/owncar_bc.png")

#                     BIVARIATE PLOTS
#scatter plots of number of trips vs numeric columns
# scatter plot 1. Number of trips vs Age
notvsage <- ggplot(traveldf_colsrenamed, aes(x = age, y = no_of_trips)) 
notvsage + geom_point(alpha = 0.5, colour = "Blue")+
  labs(title = "Number of Trips vs Age", x="Age", y="Number of Trips")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/notvsage.png")

# scatter plot 2. Number of trips vs Number of Visitors
notvsnov <- ggplot(traveldf_colsrenamed, aes(x = no_of_visitors, y = no_of_trips)) 
notvsnov + geom_point(alpha = 0.5, colour = "Blue")+
labs(title = "Number of Trips vs Number of Visitors", x="Number of Visitors", y="Number of Trips")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/notvsnov.png")

# scatter plot 3. Number of trips vs Number of Followups
notvsnof <- ggplot(traveldf_colsrenamed, aes(x = no_followups, y = no_of_trips)) 
notvsnof + geom_point(alpha = 0.5, colour = "Blue")+  
  labs(title = "Number of Trips vs Number of Followups", x="Number of Followups", y="Number of Trips")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/notvsnof.png")

# scatter plot 4. Number of trips vs Number of Child Visitors
notvsnoc <- ggplot(traveldf_colsrenamed, aes(x = no_child_visitors, y = no_of_trips)) 
notvsnoc + geom_point(alpha = 0.5, colour = "Blue") +
  labs(title = "Number of Trips vs Number of Children Visisting", x="Number of Children Visisting", y="Number of Trips")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/notvsnoc.png")

# scatter plot  5. Number of trips vs Income
notvsincome <- ggplot(traveldf_colsrenamed, aes(x = income, y = no_of_trips)) 
notvsincome + geom_point(alpha = 0.5, colour = "Blue") +
  labs(title = "Number of Trips vs Customers Income", x="Income", y="Number of Trips")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/notvsincome.png")

# scatter plot  6. Age vs Income
agevsincome <- ggplot(traveldf_colsrenamed, aes(x = age, y = income)) 
agevsincome + geom_point(alpha = 0.5, colour = "Blue") +
  labs(title = "Customers Age vs Customers Income", x="Age", y="Income")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/agevsincome.png")

# scatter plot  7. Number of Visitors vs Income
novvsincome <- ggplot(traveldf_colsrenamed, aes(x = no_of_visitors, y = income)) 
novvsincome + geom_point(alpha = 0.5, colour = "Blue") +
  labs(title = "Number of Visitors vs Customers Income", x="Number of Visitors", y="Income")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/novvsincome.png")

# scatter plot 8. Number of trips vs Number of Child Visitors
novvsnoc <- ggplot(traveldf_colsrenamed, aes(x = no_child_visitors, y = no_of_visitors)) 
novvsnoc + geom_point(alpha = 0.5, colour = "Blue") +
  labs(title = "Number of Visitors vs Number of Children Visiting", x="Number of Children Visiting", y="Number of Visitors")+
  theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold"))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/novvsnoc.png")

# Create an empty list to store the plots
plots_list <- list()

# Define the independent variables in our dataframe
catcol_list <- c("contact_type", "city_tier", "occupation", "gender", "pref_prop_star",
                 "marital_stat", "passport", "satisfaction_score", "own_car")
catcol_list <- c("gender")
# fix female gender errors in the data frames
not_filtered_data$gender <- gsub("Fe Male", "Female", not_filtered_data$gender)
income_filtered_data$gender <- gsub("Fe Male", "Female", income_filtered_data$gender)


# Function to calculate mode
get_mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

# Loop through each independent variable and create plots
for (var in catcol_list) {
  
  # Convert the column to character
  not_filtered_data <- not_filtered_data %>%
    mutate(!!var := as.character(!!sym(var)))
  
  # Calculate mean, median, and mode
  summary_stats <- not_filtered_data %>%
    group_by(!!sym(var)) %>%
    summarise(mean_value = mean(no_of_trips, na.rm = TRUE),
              median_value = median(no_of_trips, na.rm = TRUE),
              mode_value = get_mode(no_of_trips))
  # Create a plot of y vs. the current independent variable
  plot <- ggplot(na.omit(not_filtered_data), aes_string(x = var, y = "no_of_trips")) +
    geom_boxplot() +
    labs(x = var, y = "Number of Trips") +
    ggtitle(paste("Box Plot of Number of Trips vs", var)) +
    theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold")) 
    # geom_text(data = summary_stats, aes(label = paste("Mean:", round(mean_value, 2)),
    #                                     y = mean_value), vjust = -1.5, color = "blue") +
    # # geom_text(data = summary_stats, aes(label = paste("Median:", round(median_value, 2)),
    # #                                     y = median_value), vjust = -1.5, color = "green") +
    # geom_text(data = summary_stats, aes(label = paste("Mode:", round(mode_value, 2)),
  png(filename=paste(var,"simple_graphic2.png"), units="in", res=400, width=3, height=2.24)                                      # y = mode_value), vjust = -1.5, color = "red")
  plot
  dev.off()
  ggsave(paste("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/not_vs_", 
               var, ".png"))
  
  # Add the plot to the list
  plots_list[[var]] <- plot
}

# Display the plots
for (var in catcol_list) {
  print(plots_list[[var]])
}





#box plots of income vs categorical columns
#we'll be using the version of the dataset without outliers in the number of trips column

# Function to calculate mode
get_mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

# Loop through each independent variable and create plots
for (var in catcol_list) {
  
  # Convert the column to character
  not_filtered_data <- not_filtered_data %>%
    mutate(!!var := as.character(!!sym(var)))
  
  # Calculate mean, median, and mode
  summary_stats <- not_filtered_data %>%
    group_by(!!sym(var)) %>%
    summarise(mean_value = mean(no_of_trips, na.rm = TRUE),
              median_value = median(no_of_trips, na.rm = TRUE),
              mode_value = get_mode(no_of_trips))
  
  # Create a plot of y vs. the current independent variable
  plot <- ggplot(na.omit(not_filtered_data), aes_string(x = var, y = "no_of_trips")) +
    geom_boxplot() +
    labs(x = var, y = "Number of Trips") +
    ggtitle(paste("Box Plot of Number of Trips vs", var)) +
    theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold")) +
    # geom_text(data = summary_stats, aes(label = paste("Mean:", round(mean_value, 2)),
    #                                     y = mean_value), vjust = -1.5, color = "blue") +
    # geom_text(data = summary_stats, aes(label = paste("Median:", round(median_value, 2)),
    #                                     y = median_value), vjust = -1.5, color = "green") +
    # geom_text(data = summary_stats, aes(label = paste("Mode:", round(mode_value, 2)),
    #                                     y = mode_value), vjust = -1.5, color = "red")
    # 
  ggsave(paste("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/not_vs_", 
               var, ".png"))
  
  
  # Add the plot to the list
  plots_list[[var]] <- plot
}

# Display the plots
for (var in catcol_list) {
  print(plots_list[[var]])
}


# Loop through each independent variable and create plots
for (var in catcol_list) {
  
  # Convert the column to character
  income_filtered_data <- income_filtered_data %>%
    mutate(!!var := as.character(!!sym(var)))
  
  # Calculate mean, median, and mode
  summary_stats <- income_filtered_data %>%
    group_by(!!sym(var)) %>%
    summarise(mean_value = mean(income, na.rm = TRUE),
              median_value = median(income, na.rm = TRUE),
              mode_value = get_mode(income))
  
  # Create a plot of y vs. the current independent variable
  plot <- ggplot(na.omit(income_filtered_data), aes_string(x = var, y = "income")) +
    geom_boxplot() +
    labs(x = var, y = "Number of Trips") +
    ggtitle(paste("Box Plot of Number of Trips vs", var)) +
    theme(plot.title = element_text(hjust = 0.5, size = rel(1), face = "bold")) 
    # geom_text(data = summary_stats, aes(label = paste("Mean:", round(mean_value, 2)),
    #                                     y = mean_value), vjust = -1.5, color = "blue") +
    # geom_text(data = summary_stats, aes(label = paste("Median:", round(median_value, 2)),
    #                                     y = median_value), vjust = -1.5, color = "green") +
    # geom_text(data = summary_stats, aes(label = paste("Mode:", round(mode_value, 2)),
    #                                     y = mode_value), vjust = -1.5, color = "red")
    # 
    #ggsave(paste("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/Pictures/Module1 Assignment1 Pictures/not_vs_", 
   #              var, ".png"))
  
  
  # Add the plot to the list
  plots_list[[var]] <- plot
}

# Display the plots
for (var in catcol_list) {
  print(plots_list[[var]])
}




# Get the column names
column_names <- colnames(traveldf_colsrenamed)

# Get the column names and convert to a list
column_names_list <- as.list(colnames(traveldf_colsrenamed))


# Loop through each column
for (col in column_names) {
  # Check if the column is not numeric
  if (!is.numeric(traveldf_colsrenamed[[col]])) {
    cat("Column:", col, "\n")
    cat("Unique Values:", unique(traveldf_colsrenamed[[col]]), "\n\n")
  }
}



# create a copy of travel_df for correlation
traveldf_corr <- traveldf_colsrenamed

#Convert the variables into numerical variables
traveldf_corr$contact_type <- as.numeric(factor(traveldf_corr$contact_type , 
    levels = c("Self Enquiry","Company Invited")))
traveldf_corr$occupation <- as.numeric(factor(traveldf_corr$occupation , 
    levels = c("Salaried", "Free Lancer","Small Business","Large Business")))
traveldf_corr$gender <- as.numeric(factor(traveldf_corr$gender , 
    levels = c("Female", "Male")))
traveldf_corr$marital_stat <- as.numeric(factor(traveldf_corr$marital_stat , 
    levels = c("Single", "Divorced","Married","Unmarried")))
traveldf_corr$passport <- as.numeric(factor(traveldf_corr$passport , 
    levels = c("1", "0")))
traveldf_corr$own_car <- as.numeric(factor(traveldf_corr$own_car , 
    levels = c("1", "0")))


# use for loop to check if we still have any character columns in traveldf_corr
for (col in column_names) {
  # Check if the column is not numeric
  if (!is.numeric(traveldf_corr[[col]])) {
    cat("Column:", col, "\n")
    cat("Unique Values:", unique(traveldf_corr[[col]]), "\n\n")
  }
}


# checks to see it worked
unique(traveldf_corr$contact_type)
View(traveldf_corr)


#                         CORRELATION PLOT
# Get the names of the columns/variables in your dataframe
vars <- names(traveldf_corr)
# Initialize empty matrices to store correlation coefficients and p-values
cor_matrix <- matrix(NA, ncol = length(vars), nrow = length(vars))
p_value_matrix <- matrix(NA, ncol = length(vars), nrow = length(vars))
# Set column and row names to original column names
dimnames(cor_matrix) <- list(vars, vars)
dimnames(p_value_matrix) <- list(vars, vars)
# Loop through each pair of variables and calculate the correlation and p-value
for (i in 1:length(vars)) {
  for (j in 1:length(vars)) {
    # Compute correlation and test for significance
    test_result <- cor.test(traveldf_corr[[i]], traveldf_corr[[j]], method = "pearson", use = "complete.obs")
    # Store correlation coefficient in the correlation matrix
    cor_matrix[i, j] <- cor(traveldf_corr[[i]], traveldf_corr[[j]], use = "complete.obs")
    # Store p-value in the p-value matrix
    p_value_matrix[i, j] <- test_result$p.value
  }
}
View(cor_matrix)
View(p_value_matrix)
# Export the correlation matrix to a CSV file
write.csv(cor_matrix, 
file = "C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/MSc_DA_Code_Files/Module1-R/correlation_matrix.csv")
# Export the p-value matrix to a CSV file
write.csv(p_value_matrix, 
file = "C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/MSc_DA_Code_Files/Module1-R/p_value_matrix.csv")


# Now let's build our model.
# first let's treat the NA values
# We'll create a copy of our  traveldf_corr

traveldf_model <- traveldf_colsrenamed

library(DMwR2)

# Assuming 'your_data_frame' is your dataframe and 'column_with_NAs' is the column with missing values
# Replace 'your_data_frame' and 'column_with_NAs' with your actual data and column name

# Check for missing values
colSums(is.na(traveldf_model))

# check current structure of codes
str(traveldf_model)

#to help make the model building easy I will make all non-numeric columns into factors
traveldf_model <- mutate_if(traveldf_model, is.character, as.factor)

# check new structure of columns
str(traveldf_model)

library(VIM)
# it's advisable to arrange the variables with missing columns from the smallest number of NA's
# to the largest to reduce the influence of imputed data in our model
traveldf_no_na <- kNN(traveldf_model, k=5, 
                      variable = c("contact_type","pref_prop_star","no_followups",
                       "no_child_visitors","no_of_trips","age","income"))

# Check for missing values
colSums(is.na(traveldf_no_na))
View(traveldf_no_na)

# It's time to build our model using the variables that are significantly correlated with
# our target variables
# The initial model is set to take in the predictor variables in order of strength of correlation
tripping_mlrm <- lm(no_of_trips ~ no_of_visitors + age + no_child_visitors + 
                    income + no_followups + marital_stat + city_tier, 
                    data = traveldf_no_na)
# now lets evaluate the initial model
summary(tripping_mlrm)

#creating another checkpoint_data to work with moving forward
traveldf_lrmres <- traveldf_no_na


traveldf_lrmres$standardres <- rstandard(tripping_mlrm)
View(traveldf_lrmres)

# Calculate the percentage of values greater than 2.5 in standardres
percentage_gt_2.5 <- mean(traveldf_lrmres$standardres > 2.5) * 100
percentage_gt_2.5
# slightly above 1% so will be left alone

# Calculate the percentage of values greater than 3 in standardres
percentage_gt_3 <- mean(traveldf_lrmres$standardres > 3) * 100
percentage_gt_3
#all instances greater than 3 will be dropped moving forward



# Check the percentage of values greater than 3 in standardres
percentage2_gt_3 <- mean(traveldf_lrmres_ls3$standardres > 3) * 100
percentage2_gt_3

#Now let's check for the cook distance
traveldf_lrmres$cook <- cooks.distance(tripping_mlrm)
pct_cooks_gt_1 <- mean(traveldf_lrmres$cook > 1) * 100
pct_cooks_gt_1
#No influential Cook's distance
 # let's also check for multicollinearity
# Install the package if you haven't already: install.packages("car")
library(car)

# Calculate VIF for the model
vif_result <- car::vif(tripping_mlrm)
vif_result


#Now let's take out the cases of standardres > 3 then rebuild our model
# Drop rows where standardres > 3
traveldf_lrmres_ls3 <- traveldf_lrmres[traveldf_lrmres$standardres <= 3, ]

tripping_mlrm2 <- lm(no_of_trips ~ no_of_visitors + age + no_child_visitors + 
                      income + no_followups + marital_stat + city_tier, 
                    data = traveldf_lrmres_ls3)
# now lets evaluate the initial model
summary(tripping_mlrm2)
vif_result2 <- car::vif(tripping_mlrm2)
vif_result2
#After dropping the outliers our model changes a bit,
# Adjusted R-squared moved from 0.0756 to 0.0827
# the significance of the cit_tier column also dropped i.e it now has a p-value>0.05
#now let's create a new model with just these 4 variables to see how it performs
tripping_mlrm3 <- lm(no_of_trips ~ no_of_visitors + age + no_child_visitors + 
                        no_followups, 
                     data = traveldf_lrmres_ls3)
summary(tripping_mlrm3)

#let's use the all-subset method to find the best model based on the 
#model created above
library(leaps)

# Run all-subset regression
all_subsets <- regsubsets(no_of_trips~no_of_visitors + age + no_child_visitors + 
                            income + no_followups + marital_stat + city_tier, 
                          data = traveldf_lrmres_ls3)

summary(all_subsets)

res.sum <- summary(all_subsets)
data.frame(
  Adj.R2 = which.max(res.sum$adjr2),
  CP = which.min(res.sum$cp),
  BIC = which.min(res.sum$bic)
)


# Choose the best model based on some criterion (e.g., adjusted R-squared)
best_model <- summary(all_subsets)$which[which.max(summary(all_subsets)$adjr2), ]

# Extract the variables in the best model
best_model_variables <- names(best_model)[-1]
best_model_variables

# Refit the model using the selected variables
# The best_model  uses all initial 7 predictors.
# On that note we will stick with the model created with the residual outliers

# Now let's test our model with the values in the test scenario fil'
traveldf_test <- read_excel("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/MSc_DA_Code_Files/Datasets/Assignment1 Dataset.xlsx", 
                       sheet = "Test Scenarios")

# List of old and new column names
column_rename_list <- list("Case" = "id", "Age" = "age", "TypeofContact" = "contact_type",
                           "CityTier" = "city_tier", "Occupation" = "occupation", "Gender" = "gender",
                           "NumberOfPersonVisiting" = "no_of_visitors", "NumberOfFollowups" = "no_followups", 
                           "PreferredPropertyStar" = "pref_prop_star","MaritalStatus" = "marital_stat", "Passport" = "passport", 
                           "PitchSatisfactionScore" = "satisfaction_score","OwnCar" = "own_car",
                           "NumberOfChildrenVisiting" = "no_child_visitors", "Income" = "income",
                           "NumberOfTrips" = "no_of_trips")
# create a copy data to work with moving forward
traveldf_test_colsrenamed <- traveldf_test

# Rename columns using the list
names(traveldf_test_colsrenamed) <- column_rename_list[names(traveldf_test_colsrenamed)]

View(traveldf_test_colsrenamed)

# Extract the columns used in the model
cols_used <- c("no_of_visitors", "age", "no_child_visitors", "no_followups")

# Make predictions on the test dataset using the specified columns
predictions <- predict(tripping_mlrm3, newdata = traveldf_test_colsrenamed[, cols_used])

# Append the predictions to the test dataset
traveldf_test_colsrenamed$predicted_no_of_trips <- predictions
traveldf_test_colsrenamed$Rpredicted_no_of_trips <- round(predictions,0)
View(traveldf_test_colsrenamed)

#Export to excel
write.csv(traveldf_test_colsrenamed,
    file = "C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/MSc_DA_Code_Files/Module1-R/traveldf_pred.csv")




#### CODES FOR PRESENTATION
traveldf_freelance <- traveldf_colsrenamed[traveldf_colsrenamed$occupation == "Free Lancer", ]
View(traveldf_freelance)
write.csv(traveldf_freelance,
          file = "C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/MSc_DA_Code_Files/Module1-R/traveldf_freelance.csv")

# Get unique values in the 'occupation' column
unique_occupations <- unique(traveldf_colsrenamed$occupation)
unique_occupations


traveldf_10plustrips <- traveldf_colsrenamed[traveldf_colsrenamed$no_of_trips >= 10 & complete.cases(traveldf_colsrenamed), ]
View(traveldf_10plustrips)
write.csv(traveldf_10plustrips,
          file = "C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/Module 1/MSc_DA_Code_Files/Module1-R/traveldf_10plustrips.csv")
