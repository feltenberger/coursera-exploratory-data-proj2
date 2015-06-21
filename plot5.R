library(ggplot2)

if (!exists('NEI')) {
  NEI <- readRDS('data/summarySCC_PM25.rds')
}

if (!exists('SCC')) {
  SCC <- readRDS('data/Source_Classification_Code.rds')
}

# How have emissions from motor vehicle sources changed from
# 1999–2008 in Baltimore City?

# Find NEI data which for vehicles
vehicles <- grepl(
  'vehicle',
  SCC$SCC.Level.Two,
  ignore.case=TRUE)

vehiclesSCC <- SCC[vehicles,]$SCC

vehiclesNEI <- NEI[NEI$SCC %in% vehiclesSCC, ]

# Only the vehicles in Baltimore
baltimoreVehiclesNEI <- vehiclesNEI[vehiclesNEI$fips == '24510', ]

png('plot5.png', width=480, height=480)

g <- ggplot(
  baltimoreVehiclesNEI,aes(factor(year),Emissions))

g <-
  g +
  geom_bar(stat='identity', fill='grey', width=0.75) +
  theme_bw() +
  guides(fill=FALSE) +
  labs(
    x='Year',
    y='Total PM2.5 Emission (10^5 Tons)',
    title='PM2.5 Motor Vehicle Emissions in Baltimore City from 1999-2008')

print(g)

dev.off()

