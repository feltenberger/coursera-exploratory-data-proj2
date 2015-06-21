library(ggplot2)

if (!exists('NEI')) {
  NEI <- readRDS('data/summarySCC_PM25.rds')
}

if (!exists('SCC')) {
  SCC <- readRDS('data/Source_Classification_Code.rds')
}

# Across the United States, how have emissions from coal
# combustion-related sources changed from 1999–2008?

# Combine the two datasets on SCC
if(!exists("NEISCC")) {
  NEISCC <- merge(NEI, SCC, by="SCC")
}

# find records with Short.Name equal to 'coal'
coalMatches  <- grepl(
  'coal', NEISCC$Short.Name, ignore.case=TRUE)
coalRecords <- NEISCC[coalMatches, ]

aggregatedTotalByYear <-
  aggregate(Emissions ~ year, coalRecords , sum)

png('plot4.png', height=480, width=480)

g <- ggplot(
  aggregatedTotalByYear, aes(factor(year), Emissions))

g <-
  g + geom_bar(stat='identity', fill='grey') +
  xlab('Year') +
  ylab(expression('Total PM2.5 Emissions')) +
  ggtitle('Total Coal Emissions from 1999 to 2008')

print(g)

dev.off()
