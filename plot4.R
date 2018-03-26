# 1. READING THE DATA

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# download zip file
download.file(url, destfile = "household_power_consumption.zip")

# expand zip_file and remove the tmp zip file
unzip("household_power_consumption.zip")
file.remove("household_power_consumption.zip")

# read the data into a table 
# As the data is very big, we try to help the read.table function by providing 
# the right arguments, and we restrict to the lines between 66 500 and 70 000  
# (rough estimate)
# The used seperator in the file is ";"
# The nas are denoted by "?"
data <- read.table("household_power_consumption.txt", 
                   sep = ";", na.strings = "?", 
                   skip = 66500, nrows = 3500,  # very rough estimation
                   col.names = c('Date', 'Time', 'Global_active_power',
                                 'Global_reactive_power', 'Voltage',
                                 'Global_intensity', 'Sub_metering_1',
                                 'Sub_metering_2', 'Sub_metering_3'),
                   colClasses = c('character', 'character', 'numeric', 
                                  'numeric', 'numeric', 
                                  'numeric', 'numeric', 
                                  'numeric', 'numeric')
)

# convert values of the two first column into dates and times
date_time_strg <- mapply(FUN = paste, data$Date, data$Time, 
                         MoreArgs = list(sep = " ") , SIMPLIFY = TRUE)
data$Time <- strptime(date_time_strg, format = "%d/%m/%Y %H:%M:%S")
data$Date = as.Date(data$Date, format = "%d/%m/%Y")


# subset the data
# we will only be using data from the dates 2007-02-01 and 2007-02-02
twodaysdata <- subset(data, 
                      Date == as.Date("2007-02-01") | Date == as.Date("2007-02-02"))



# 2. CREATING GRAPH 4 IN FILE PNG DEVICE

# open png file device
# size should be 480 x 480 pixels
# background is transparent in the example files
png(filename = "plot4.png",
    width = 480, height = 480,
    bg = "transparent")

# setting global graph parameters - 2 x 2 plots filled row wise
par(mfrow=c(2,2))

# setting twodaysdata as environement data for the plot commands
with(twodaysdata,
     {
         # PLOT 1 (top left) - similar to plot in plot2.R
         # line plot of Global_active_power over Time
         plot(Time, Global_active_power, 
              type="l", 
              ylab = "Global Active Power",
              xlab = "");
         
         # PLOT 2 (top right) - similar to plot 1 for Voltage
         # line plot of Voltage over Time
         plot(Time, Voltage, 
              type="l", 
              ylab = "Voltage",
              xlab = "datetime");         
         
         # PLOT 3 (bottom left) - similar to plot in plot3.R
         # setting the plot
         plot(Time, Sub_metering_1,
              type="n",
              ylab = "Energy sub metering",
              xlab = "");
         
         # actual line plot of the three submetering variables in different colors
         lines(Time, Sub_metering_1, col = "black");
         lines(Time, Sub_metering_2, col = "red");
         lines(Time, Sub_metering_3, col = "blue");
         
         # adding the legend
         # lwd set to 1 indicates legend that we want to draw lines
         legend("topright",  bty = "n", lwd = 1 ,
                col = c("black", "red", "blue"),
                legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"));
         
         # PLOT 4 (bottom right) - similar to plot 1 and 2
         plot(Time, Global_reactive_power, 
              type="l", 
              xlab = "datetime");
     }
     )

# closing the file device
dev.off()
