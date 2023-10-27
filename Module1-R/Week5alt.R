# Read in Data
essay_marks <- read.delim("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/MSc_DA_Code_Files/Datasets/EssayMarks.dat")

# Load the ggplot2 library
library(ggplot2)

# View the dataset (not shown in the comment)

# Scatter Plot of Essay Marks vs. Hours of Study
marksnhours <- ggplot(essay_marks, aes(x = hours, y = essay)) +
  geom_point() +
  labs(x = "Hours of Study", y = "Essay Marks") +
  ggtitle("Scatter Plot of Essay Marks vs. Hours of Study")+
  theme(plot.title = element_text(hjust = .5))
print(marksnhours)

# Linear Regression Line for the Scatter Plot
lm_line <- marksnhours + geom_smooth(method = "lm") +
  ggtitle("Linear Regression Line")+
  theme(plot.title = element_text(hjust = .5))
print(lm_line)

# Linear Regression Line with 95% Confidence Interval
lm_confidence <- marksnhours + geom_smooth(method = "lm", level = 0.95) +
  ggtitle("Linear Regression Line with 95% Confidence Interval")+
  theme(plot.title = element_text(hjust = .5))
print(lm_confidence)

# Curved (Polynomial) Regression Line
curved_lm <- marksnhours + geom_smooth(method = "lm", formula = y ~ poly(x, 2)) +
  ggtitle("Curved (Polynomial) Regression Line")+
  theme(plot.title = element_text(hjust = .5))
print(curved_lm)

# Curved Regression Line with 95% Confidence Interval
curved_lm_confidence <- marksnhours + geom_smooth(method = "lm", formula = y ~ poly(x, 2), level = 0.95) +
  ggtitle("Curved (Polynomial) Regression Line with 95% Confidence Interval")+
  theme(plot.title = element_text(hjust = .5))
print(curved_lm_confidence)

# Bar Chart of Grades vs. Essay Marks
essay_bar <- ggplot(essay_marks, aes(x = grade, y = essay, fill = grade)) +
  geom_bar(stat = "summary", fun.y = "mean", position = "dodge") +
  geom_errorbar(stat = "summary", fun.data = "mean_cl_normal", width = 0.2, position = "dodge") +
  labs(x = "Grade", y = "Mean Essay Marks") +
  ggtitle("Bar Chart of Grades vs. Essay Marks")+
  theme(plot.title = element_text(hjust = .5))
print(essay_bar)

# Histogram of Essay Marks
essay_hist <- ggplot(essay_marks, aes(x = essay)) +
  geom_histogram() +
  labs(x = "Essay Marks", y = "Frequency") +
  ggtitle("Histogram of Essay Marks")+
  theme(plot.title = element_text(hjust = .5))
print(essay_hist)

# Histogram of Hours of Study
hours_hist <- ggplot(essay_marks, aes(x = hours)) +
  geom_histogram() +
  labs(x = "Hours of Study", y = "Frequency") +
  ggtitle("Histogram of Hours of Study")+
  theme(plot.title = element_text(hjust = .5))
print(hours_hist)

# Boxplot of Essay Marks
essay_boxplot <- ggplot(essay_marks, aes(y = essay)) +
  geom_boxplot() +
  labs(y = "Essay Marks") +
  ggtitle("Boxplot of Essay Marks")+
  theme(plot.title = element_text(hjust = .5))
print(essay_boxplot)

# Boxplot of Hours of Study
hours_boxplot <- ggplot(essay_marks, aes(y = hours)) +
  geom_boxplot() +
  labs(y = "Hours of Study") +
  ggtitle("Boxplot of Hours of Study")+
  theme(plot.title = element_text(hjust = .5))
print(hours_boxplot)

# Pie Chart of Grades vs. Essay Marks
essay_piechart <- ggplot(essay_marks, aes(x = "", y = essay, fill = grade)) +
  geom_bar(width = 1, stat = "identity") +
  geom_errorbar(stat = "summary", fun.data = "mean_cl_normal", width = 0.2) +
  coord_polar("y", start = 0, direction = 1) +
  theme_void() +
  ggtitle("Pie Chart of Grades vs. Essay Marks")+
  theme(plot.title = element_text(hjust = .5))
print(essay_piechart)

# Pie Chart of Grades vs. Hours of Study
hours_piechart <- ggplot(essay_marks, aes(x = "", y = hours, fill = grade)) +
  geom_bar(width = 1, stat = "identity") +
  geom_errorbar(stat = "summary", fun.data = "mean_cl_normal", width = 0.2) +
  coord_polar("y", start = 0, direction = 1) +
  theme_void() +
  ggtitle("Pie Chart of Grades vs. Hours of Study")+
  theme(plot.title = element_text(hjust = .5))


# Show the plots


