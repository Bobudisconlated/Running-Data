#load necessary packages
library(ggplot2)
library(lubridate)

#open and assign csv files
setwd("C:/Users/Leanlair/Documents/Data Science/R/RunningData")
Oct14 <- read.csv("2016-10-14 20 mil.csv")
Oct16 <- read.csv("2016-10-16 6.5 mil.csv")
Oct18 <- read.csv("2016-10-18 4.0 mil.csv")
Oct26 <- read.csv("2016-10-26 18 mil.csv")
Nov01 <- read.csv("2016-11-01 10 mil.csv")
Nov02 <- read.csv("2016-11-02 5.5 mil.csv")
Nov06 <- read.csv("2016-11-01 10 mil.csv")

# combine into one data frame
fulldata <- rbind(Oct14,Oct16,Oct18,Oct26,Nov01,Nov02,Nov06)

# convert elevation data to numeric,
# note that the data needs to be converted to numeric before 
# the NA can be replaced with 0
fulldata[fulldata=="--"] <- NA
fulldata$Elev.Gain <- as.numeric(as.character(fulldata$Elev.Gain))
fulldata$Elev.Loss <- as.numeric(as.character(fulldata$Elev.Loss))
fulldata[is.na(fulldata)] <- 0

# delete unnecessary columns
#fulldata$Calories <- NULL
#fulldata$Best.Pace <- NULL
#fulldata$Avg.Moving.Paces <- NULL

# change column names
#colnames(fulldata)[which(names(fulldata) == "Elevation.Gain")] <- "Elev.Gain"
#colnames(fulldata)[which(names(fulldata) == "X..Fat")] <- "PercentFat"
#colnames(fulldata)[which(names(fulldata) == "X..Muscle")] <- "PercentMuscle"
#colnames(fulldata)[which(names(fulldata) == "Mileage.in.previous.week")] <- "Miles(WeeK)"

# use lubridate package to convert average pace to seconds per mile
fulldata$AvgPaceSec <- period_to_seconds(ms(fulldata$Avg.Pace))

# calculate number of heart beats per mile
fulldata$HBPM <- (fulldata$AvgPaceSec/60)*fulldata$Avg.HR 
# calculate total elevation change
fulldata$Elev.Delta <- fulldata$Elev.Gain-fulldata$Elev.Loss

# create subset of data: one mile distances and elevation -50 to 50
int.data <- subset(fulldata, Distance == 1)
int.data2 <- subset(int.data, Elev.Delta > -20)
fulldata.sub <- subset(int.data2, Elev.Delta < 20)

# plot average pace v average heart rate
qplot(data=fulldata.sub, x=Avg.HR, y=AvgPaceSec, color=Elev.Delta)
# plot average pace v heart beats per mile
qplot(data=fulldata.sub, x=AvgPaceSec, y=Splits, color=Elev.Delta, size=Avg.HR)

grph1 <- ggplot(data=fulldata.sub,aes(x=Elev.Delta,y=AvgPaceSec))
grph1 + geom_point()
