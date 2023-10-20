x <- -5
if (x>0) {
  print ("Positive Number")
} else if (x<0){
  print ("Negative number")
} else{
  print ("zero")
}

x <- c(5,7,2,9)
ifelse (x%%2 ==0, "even","odd")

for ( year in 2010:2015){
  print(paste("The year is",year))
}