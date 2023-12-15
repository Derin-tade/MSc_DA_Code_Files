albumsales <- read.delim("C:/Users/hp/Desktop/For_PJ/MSc Data Analytics/MSc_DA_Code_Files/Datasets/AlbumSales2.dat")
View(albumsales)  # View the contents of the 'albumsales' dataset

library(ggplot2)    # Load the ggplot2 library for data visualization
library(Hmisc)      # Load the Hmisc library for advanced statistical functions
library(polycor)    # Load the polycor library for polyserial and polychoric correlations
library(boot)       # Load the boot library for bootstrapping functions
library(Rcmdr)      # Load the Rcmdr library for the R Commander GUI
library(ggm)        # Load the ggm library for graphical methods in statistics

# Create a scatter plot of 'adverts' vs. 'sales'
adsales <- ggplot(albumsales, aes(adverts, sales))
adsales + geom_point()

# Perform a Pearson correlation test between 'adverts' and 'sales' with specified parameters
cor.test(albumsales$adverts, albumsales$sales, 
         alternative = "two.sided", method = "pearson", conf.level = 0.95)

# Convert 'adverts' and 'sales' columns to numeric
albumsales$adverts <- as.numeric(albumsales$adverts)
albumsales$sales <- as.numeric(albumsales$sales)

# Fit a linear regression model 'sales' ~ 'adverts'
al2 <- lm(sales ~ adverts, data = albumsales)
summary(al2)  # Display summary statistics for the regression model

# Fit a linear regression model 'sales' ~ 'adverts + airplay + attract'
al3 <- lm(sales ~ adverts + airplay + attract, data = albumsales)
summary(al3)  # Display summary statistics for the regression model

# Create a new variable 'standardres' for standardized residuals
AlbumSales2$standardres <- rstandard(al3)
View(AlbumSales2)  # View the 'AlbumSales2' dataset with the added variable

# Create a binary variable 'largeres' based on standardized residuals
AlbumSales2$largeres <- AlbumSales2$standardres > 2 | AlbumSales2$standardres < -2
sum(AlbumSales2$largeres)  # Count the occurrences of 'largeres'

# Create a binary variable 'vlargeres' based on standardized residuals
AlbumSales2$vlargeres <- AlbumSales2$standardres > 2 | AlbumSales2$standardres < -2
sum(AlbumSales2$largeres)  # Count the occurrences of 'largeres'

# Create a new variable 'cook' for Cook's distance
AlbumSales2$cook <- cooks.distance(al3)
sum(AlbumSales2$largeres)  # Count the occurrences of 'largeres'

as.data.frame(data("mtcars"))  # Load the 'mtcars' dataset

View(mtcars)  # View the contents of the 'mtcars' dataset

# Fit a linear regression model 'mpg' ~ . (all variables)
gmt <- lm(mpg ~ ., data = mtcars)
summary(gmt)  # Display summary statistics for the regression model

# Perform a backward stepwise variable selection on the regression model 'gmt'
step(gmt, direction = "backward")

# Fit a null model 'mpg' ~ 1 (intercept only)
fmt <- lm(mpg ~ 1, data = mtcars)
summary(fmt)  # Display summary statistics for the null model

# Perform a forward stepwise variable selection on the null model 'fmt'
step(fmt, direction = "forward", scope = formula(gmt))

# Perform a both-direction stepwise variable selection on the null model 'fmt'
step(fmt, direction = "both", scope = formula(gmt))
