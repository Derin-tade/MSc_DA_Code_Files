View (traveldf)
install.packages("Hmisc","polycor","boot","Rcmdr","ggm")
library(ggplot2, Hmisc, polycor, boot, Rcmdr, ggm)
apply(traveldf)
scatter <- ggplot(traveldf, aes(NumberOfPersonVisiting, NumberOfFollowups))
scatter + geom_point() + geom_smooth(method = "lm", colour = "Red", fill = "Blue", alpha = 0.1)

cor(traveldf$NumberOfPersonVisiting, traveldf$NumberOfFollowups, use = "complete.obs", method = "pearson")

cor(traveldf[sapply(traveldf, is.numeric)], use = "complete.obs", method = "pearson")

cor.test(traveldf$NumberOfPersonVisiting, traveldf$NumberOfFollowups, alternative = "two.sided", method = "pearson", conf.level = .95)


Hmisc::rcorr(as.matrix(traveldf[sapply(traveldf, is.numeric)]),type="pearson")


cor(traveldf$OwnCar, traveldf$CityTier, use = "everything", method = "spearman")

cor.test(traveldf$OwnCar, traveldf$CityTier,  method = "spearman")


Hmisc::rcorr(as.matrix(traveldf[sapply(traveldf, is.numeric)]),type="spearman")


cor(traveldf$OwnCar, traveldf$CityTier, use = "everything", method = "kendall")

cor.test(traveldf$OwnCar, traveldf$CityTier,  method = "kendall")


shapiro.test(traveldf$OwnCar)
