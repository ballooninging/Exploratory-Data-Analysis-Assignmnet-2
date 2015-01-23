## Plot6.R outputs a line chart of PM 2.5 emissions from vehicular sources in 
## Baltimore City and Los Angeles County, plotted against four non-continuous
## years: 1999, 2002, 2005 and 2008.

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

## Extracts rows from NEI based on subsetCoal's SCC values
NEIsubsetVehicle <- NEI[NEI$SCC %in% SCCsubsetVehicle$SCC,]

## Subsets Baltimore city and LA's data and sums Emissions for graphing
NEIsubsetVehicleCities <- NEIsubsetVehicle[which(NEIsubsetVehicle$fips == "24510" | NEIsubsetVehicle$fips == "06037"),]
NEIsubsetVehicleCities$fips <- factor(NEIsubsetVehicleCities$fips, levels=c("24510", "06037"),
                                     labels=c("Baltimore City", "Los Angeles County"))
emissionsMelt <- melt(NEIsubsetVehicleCities, id = c("year", "fips"))
emissionsMelt <- emissionsMelt[which(emissionsMelt$variable=="Emissions"),]
emissionsMelt$value <- as.numeric(emissionsMelt$value)
emissionsCast <- dcast(emissionsMelt, year + fips ~ variable, sum)

## Graphs year against emissions from vehicular sources.
plot6 <- ggplot(emissionsCast, aes(x = year, y = Emissions, colour=fips)) + geom_line()

## Adds titles, axis labels and regression lines.
plot6 + ggtitle("PM 2.5 Emissions (Tonnes) Per Year, By Cities") +
  xlab("Year") +
  ylab("PM2.5 Emissions (Tonnes)") +
  scale_colour_discrete(name="Cities",
                        breaks=c("Baltimore City", "Los Angeles County"),
                        labels=c("Baltimore City", "Los Angeles County"))

## Outputs the .png file
ggsave(filename="plot6.png")
dev.off()