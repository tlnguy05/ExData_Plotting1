# Using fread() from library(data.table) to read the data faster.
# Read only data from the dates 2007-02-01 and 2007-02-02 and save it to EPC
library(data.table)
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileurl, destfile = "EPC.zip", method = "curl")
unzip("EPC.zip")
EPC <- fread("household_power_consumption.txt", header = FALSE, 
             skip = 66637,nrows = 2880, sep = ";", 
             col.names = c("Date", "Time", "Global_active_power",
                           "Global_reactive_power","Voltage", "Global_intensity",
                           "Sub_metering_1","Sub_metering_2", "Sub_metering_3"))

# Convert the Date and Time variables to Date/Time classes in R
EPC$Date_Time <- paste(EPC$Date, EPC$Time)
EPC$Date_Time <- as.POSIXct(strptime(EPC$Date_Time, format = "%d/%m/%Y %H:%M:%S"))

# Plot 4: Draw 4 plots on the same canvas
png(filename = "plot4.png", width = 480, height = 480)
par(mfrow = c(2,2))
# 1st plot
with(EPC, plot(Date_Time, Global_active_power, xlab = "", 
               ylab = "Global Active Power (kilowatts)", type = "n"))
with(EPC, lines(Date_Time, Global_active_power))



# 2nd plot
with(EPC, plot(Date_Time, Voltage, xlab = "datetime", 
ylab = "Voltage", type = "n"))
with(EPC, lines(Date_Time, Voltage))


# 3rd plot
with(EPC, plot(Date_Time, Sub_metering_1, xlab ="", 
               ylab = "Energy sub metering", type = "n"))
with(EPC, lines(Date_Time, Sub_metering_1))
with(EPC, lines(Date_Time, Sub_metering_2, col = "red"))
with(EPC, lines(Date_Time, Sub_metering_3, col = "blue"))
legend("topright", col = c("black", "red", "blue"), lty = c(1,1,1),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       bty = "n", xjust = 1)

# 4th plot
with(EPC, plot(Date_Time, Global_reactive_power, xlab ="datetime", type = "n"))
with(EPC, lines(Date_Time, Global_reactive_power))

dev.off()
