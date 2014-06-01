# Main test with training and test data
library(gam)


# THINGS TO DO
# Clean up test data after reading it in, according to the
# training data cleanup methods

# 



# Final touches to both data sets
dat.run.train <- dat.run.train[,c(10,9,8,11,31,12,13,14,17)]

# Isolates all races
dat.run.races <- dat.run.test[which(dat.run.test[,9] != "NA"),]
# Of these 10734 races, exactly HALF (5367) are missing "moving_time" entries

# Isolate races with missing moving_time entries. We must predict these.
dat.run.to.predict <- dat.run.races[-which(dat.run.races[,2] != "NA") ,]


# Create a function that does the following:

# 1. Reads in a line of data from dat.run.to.predict. These non-missing
# values are our variables to use

# 2. Reads in the training data AND all test data for the person of
# the SAME ID, UP TO the date mentioned
# NOTE: Must use regex to convert the date into a recognizable form
# training data has   yyyy-mm-dd 00:00:00"
# test data has       yyyy-mm-ddT00:00:00Z"

# 3. Use all the given data to run on our
# id: which racer is it
# dataline: a single row from dat.run.to.predict
# train.data: All data from the training set
# racer.data: All data from this particular racer (same ID)

predict.time <- function(id, dataline, train.data)
{
  race.date = as.Date(dataline$start_date_local)
  
  # Reduce racer data to only entries BEFORE this race time
  racer.data[which(as.Date(racer.data$start_date_local) < race.date),]
  
  all.data = rbind(train.data, racer.data) # Combine all relevant data
  
  gam.combo(all.data, id)
  
}



# TESTING ZONE

dataline = dat.run.500[which(dat.run.500$raceID == 131),]
race.date = as.Date(dataline$start_date_local)

racer.data = dat.run.500[which(dat.run.500$id == 16),]

racer.data =  racer.data[which(as.Date(racer.data$start_date_local) < race.date),]


train.data <- dat.run.train[,c(10,9,8,11,31,12,13,14)]
racer.data <- racer.data[,c(1,2,3,4,6,7,8,9)]
names(racer.data) <- names(train.data)
all.data = rbind(train.data, racer.data)

gam.combo.no.hr(all.data, dataline)
