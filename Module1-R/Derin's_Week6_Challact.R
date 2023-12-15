examanx <- read.delim2("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/MSc_DA_Code_Files/Datasets/ExamAnxiety.dat")
View(examanx)

#1. Download dataset ‘Exam anxiety’ and complete the tasks below:
examanx$Anxiety <- as.numeric(examanx$Anxiety)
# • Draw a scatter plot between Exam and Anxiety variables
exam_anx <- ggplot(examanx, aes(Exam, Anxiety))
exam_anx + geom_point()  +
  ggtitle("Scatter Plot of Anxiety vs Exam") +
  theme(plot.title = element_text(hjust = .5))
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/exam_anx.png")

# Draw a scatter plot between Exam and Revise variables

exam_rev <- ggplot(examanx, aes(Exam, Revise))
exam_rev + geom_point()  +
  ggtitle("Scatter Plot of Revise vs Exam") +
  theme(plot.title = element_text(hjust = .5))+
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/exam_rev.png")


# Find the Pearson correlations and p-values between all the variables above.
Hmisc::rcorr(as.matrix(examanx[sapply(examanx, is.numeric)]), type = "pearson")


#2. Download dataset ‘Essay Marks’ and complete the tasks below:
essaymarks <- read.delim2("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/MSc_DA_Code_Files/Datasets/EssayMarks.dat")
View(essaymarks)

essaymarks$essay <- as.numeric(essaymarks$essay)
essaymarks$hours <- as.numeric(essaymarks$hours)

#• Draw a scatter plot between Essay and Hours variables
essay_hours <- ggplot(essaymarks, aes(hours,essay))
essay_hours + geom_point()  +
  ggtitle("Scatter Plot of Essay vs Hours") +
  theme(plot.title = element_text(hjust = .5))+
  labs(x = "Hours", y = "Essay") 
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/essay_hours.png")



#• Change the variable Grade into a numerical categorical variable
essaymarks$grade_num <- as.numeric(factor(essaymarks$grade, levels = 
            c("Third Class", "Lower Second Class", "Upper Second Class", "First Class")))

#• Draw the scatter plot between Essay and Grade variables.
essay_grade <- ggplot(essaymarks, aes(grade_num,essay))
essay_grade + geom_point()  +
  ggtitle("Scatter Plot of Essay vs Grade")+
  theme(plot.title = element_text(hjust = .5))+
  labs(x = "Grade", y = "Essay") 
ggsave("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/essay_grade.png")

#Find the correlations between all three variables using appropriate methods (create a table)
cor.test(essaymarks$essay, essaymarks$hours, alternative = "two.sided", method = "pearson", conf.level = 0.95)

cor.test(essaymarks$grade_num, essaymarks$essay, method = "spearman")

cor.test(essaymarks$grade_num, essaymarks$hours, method = "spearman")

#3. Download dataset ‘Film’ and complete the tasks below:
library(readxl)
film <- read_excel("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/MSc_DA_Code_Files/Datasets/film.xlsx")
View(film)

#Convert the variables into numerical variables

film$film_num <- as.numeric(factor(film$film, levels = c("Bridget Jones' Diary", "Memento")))
film$gender_num <- as.numeric(factor(film$gender, levels = c("Male", "Female")))


#Find the correlations between all three variables using appropriate methods (create a table)
cor.test(film$film_num, film$gender_num, method = "kendall")

cor.test(film$enjoyment, film$gender_num, method = "kendall")

cor.test(film$film_num, film$enjoyment, method = "spearman")

#4. Download dataset ‘Trees’ as one of the built-in available datasets in R, and complete the tasks below:
data(trees)
View(trees)




#• Find the correlations between all three variables using appropriate methods (create a table). 
Hmisc::rcorr(as.matrix(trees), type = "pearson")
