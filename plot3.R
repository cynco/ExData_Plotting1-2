#Output
##This code makes a line plot, Energy sub metering vs datetime (weekday) with legend for Sub_metering_1 through Sub_metering_3.

##The plot will appear in file plot3.png

#Input
##It requires the data frame df3 that contains 
# POSIXt class column called datetime
# and numeric class column called
#Energy sub metering


###########################
#Download data and generate data frame

##Required packages
library(lubridate)

##Download zip file
myurl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url=myurl, destfile="exdata-data-household_power_consumption.zip", method='curl')
myfile<- unz("exdata-data-household_power_consumption.zip", "household_power_consumption.txt")

#Read header to get column names
header<-read.csv(myfile, nrows=1, sep=";", na.strings=c("?","NA","NaN", " "), header=TRUE)

#Read row of dates to determine indices for rows for Feb 1, 2007
daterow<-read.csv(myfile, sep=";", na.strings=c("?","NA","NaN", " "), colClasses=c("character", rep("NULL", 8)))
indmatching<-which(daterow$Date=="1/2/2007")
indmin<-min(indmatching)
indmax<-max(indmatching)
#Read full data frame for rows for Feb. 1, 2007
df1<-read.csv(myfile, skip=indmin-1, nrows=indmax-indmin+1,  header=FALSE, sep=";", na.strings=c("?","NA","NaN", " "), colClasses=c("character", "character",rep("numeric", 7)))

#Read row of dates to determine indices for rows for Feb 1, 2007
indmatching<-which(daterow$Date=="2/2/2007")
indmin<-min(indmatching)
indmax<-max(indmatching)
#Read full data frame for rows for Feb. 2, 2007
df2<-read.csv(myfile, skip=indmin-1, nrows=indmax-indmin+1,  header=FALSE, sep=";", na.strings=c("?","NA","NaN", " "), colClasses=c("character", "character",rep("numeric", 7)))

#Combine data frames for Feb 1 and Feb 2.
df3<-rbind(df1,df2)
#Assign appropriate column names
names(df3)<-names(header)
#Create datetime column
df3$datetime<-paste(df3$Date, df3$Time)
#Convert to POSIXt class.
df3$datetime<- dmy_hms(df3$datetime)
#Clean up.
rm(header,daterow,indmatching,indmin,indmax,df1,df2)

###########################



###########################

##Plot3
png(filename="plot3.png", width=480, height=480, units="px", type="quartz")
plot(df3$datetime, df3$Sub_metering_1, type="l", ylab="Energy sub metering", xlab="", col="black" )
lines(df3$datetime, df3$Sub_metering_2, col="red")
lines(df3$datetime, df3$Sub_metering_3, col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black","red","blue"), lty=1)

dev.off()