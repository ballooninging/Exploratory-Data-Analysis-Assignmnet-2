## Plot4.R outputs a line chart of PM 2.5 emissions from coal sources
## plotted against four non-continuous years: 1999, 2002, 2005 and 2008.

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

## Extracts indices for SCC rows that refers to coal as the source of emissions.
coalIndex <- grep("Coal", SCC$SCC.Level.Three)
SCCsubsetCoal <- SCC[coalIndex,]

## Extracts rows from NEI based on subsetCoal's SCC values, and sums Emissions for graphing
NEIsubsetCoal <- NEI[NEI$SCC %in% SCCsubsetCoal$SCC,]
NEIsubsetCoalEmissions <- aggregate(NEIsubsetCoal$Emissions, by=list(NEIsubsetCoal$year), sum)

## Graphs year against emissions from coal sources.
plot4 <- ggplot(NEIsubsetCoalEmissions, aes(x = Group.1, y = x)) + geom_line()
plot4 + xlab("Year") +
  ylab("Emissions (Tonnes)") +
  ggtitle("PM 2.5 Emissions (Tonnes) Per Year, For Coal Sources")

## Outputs the .png file
ggsave(filename="plot4.png")
dev.off()