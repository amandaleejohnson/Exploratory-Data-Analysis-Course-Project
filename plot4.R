###Assignment 7


setwd("C:/Users/ajohns34/Box/Data Science Specialization/Assignment 7")

#Checking for and creating directories
# file.exists("directoryname") - looks to see if the directory exists - T/F
# dir.create("directoryname") - creates a directory if it doesn't exist

#If the directory doesn't exist, make a new one:
if(!file.exists("data")) {
        dir.create("data")
}

#####################################################################
# Background
#####################################################################

# Fine particulate matter (PM2.5) is an ambient air pollutant for which there 
# is strong evidence that it is harmful to human health. In the United States, 
# the Environmental Protection Agency (EPA) is tasked with setting national ambient 
# air quality standards for fine PM and for tracking the emissions of this pollutant
# into the atmosphere. Approximatly every 3 years, the EPA releases its database on 
# emissions of PM2.5. This database is known as the National Emissions Inventory (NEI). 
# You can read more information about the NEI at the EPA National Emissions Inventory web site:
# http://www.epa.gov/ttn/chief/eiinformation.html
# 
# For each year and for each type of PM source, the NEI records how many tons of PM2.5 
# were emitted from that source over the course of the entire year. The data that you 
# will use for this assignment are for 1999, 2002, 2005, and 2008.

#####################################################################
# Review criteria
#####################################################################

#For each question

#1. Does the plot appear to address the question being asked?
#2. Is the submitted R code appropriate for construction of the submitted plot?

#####################################################################
# Data
#####################################################################

# The data for this assignment are available from the course web site as a single zip file:
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip

# fips: A five-digit number (represented as a string) indicating the U.S. county

# SCC: The name of the source as indicated by a digit string (see source code classification table)

# Pollutant: A string indicating the pollutant

# Emissions: Amount of PM2.5 emitted, in tons

# type: The type of source (point, non-point, on-road, or non-road)

# year: The year of emissions recorded

# Source Classification Code Table (Source_Classification_Code.rds): 
# This table provides a mapping from the SCC digit strings in the Emissions table 
# to the actual name of the PM2.5 source. 
# The sources are categorized in a few different ways from more general to more specific 
# and you may choose to explore whatever categories you think are most useful. 
# For example, source "10100101" is known as "Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal".

# You can read each of the two files using the readRDS() function in R. 
#For example, reading in each file can be done with the following code:
## This first line will likely take a few seconds. Be patient!
#NEI <- readRDS("summarySCC_PM25.rds")
#SCC <- readRDS("Source_Classification_Code.rds")

#####################################################################
# Assignment
#####################################################################

# The overall goal of this assignment is to explore the National Emissions 
# Inventory database and see what it say about fine particulate matter pollution 
# in the United states over the 10-year period 1999-2008. 
# You may use any R package you want to support your analysis.

#####################################################################
# Questions
#####################################################################
# You must address the following questions and tasks in your exploratory analysis. 
# For each question/task you will need to make a single plot. 
# Unless specified, you can use any plotting system in R to make your plot.

# 4. Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?

        #Install Packages
        library(plyr)       
        library(ggplot2)
        library(gmodels)

        #Read in the data
        source_classification_code = readRDS("data/Source_Classification_Code.rds")
        summarySCC_PM25 = readRDS("data/summarySCC_PM25.rds")
        
        combined = merge(source_classification_code, summarySCC_PM25, by = "SCC")
        md = merge(source_classification_code, subset(summarySCC_PM25, fips == "24510"))
        md_aggtotals = aggregate(Emissions ~ year, md, sum)
        md_year_type_agg = aggregate(md$Emissions, by = list(type = md$type, year = md$year), FUN = sum)
        md_year_type_agg$Emissions = md_year_type_agg$x
        
        #We want all the rows that have EI.Sector that contains the words "Fuel Comb" and "Coal"
        coal = combined[grepl("Coal", combined$EI.Sector, ignore.case = TRUE), ]
        us_coal_aggtotals = aggregate(Emissions ~ year, coal, sum)
        
        #1. Open png device, create myplot in working directory        
        png("plot4.png", width=480, height=480)
        #2. Create plot
        barplot(us_coal_aggtotals$Emissions, names.arg = us_coal_aggtotals$year, 
                main = "Total PM2.5 emissions (tons) in the US from 1999-2008", 
                sub = "from coal combustion-related sources", 
                xlab = "Year", 
                ylab = "Total PM2.5 emissions (tons)", 
                ylim = c(0, max(us_coal_aggtotals$Emissions)))
        
        
        
        #3. Copy plot to a png file
        dev.copy(png, file = "plot4.png")
        #4. Close pdf file device
        dev.off()
#####################################################################
# Making and submitting plots
#####################################################################

# For each plot you should: 

# Construct the plot and save it to a PNG file.
# Create a separate R code file (plot1.R, plot2.R, etc.) 
#that constructs the corresponding plot, i.e. code in plot1.R constructs the plot1.png plot. 
#Your code file should include code for reading the data so that the plot can be fully reproduced. 
#You must also include the code that creates the PNG file. 
#Only include the code for a single plot (i.e. plot1.R should only include code for producing plot1.png)
# Upload the PNG file on the Assignment submission page
# Copy and paste the R code from the corresponding R file into the text box at the appropriate point in the peer assessment.

