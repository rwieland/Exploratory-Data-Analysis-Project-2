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
mv <- SCC[grepl("Vehicle", SCC$EI.Sector),]
mvSCC <- mv$SCC

NEI1 <- NEI[NEI$fips %in% c("24510", "06037"),]
NEI1$fips[NEI1$fips == "24510"] = "Baltimore City, MD"
NEI1$fips[NEI1$fips == "06037"] = "Los Angeles County"

NEI2 <- NEI1[NEI1$SCC %in% mvSCC,]

NEI3 <- summarize(group_by(NEI2, fips, year), total = sum(Emissions, na.rm = TRUE))

# Creating plot
p <- ggplot(NEI3, aes(x = as.factor(year), y = total) ) +
  geom_bar(stat = "identity") +
  facet_wrap(~fips) +
  theme_bw() +
  xlab("Year") + 
  ylab("Total PM2.5 emissions") +
  ggtitle("Yearly Total Motor Vehicle PM2.5 Emissions")

ggsave("plot6.png")

# Cleaning up
rm(list = c("mv", "mvSCC", "NEI1", "NEI2", "NEI3", "p"))

