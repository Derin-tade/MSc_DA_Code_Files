# Load the ggplot2 library for data visualization
library(ggplot2)

# Read datasets into data frames
fordgobike <- read.csv("C:/Users/hp/Desktop/For_PJ/Data Science/ALX_PROJECTS/Derin_s_Project_3_Re-Submission/Derin's Project 3 Re-Submission/201902-fordgobike-tripdata.csv")
titanic <- read.csv("C:/Users/hp/Desktop/For_PJ/KreativeStorm/Datasets/Titanic_R.csv")
bthwt <- read.csv("C:/Users/hp/Desktop/For_PJ/KreativeStorm/Datasets/Birthweight_reduced_kg_R.csv")

# View the loaded data frames (not shown in the comment)

# Attach the fordgobike data frame for easier access
attach(fordgobike)

# Create a scatter plot of "mage" (Mother's Age) against "Birthweight"
scatter <- ggplot(bthwt, aes(mage, Birthweight))
scatter + geom_point()  # Add points to the plot

# Enhance the scatter plot by adding labels for axes
scatter + geom_point() + labs(x = "Mother's Age", y = "Baby Weight")

# Create a scatter plot of "Length" (Baby's Length) against "Birthweight"
weightvslength <- ggplot(bthwt, aes(Length, Birthweight))
weightvslength + geom_point()  # Add points to the plot

# Create a scatter plot with color differentiation based on "mage35" variable
scatter2 <- ggplot(bthwt, aes(mage, Birthweight, colour = mage35))
scatter2 + geom_point()

# Create a scatter plot with color differentiation based on "mage35" for "Length" vs. "Birthweight"
scatter2 <- ggplot(bthwt, aes(Length, Birthweight, colour = mage35))
scatter2 + geom_point()

# Enhance the "weightvslength" plot by adding a regression line and labels
weightvslength + geom_point() + labs(x = "Baby's Length", y = "Baby's Weight") +
  geom_smooth(method = "lm", colour = "Red", fill = "Blue", alpha = 0.1)

# Create a histogram of "duration_sec" from the fordgobike dataset
fgbhist <- ggplot(fordgobike, aes(duration_sec)) + geom_histogram(binwidth = 2000) + labs(x = "Ride Duration in seconds")

# Create a box plot of "duration_sec" against "user_type" in the fordgobike dataset
fgbbox <- ggplot(fordgobike, aes(user_type, duration_sec))
fgbbox + geom_boxplot() + labs(x = "User Type", y = "Frequency")

# Load another dataset "mkd4b" and view it (not shown in the comment)
mkd4b <- read.csv("C:/Users/hp/Desktop/For_PJ/Data Science/30 Days SQL Challenge/DataSets/Marketing Data.csv")
View(mkd4b)

# Create a bar plot of "balance" grouped by "education" in the "mkd4b" dataset
edbal_bar <- ggplot(mkd4b, aes(education, balance))
edbal_bar + stat_summary(fun.y = "mean", geom = "bar", fill = "skyblue", colour = "black") +
  stat_summary(fun.data = "mean_cl_normal", geom = "errorbar", width = 0.3)

# Create a multivariate bar plot using "education" and "housing" as variables
barsev <- ggplot(mkd4b, aes(education, balance, fill = housing))
barsev + stat_summary(fun.y = mean, geom = "bar", position = "dodge") +
  stat_summary(fun.data = "mean_cl_normal", geom = "errorbar", position = position_dodge(width = 0.9), width = 0.2) +
  scale_fill_manual("housing", values = c("yes" = "Green", "no" = "Blue"))

# Create a facet-wrapped bar plot based on "education" and "housing"
barsev2 <- ggplot(mkd4b, aes(education, balance, fill = education))
barsev2 + stat_summary(fun.y = mean, geom = "bar") +
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", width = 0.2) +
  facet_wrap(~housing)

# Create a facet-wrapped bar plot without the legend
barsev2 + stat_summary(fun.y = mean, geom = "bar") +
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", width = 0.2) +
  facet_wrap(~housing) + theme(legend.position = "none")


# Read in hiccups data
hiccupss <- read.delim("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/MSc_DA_Code_Files/Datasets/Hiccups.dat")
View(hiccupss)

#stack hiccups data
hiccups_stack <- stack(hiccupss)
View(hiccups_stack)

#rewrite names of the columns
names(hiccups_stack) <- c("Hiccups","Intervention")
View(hiccups_stack)


line <- ggplot(hiccups_stack, aes(Intervention, Hiccups))
line +stat_summary(fun.y=mean, geom="point")+stat_summary(fun.y=mean, geom="line",aes(group=3), colour="Blue",
                                                          linetype=3)

line +stat_summary(fun.y=median, geom="point")+
  stat_summary(fun.y=median, geom="line",aes(group=3), colour="Blue",linetype="dashed")+
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", width = 0.1)+
  labs(title = "Hiccups and Intervention Methods")+ theme(plot.title =element_text(hjust = 0.5))

#read in text message
textmes <- read.delim("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/MSc_DA_Code_Files/Datasets/TextMessages.dat")
View(textmes)

#Use the melt function to make "Baseline" and "Six_months" in to one column
melted_textmes <- melt(textmes, id="Group", measured=c("Baseline","Six_months"))
View(melted_textmes)

names(melted_textmes) <- c("Group","Time", "Score")


# Create a line plot object
lineplot <- ggplot(melted_textmes, aes(Time, Score, colour=Group))
lineplot + stat_summary(fun.y=mean,geom="point") +stat_summary(fun.y = mean, geom="line", aes(group=Group))+
  stat_summary(fun.data = mean_cl_boot, geom = "errorbar", width=0.2)+labs(title = "Grammar Test Score")+
  theme(plot.title = element_text(hjust = .5)) +expand_limits(x=0,y=0)


#Creating pie charts
piechart <- ggplot(hiccups_stack,aes(x="",y=Hiccups, fill=Intervention))

piechart + geom_bar(width=1,stat="identity") + coord_polar("y",start = 0, direction = 1) + theme_classic()+
  theme_void()
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/hiccups_pie.png")

#install haven 
install.packages("haven")
library(haven)