library(ggplot2)

if (!exists('NEI')) {
  NEI <- readRDS('data/summarySCC_PM25.rds')
}

if (!exists('SCC')) {
  SCC <- readRDS('data/Source_Classification_Code.rds')
}

# Compare emissions from motor vehicle sources in Baltimore City
# with emissions from motor vehicle sources in
# Los Angeles County, California (fips == "06037").
# Which city has seen greater changes over time in motor vehicle emissions?

# Find NEI data for vehicles
vehicles <- grepl('vehicle', SCC$SCC.Level.Two, ignore.case=TRUE)
vehiclesSCC <- SCC[vehicles, ]$SCC
# Subset NEI data using same subset of SCC data found above
vehiclesNEI <- NEI[NEI$SCC %in% vehiclesSCC, ]

# Find Baltimore NEI data
vehiclesBaltimoreNEI <- vehiclesNEI[vehiclesNEI$fips == '24510', ]
vehiclesBaltimoreNEI$city <- 'Baltimore'

vehiclesLANEI <- vehiclesNEI[vehiclesNEI$fips == '06037', ]
vehiclesLANEI$city <- 'LA County'

# Combine the two subsets with city name into one data frame
combinedNEI <- rbind(vehiclesBaltimoreNEI, vehiclesLANEI)

png('plot6.png', width=480, height=480)

g <- ggplot(
  combinedNEI , aes(x=factor(year), y=Emissions, fill=city))

g <- g +
  geom_bar(aes(fill=year),stat='identity') +
  facet_grid(scales='free', space='free', .~city) +
  guides(fill=FALSE) + theme_bw() +
  labs(
    x='Year',
    y='Total PM2.5 Emission (K-Tons)',
    title='PM2.5 Motor Vehicle Emissions in Baltimore and LA 1999-2008')

print(g)

dev.off()
