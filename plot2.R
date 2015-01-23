## Plot2.R outputs a line chart of total emissions of PM 2.5 in Baltimore City, Maryland,
## against four different years: 1999, 2002, 2005 and 2008.

## This script checks assumes that the name of your dataset, if present, is
## "NEI" and "SCC" as supplied by the course website.

## Checks if you have the data source "NEI" and "ls
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

## Subsets dataset, selecting only data from Baltimore City, Maryland.
baltimoreOnly <- NEI[which(NEI$fips == "24510"),]

## Loads sum of PM 2.5 emissions per year into a new dataset, baltimoreEmissions.

baltimoreEmissions <- aggregate(baltimoreOnly$Emissions, by=list(baltimoreOnly$year), sum)

## Plots points on the summarised baltimoreEmissions dataset. Removes automatic
## labelling to include labels for years 1999, 2002, 2005 and 2008. Also
## includes axis labels.
plot(baltimoreEmissions, xaxt = "n", xlab = "Year", ylab = "PM 2.5 Emissions (Tonnes)")

## Titles the plot.
title(main = "PM 2.5 Emissions per Month (Tonnes) in Baltimore City")

## Adds a lines connecting means to compare between years, and a linear regression line to analyse trend.
lines(baltimoreEmissions, col = "blue")
abline(lm(baltimoreEmissions[,2]~baltimoreEmissions[,1]), col = "red")

## Adds ticks to x-axis.
axis(1, at = c(1999,2002,2005,2008))

## Adds legend to graph
legend("topright", legend=c("Mean", "Regression"), lty = c(1,1), lwd = c(1,1), col=c("blue","red"))

## Outputs graph as plot2.png
dev.copy(png, file = "plot2.png", width = 1024, height = 768)
dev.off()