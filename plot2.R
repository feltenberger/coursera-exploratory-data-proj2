if (!exists('NEI')) {
  NEI <- readRDS('data/summarySCC_PM25.rds')
}

if (!exists('SCC')) {
  SCC <- readRDS('data/Source_Classification_Code.rds')
}

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? 
# Use the base plotting system to make a plot answering this question.

baltimoreNEI <- NEI[NEI$fips=="24510", ]

aggregatedTotalByYear <-
  aggregate(Emissions ~ year, baltimoreNEI, sum)

png('plot2.png', width=480, height=480)

barplot(
  height=aggregatedTotalByYear$Emissions,
  names.arg=aggregatedTotalByYear$year,
  xlab='Year',
  ylab=expression('Total PM2.5 emissions'),
  main=expression('Total PM2.5 in the Baltimore City by year'))

dev.off()
