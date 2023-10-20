x<- c("20-30", "30-40", "40-50", "50-60", "60-70", "70-80")
f<- c(6,18,11,11,3,1)
midpoint<- c(25,35,45,55,65,75)

statdata<- data.frame(x=x,f=f,X=midpoint,fx=f*midpoint)
View(statdata)
samplemean<-sum(statdata$fx)/sum(statdata$f)
statdata$X_xbar <- statdata$X-samplemean 
statdata$fX_xbar2 <- statdata$f*((statdata$X_xbar)^2)
#statdata <- subset(statdata, select = -fX_xbar)
samplevar <- sum(statdata$fX_xbar2/(length(f)-1))
samplestd <- sqrt(samplevar)
