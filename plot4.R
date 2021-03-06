# Getting required packages
if (!require("dplyr")) {
  install.packages("dplyr")
  library(dplyr)
}

if (!require("ggplot2")) {
  install.packages("ggplot2")
  library(ggplot2)
}

# Loading the NEI dataset
# Download the data if it isnt in the working directory
if (!file.exists("FNEI_data.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "FNEI_data.zip")
}

# Unzip the downloaded data if it hasn't been unzipped in the working directory
if (!file.exists("summarySCC_PM25.rds") || !file.exists("Source_Classification_Code.rds")) {
  unzip("FNEI_data.zip")
}

# Read the data if it is not in the global environment
if (!exists("NEI") || !exists("SCC")) {
  NEI <- readRDS("summarySCC_PM25.rds")
  SCC <- readRDS("Source_Classification_Code.rds")
}

# Finding the total emissions for each year for coal
coal <- SCC[grepl("Coal", SCC$EI.Sector),]
coalSCC <- coal$SCC
NEI1 <- NEI[NEI$SCC %in% coalSCC,]
NEI2 <- summarize(group_by(NEI1, year), total = sum(Emissions, na.rm = TRUE))

# Creating plot4 as a barplot
png("plot4.png")

barplot(NEI2$total,
        names.arg = NEI2$year,
        xlab = "Year",
        ylab = "Total PM2.5 emissions",
        main = "Yearly Total Coal PM2.5 Emissions")

dev.off()

# Cleaning up
rm(list = c("NEI1", "NEI2", "coal", "coalSCC"))

