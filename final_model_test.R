# Main test with training and test data
library(gam)


# THINGS TO DO
# Clean up test data after reading it in, according to the
# training data cleanup methods




# Import Data (subject to change)
load("~/Desktop/STA 298 findings/complete_test_data_revised.RData")
load("~/Desktop/STA 298 findings/complete_train_and_test_data.RData")

# Final touches to both data sets

# Clears any remaining NAs and
# Reduces training data to the following variables:
# distance, moving_time, elapsed_time, elev_gain, avg_speed, max_speed,
# avg_hr, max_hr

dat.run.train = dat.run.train[-which(is.na(dat.run.train[,10])),]
dat.run.train <- dat.run.train[,c(10,9,8,11,31,12,13,14)]

# Before we isolate races, must impute data accordingly.


# Isolates all races from test data by picking out
# which ones DO NOT have NA for a raceID (only events with a raceID fit this criterion)
dat.run.races <- dat.run.test[which(dat.run.test[,10] != "NA"),]

# Of these 10734 races, exactly HALF (5367) are missing "elapsed_time" entries,
# as well as other variables that would not be known beforehand (max_speed, etc.)

# Isolate races with missing elapsed_time entries. We must predict these.
dat.run.to.predict <- dat.run.races[-which(dat.run.races[,2] != "NA") ,]


# Create a function that does the following:

# 1. Reads in a line of data from dat.run.to.predict. These non-missing
# values are our variables to use

# 2. Reads in the training data AND all test data for the person of
# the SAME ID, UP TO the date mentioned
# training data has   yyyy-mm-dd 00:00:00"
# test data has       yyyy-mm-ddT00:00:00Z"
# But as.Date() yields the same result, so no changes are needed to format
# before converting to a Date object

# 3. Use all the given data to run on our
# id: which racer is it
# dataline: a single row from dat.run.to.predict
# train.data: All data from the training set
# racer.data: All data from this particular racer (same ID)


# TESTING ZONE

dataline = dat.run.500[which(dat.run.500$raceID == 131),]
racer.data = dat.run.500[which(dat.run.500$id == 16),]

predict.time <- function(id, dataline, train.data, racer.data)
{
  race.date <- as.Date(dataline$start_date_local)
  
  # Reduce racer data to only entries BEFORE this race time
  racer.data <- racer.data[which(as.Date(racer.data$start_date_local) < race.date),]
  
  names(racer.data) <- names(train.data) # Make the names match properly
  all.data <- rbind(train.data, racer.data) # Combine all relevant data
  # Run the GAM for that race and get an estimated time in response
  est.time <- gam.combo(all.data, dataline) 
  est.time
}




racer.data =  racer.data[which(as.Date(racer.data$start_date_local) < race.date),]


train.data <- dat.run.train[,c(10,9,8,11,31,12,13,14)]
racer.data <- racer.data[,c(1,2,3,4,6,7,8,9)]
names(racer.data) <- names(train.data)
all.data = rbind(train.data, racer.data)

gam.combo.no.hr(all.data, dataline)
