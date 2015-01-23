## Plot5.R outputs a line chart of PM 2.5 emissions from vehicular sources in
## Baltimore City, plotted against four non-continuous years: 1999, 2002, 2005
## and 2008.

## This script checks assumes that the name of your dataset, if present, is
## "NEI" and "SCC" as supplied by the course website.

## Checks if you have the data source "NEI" and "SCC". If absent, the utility
## downloads the dataset and loads it into a file named "ExDatAssign2.zip"
NEIPresent <- apropos("NEI")
SCCPresent <- apropos("SCC")
if (length(NEIPresent) == 0 | length(SCCPresent) == 0) {
  x <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  y <- "./ExDatAssign2.zip"
  download.file(x, y)
  unzip(y)
  NEI <- readRDS("summarySCC_PM25.rds")
  SCC <- readRDS("Source_Classification_Code.rds")
}

## Extracts indices for SCC rows that refers to vehicles as the source of emissions.
vehicleIndex <- grep("Vehicle", SCC$SCC.Level.Two)
SCCsubsetVehicle <- SCC[vehicleIndex,]

## Extracts rows from NEI based on subsetCoal's SCC values, and sums Emissions for graphing
NEIsubsetVehicle <- NEI[NEI$SCC %in% SCCsubsetVehicle$SCC,]
NEIsubsetVehicleBaltimore <- NEIsubsetVehicle[which(NEIsubsetVehicle$fip == "24510"),]
NEIsubsetVehicleEmissions <- aggregate(NEIsubsetVehicleBaltimore$Emissions, by=list(NEIsubsetVehicleBaltimore$year), sum)

## Graphs year against emissions from coal sources.
plot5 <- ggplot(NEIsubsetVehicleEmissions, aes(x = Group.1, y = x)) + geom_line()
plot5 + xlab("Year") +
  ylab("Emissions (Tonnes)") +
  ggtitle("PM 2.5 Emissions (Tonnes) Per Year, For Vehicular Sources")

## Outputs the .png file
ggsave(filename="plot5.png")
dev.off()
