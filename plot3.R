## Plot3.R outputs a line chart of PM 2.5 emissions from four sources:
## "POINT", "NONPOINT", "ON-ROAD" and "NON-ROAD". The charts are plotted against four
## non-continuous years: 1999, 2002, 2005 and 2008.

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

## Reshapes data for graphing.
temp <- NEI[, c("Emissions", "year", "type")]
dfMelt <- melt(temp, id = c("year", "type"))
dfCast <- dcast(dfMelt, year + type ~ variable, sum)
dfCast$type <- factor(dfCast$type, levels=c("POINT", "NONPOINT", "ON-ROAD", "NON-ROAD"), 
                      labels = c("POINT", "NONPOINT", "ON-ROAD", "NON-ROAD"))
""
## Plots graph via ggplot2.
plot3 <- ggplot(dfCast, aes(x = year, y = Emissions, colour = type)) + geom_line()
plot3 + ggtitle("PM 2.5 Emissions (Tonnes) Per Year, By Source") +
  xlab("Year") +
  ylab("PM2.5 Emissions (Tonnes)") +
  scale_colour_discrete(name="Source Type",
                        breaks=c("POINT","NONPOINT","ON-ROAD","NON-ROAD"),
                        labels=c("Point", "Non-point", "On-road", "Non-road"))

#Outputs .png file
dev.copy(png, file="plot3.png")
dev.off()