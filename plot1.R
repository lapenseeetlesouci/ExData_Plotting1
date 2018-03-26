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



# 2. CREATING GRAPH 1 IN FILE PNG DEVICE

# open png file device
# size should be 480 x 480 pixels
# background is transparent in the example files
png(filename = "plot1.png",
    width = 480, height = 480,
    bg = "transparent")

# histogram plot of Global_active_power
# main provides the title of the graph, and xlab the x-axis label
hist(twodaysdata$Global_active_power, 
    col="red", 
    main = "Global Active Power", 
    xlab = "Global Active Power (kilowatts)")

# closing the file device
dev.off()
