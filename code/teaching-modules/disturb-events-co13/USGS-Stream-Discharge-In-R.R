## ----load-libraries------------------------------------------------------
# set your working directory
#setwd("working-dir-path-here")

# load packages
library(ggplot2) # create efficient, professional plots
library(plotly) # create cool interactive plots


## ----import-discharge-2--------------------------------------------------

#import data
discharge <- read.csv("discharge/06730200-discharge_daily_1986-2013.txt",
                      sep="\t",
                      skip=24,
                      header=TRUE,
                      stringsAsFactors = FALSE)

#view first few lines
head(discharge)


## ----remove-second-header------------------------------------------------
# nrow: how many rows are in the R object
nrow(discharge)

# remove the first line from the data frame (which is a second list of headers)
# the code below selects all rows beginning at row 2 and ending at the total
# number of rows. 
discharge <- discharge[2:nrow(discharge),]

## ----rename-headers------------------------------------------------------
#view names
names(discharge)

#rename the fifth column to disValue representing discharge value
names(discharge)[4] <- "disValue"
names(discharge)[5] <- "qualCode"

#view names
names(discharge)


## ----view-data-structure-------------------------------------------------
#view structure of data
str(discharge)


## ----adjust-data-structure-----------------------------------------------
# view class of the disValue column
class(discharge$disValue)

# convert column to integer
discharge$disValue <- as.integer(discharge$disValue)

str(discharge)


## ----convert-time--------------------------------------------------------
#view class
class(discharge$datetime)

#convert to date/time class - POSIX
discharge$datetime <- as.POSIXct(discharge$datetime)

#recheck data structure
str(discharge)


## ----no-data-values------------------------------------------------------
# check total number of NA values
sum(is.na(discharge$datetime))

# check for "strange" values that could be an NA indicator
hist(discharge$disValue)


## ----plot-flood-data-----------------------------------------------------

ggplot(discharge, aes(datetime, disValue)) +
  geom_point() +
  ggtitle("Stream Discharge (CFS) for Boulder Creek") +
  xlab("Date") + ylab("Discharge (Cubic Feet per Second)")


## ----define-time-subset--------------------------------------------------

# Define Start and end times for the subset as R objects that are the time class
startTime <- as.POSIXct("2013-08-15 00:00:00")
endTime <- as.POSIXct("2013-10-15 00:00:00")

# create a start and end time R object
start.end <- c(startTime,endTime)
start.end

# plot the data - Aug 15-October 15
ggplot(discharge,
      aes(datetime,disValue)) +
      geom_point() +
      scale_x_datetime(limits=start.end) +
      xlab("Date") + ylab("Discharge (Cubic Feet per Second)") +
      ggtitle("Stream Discharge (CFS) for Boulder Creek\nAugust 15 - October 15, 2013")


## ----plotly-discharge-data-----------------------------------------------

# subset out some of the data - Aug 15 - October 15
discharge.aug.oct2013 <- subset(discharge, 
                        datetime >= as.POSIXct('2013-08-15 00:00',
                                              tz = "America/Denver") & 
                        datetime <= as.POSIXct('2013-10-15 23:59', 
                                              tz = "America/Denver"))

# plot the data
disPlot.plotly <- ggplot(data=discharge.aug.oct2013,
        aes(datetime,disValue)) +
        geom_point(size=3)     # makes the points larger than default

disPlot.plotly
      
# add title and labels
disPlot.plotly <- disPlot.plotly + 
	theme(axis.title.x = element_blank()) +
	xlab("Time") + ylab("Stream Discharge (CFS)") +
	ggtitle("Stream Discharge - Boulder Creek 2013")

disPlot.plotly

# view plotly plot in R
ggplotly(disPlot.plotly)

## ----pub-plotly, eval=FALSE----------------------------------------------
## # set username
## Sys.setenv("plotly_username"="yourUserNameHere")
## # set user key
## Sys.setenv("plotly_api_key"="yourUserKeyHere")
## 
## # publish plotly plot to your plotly online account if you want.
## plotly_POST(disPlot.plotly)
## 

