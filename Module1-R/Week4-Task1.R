staffdata <- read.csv("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/MSc_DA_Code_Files/Module1-R/StaffData.csv")
View(staffdata)
#Creating basisc salary column
# Assuming you have a DataFrame named df
staffdata$BasicSalary <- ifelse(staffdata$Job == "Professor", 60000,
                     ifelse(staffdata$Job == "Lecturer", 50000,
                            ifelse(staffdata$Job == "Reader", 40000, NA)))
# staffdata <- subset(staffdata, select = -columJobnB)
install.packages(lubridate)
library(lubridate)

staffdata$JobExperience <- as.numeric(interval(staffdata$StartDate, Sys.Date())%/% years(1))
staffdata$JEsalary <- ifelse(staffdata$JobExperience>=5,1.2*staffdata$BasicSalary,
                             ifelse(staffdata$JobExperience<5,staffdata$BasicSalary,NA))
staffdata$Age <- as.numeric(interval(staffdata$BirthDate, Sys.Date())%/% years(1))
staffdata$Agesalary <- ifelse(staffdata$Age<40,staffdata$BasicSalary,
                             ifelse(staffdata$Age<50,1.1*staffdata$BasicSalary,
                                    ifelse(staffdata$Age>=50,1.2*staffdata$BasicSalary,NA)))
staffdata$carsalary<-staffdata$Agesalary+(staffdata$No.ofCar*12*45)
staffdata$childsalary<-staffdata$carsalary + (staffdata$No.ofChildren*12*80)
staffdata$housesalary<-ifelse(staffdata$HomeOwnership=="Yes",staffdata$childsalary+(150*12),
                              ifelse(staffdata$HomeOwnership=="No",staffdata$childsalary+(200*12),NA))
staffdata$taxedsalary<-ifelse(staffdata$housesalary<30000,staffdata$housesalary-(staffdata$housesalary*.20),
                              ifelse(staffdata$housesalary<45000,staffdata$housesalary-(staffdata$housesalary*.25),
                                     ifelse(staffdata$housesalary<60000,staffdata$housesalary-(staffdata$housesalary*.30),
                                            ifelse(staffdata$housesalary>=60000,staffdata$housesalary-(staffdata$housesalary*.35),NA))))