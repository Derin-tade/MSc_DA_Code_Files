x<- c("20-30", "30-40", "40-50", "50-60", "60-70", "70-80")
f<- c(6,18,11,11,3,1)
midpoint<- c(25,35,45,55,65,75)

# define dataframe object with lists created above
statdata<- data.frame(x=x,f=f,X=midpoint,fx=f*midpoint)
View(statdata)

# calculate sample mean
samplemean<-sum(statdata$fx)/sum(statdata$f)

#create new column for X-samplemean
statdata$X_xbar <- statdata$X-samplemean 

#create new column to sum multiply sample size and X(or midpoint)-samplemean
statdata$fX_xbar2 <- statdata$f*((statdata$X_xbar)^2)

#statdata <- subset(statdata, select = -fX_xbar)

#calculate variance and standard deviation
samplevar <- sum(statdata$fX_xbar2/(length(f)-1))
samplestd <- sqrt(samplevar)
