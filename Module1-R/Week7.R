albumsales<- read.delim("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/MSc_DA_Code_Files/Datasets/AlbumSales2.dat")
View(albumsales)

library(ggplot2)  # Load the ggplot2 library
library(Hmisc)    # Load the Hmisc library
library(polycor)  # Load the polycor library
library(boot)     # Load the boot library
library(Rcmdr)    # Load the Rcmdr library
library(ggm)      # Load the ggm library

adsales <- ggplot(albumsales, aes(adverts,sales))
adsales + geom_point()
cor.test(albumsales$adverts,albumsales$sales, 
         alternative="two.sided", method="pearson", conf.level=.95)

albumsales$adverts <- as.numeric(albumsales$adverts)
albumsales$sales <- as.numeric(albumsales$sales)

al2 <- lm(sales ~ adverts, data = albumsales)
summary(al2)

al3 <- lm(sales ~ adverts+airplay+attract, data = albumsales)
summary(al3)

AlbumSales2$standardres <- rstandard(al3)
View(AlbumSales2)

AlbumSales2$largeres <- AlbumSales2$standardres > 2 | AlbumSales2$standardres < -2
sum(AlbumSales2$largeres)


AlbumSales2$vlargeres <- AlbumSales2$standardres > 2 | AlbumSales2$standardres < -2
sum(AlbumSales2$largeres)

AlbumSales2$cook <- cooks.distance(al3)
sum(AlbumSales2$largeres)


as.data.frame(data("mtcars"))

View(mtcars)
gmt <- lm(mpg ~ . , data = mtcars)
summary(gmt)

step(gmt, direction = "backward")


fmt <- lm(mpg ~ 1, data = mtcars)
summary(fmt)
step(fmt, direction = "forward", scope = formula(gmt))


step(fmt, direction = "both", scope = formula(gmt))