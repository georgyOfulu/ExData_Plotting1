library(dplyr)
library(magrittr)
library(lubridate)
# download and Ingest data ----------------------------------------------------
file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
names_columns <- c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")

if (!file.exists("household_power_consumption.txt")) {
        download.file(file_url, destfile = "rawdata.zip")
        unzip("rawdata.zip")
}

rawdata <- read.delim("household_power_consumption.txt", header = FALSE, sep = ";", na.strings = "?", skip = 66637, nrows = 2880)
names(rawdata) <- names_columns

# format data appropriately -----------------------------------------------
rawdata <- rawdata %>%
        mutate(DateTime = paste(Date, Time, sep = " ")) %>%
        select(-c(Date, Time))
rawdata$DateTime <- lubridate::dmy_hms(rawdata$DateTime)


# required vizualization ---------------------------------------------
png(file = "plot3.png", width = 480, height = 480)
plot(rawdata$DateTime, rawdata$Sub_metering_1, ylab = "Energy Sub metering", xlab = "", type = "l")
points(rawdata$DateTime, rawdata$Sub_metering_2, type = "l", col = "red")
points(rawdata$DateTime, rawdata$Sub_metering_3, type = "l", col = "blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("sub_metering_1", "sub_metering_2", "sub_metering_3"))
dev.off()

