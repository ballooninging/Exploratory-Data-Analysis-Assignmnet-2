## Plot1.R outputs a line chart of total emissions of PM 2.5 in the United States
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

## Loads sum of PM 2.5 emissions per year into a new dataset, totalEmissions.

totalEmissions <- aggregate(NEI$Emissions, by=list(NEI$year), sum)

## Plots points on the summarised totalemissions dataset. Removes automatic
## labelling to include labels for years 1999, 2002, 2005 and 2008. Also
## includes axis labels.
plot(totalEmissions, xaxt = "n", xlab = "Year", ylab = "PM 2.5 Emissions (Tonnes)")

## Titles the plot.
title(main = "PM 2.5 Emissions per Month (Tonnes)")

## Adds a lines connecting means to compare between years, and a linear regression line to analyse trend.
lines(totalEmissions, col = "blue")
abline(lm(totalEmissions[,2]~totalEmissions[,1]), col = "red")

## Adds ticks to x-axis.
axis(1, at = c(1999,2002,2005,2008))

## Adds legend to graph
legend("topright", legend=c("Mean", "Regression"), lty = c(1,1), lwd = c(1,1), col=c("blue","red"))

## Outputs graph as plot1.png
dev.copy(png, file = "plot1.png", width = 1024, height = 768)
dev.off()