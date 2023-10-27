#read in Data
essay_marks <- read.delim("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/MSc_DA_Code_Files/Datasets/EssayMarks.dat")
View(essay_marks)
library(ggplot2)
# Draw a scatter plot which shows Essay Marks and Hours of study
marksnhours <- ggplot(essay_marks, aes(hours, essay))
marksnhours + geom_point()+
  ggtitle("Scatter Plot of Essay Marks vs. Hours of Study")+
  theme(plot.title = element_text(hjust = .5))

# Draw a regression linear line for the above graph
marksnhours+geom_point()+geom_smooth(method = "lm") +
  ggtitle("Linear Regression Line")+
  theme(plot.title = element_text(hjust = .5))

# Draw a regression linear line showing the 95% confidence interval
marksnhours+geom_point()+geom_smooth(method = "lm", level = 0.95)+
  ggtitle("Linear Regression Line with 95% Confidence Interval")+
  theme(plot.title = element_text(hjust = .5))

# Draw a curved regression line for the above graph
marksnhours+geom_point()+geom_smooth(method = "lm", formula = y ~ poly(x,2)) +
  ggtitle("Curved (Polynomial) Regression Line")+
  theme(plot.title = element_text(hjust = .5))

# Draw a regression curved line showing the 95% confidence interval
marksnhours+geom_point()+geom_smooth(method = "lm", formula = y ~ poly(x,2)) +
  ggtitle("Curved (Polynomial) Regression Line with 95% Confidence Interval")+
  theme(plot.title = element_text(hjust = .5))

# Draw the above graphs in filled triangles
marksnhours <- ggplot(essay_marks, aes(hours, essay))
marksnhours + geom_point(shape = 17, fill = "blue", color = "blue", size = 3)+
  ggtitle("Scatter Plot of Essay Marks vs. Hours of Study")+
  theme(plot.title = element_text(hjust = .5))



# Draw the scatter plot which also shows the grades
marksnhours <- ggplot(essay_marks, aes(hours, essay, colour=grade))
marksnhours + geom_point(shape=17)
ggtitle("Scatter Plot of Essay Marks vs. Hours of Study Showing Grades")+
  theme(plot.title = element_text(hjust = .5))


# Draw a histogram for the Essay Marks variable
essayhist <- ggplot(essay_marks, aes(essay)) 
essayhist + geom_histogram() +
  labs(x = "Essay Marks", y = "Frequency") +
  ggtitle("Histogram of Essay Marks")+
  theme(plot.title = element_text(hjust = .5))
# Draw a histogram for the Hours of study variable
essayhist2 <- ggplot(essay_marks, aes(hours)) 
essayhist2 + geom_histogram()+
  labs(x = "Hours of Study", y = "Frequency") +
  ggtitle("Histogram of Hours of Study")+
  theme(plot.title = element_text(hjust = .5))

# Draw a boxplot for the Essay Marks variable
essaybox <- ggplot(essay_marks, aes(essay))
essaybox + geom_boxplot()+
  labs(y = "Essay Marks") +
  ggtitle("Boxplot of Essay Marks")+
  theme(plot.title = element_text(hjust = .5))

# Draw a boxplot for the Hours of study variable
hourbox <- ggplot(essay_marks, aes(hours))
hourbox + geom_boxplot()+
  labs(y = "Hours of Study") +
  ggtitle("Boxplot of Hours of Study")+
  theme(plot.title = element_text(hjust = .5))

# Draw a bar chart for the Hours of study and Essay Marks variables, including error bars
essaybar <- ggplot(essay_marks, aes(grade,essay))
essaybar + stat_summary(fun.y = mean, geom = "bar", position = "dodge") +
  stat_summary( fun.data = mean_cl_normal,geom = "errorbar", width = 0.2)+
  labs(x = "Grade", y = "Mean Essay Marks") +
  ggtitle("Bar Chart of Essay Marks per Grade")+
  theme(plot.title = element_text(hjust = .5))

# Draw bar charts for the Hours of study and Essay Marks variables, including error bars
hoursbar <- ggplot(essay_marks, aes(grade,hours))
hoursbar + stat_summary(fun.y = mean, geom = "bar", position = "dodge") +
  stat_summary( fun.data = mean_cl_normal,geom = "errorbar", width = 0.2)+
  labs(x = "Grade", y = "Mean Hours of Study") +
  ggtitle("Bar Chart of Hours of Study per Grade")+
  theme(plot.title = element_text(hjust = .5))

# Draw Pie Charts for the Hours of study and Essay Marks variables, including error bars
essaypc <- ggplot(essay_marks,aes(x="",y=essay, fill=grade))
essaypc + geom_bar(width=1,stat="identity") + 
  stat_summary( fun.data = mean_cl_normal,geom = "errorbar", width = 0.2) +
  coord_polar("y",start = 0, direction = 1) + theme_classic()+
  theme_void()+
  ggtitle("Pie Chart of Grades vs. Essay Marks")+
  theme(plot.title = element_text(hjust = .5))

hourspc <- ggplot(essay_marks,aes(x="",y=hours, fill=grade))
hourspc + geom_bar(width=1,stat="identity") + 
  stat_summary( fun.data = mean_cl_normal,geom = "errorbar", width = 0.2) +
  coord_polar("y",start = 0, direction = 1) + theme_classic()+
  theme_void()+
  ggtitle("Pie Chart of Grades vs. Hours of Study")+
  theme(plot.title = element_text(hjust = .5))