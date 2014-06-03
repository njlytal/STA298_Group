# Main test with training and test data
library(gam)


# THINGS TO DO
# Remove moving_time from the GAM
# Work on imputing data for individual racers
# Use predict() or something similar to get CIs for estimates




# Import Data (subject to change)
# load("~/Desktop/STA 298 findings/complete_test_data_revised.RData")
# load("~/Desktop/STA 298 findings/complete_train_and_test_data.RData")

vars # List of variables to keep


load("~/Desktop/STA 298 findings/all_train_test_amelia_data.RData")

imp1 = am.test2$imputations[[1]]

# Obtain all imputations and average out their results to get the imputed values.
dat.run.train.imp1 = am.test2$imputations[[1]][,c(13,12,11,14,8,34,15,16,17)]
dat.run.train.imp2 = am.test2$imputations[[2]][,c(13,12,11,14,8,34,15,16,17)]
dat.run.train.imp3 = am.test2$imputations[[3]][,c(13,12,11,14,8,34,15,16,17)]
dat.run.train.imp4 = am.test2$imputations[[4]][,c(13,12,11,14,8,34,15,16,17)]
dat.run.train.imp5 = am.test2$imputations[[5]][,c(13,12,11,14,8,34,15,16,17)]

train.avg.hr = numeric(nrow(dat.run.train.imp1))
train.max.hr = numeric(nrow(dat.run.train.imp1))

for(i in 1:nrow(dat.run.train.imp1))
{
  avg_hr[i] = mean(c(dat.run.train.imp1[i,8], dat.run.train.imp2[i,8],
                         dat.run.train.imp3[i,8], dat.run.train.imp4[i,8],
                         dat.run.train.imp5[i,8]))
  max_hr[i] = mean(c(dat.run.train.imp1[i,9], dat.run.train.imp2[i,9],
                         dat.run.train.imp3[i,9], dat.run.train.imp4[i,9],
                         dat.run.train.imp5[i,9]))
}

max_hr = train.max.hr
dat.run.train = am.test2$imputations[[1]][,c(13,12,11,14,8,34,15)]
dat.run.train = cbind(dat.run.train, avg_hr, max_hr)
rm(dat.run.train.imp1, dat.run.train.imp2, dat.run.train.imp3,
   dat.run.train.imp4, dat.run.train.imp5)

rm(avg_hr, max_hr)

# Now dat.run.train has all the training data with imputed values
# Reduces training data to the following variables:
# distance, moving_time, elapsed_time, elev_gain, start_date_local, avg_speed, max_speed,
# avg_hr, max_hr


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

# raceID: Number of the race to test
# train.data: The entire dataframe of training data
# test.data: The entire dataframe of test data
# test.predict: The dataframe ONLY of races with times missing (to predict)

predict.time <- function(raceID, train.data, test.data, test.predict)
{
  browser()
  # Isolate a race to predict among those than need prediction
  dataline = test.predict[which(test.predict$raceID == raceID),]
  ID = dataline$id # Identifies the racer
  racer.data = test.data[which(test.data$id == ID),] # All data for the racer in question
  
  race.date <- as.Date(dataline$start_date_local) # Date of race  
  
  # Reduce racer data to only entries BEFORE this race time,
  # as well only variables that matter for our model
  racer.data <- racer.data[which(as.Date(racer.data$start_date_local) < race.date),]
  racer.data <- racer.data[,c(1,2,3,4,5,6,7,8,9)]
  dataline <- dataline[,c(1,2,3,4,5,6,7,8,9)]
  names(racer.data) <- names(train.data) # Make the names match properly for the 2 dataframes
  names(dataline) <- names(train.data)
  all.data <- rbind(train.data, racer.data) # Combine all relevant data
  
  # Imputation for missing variables
  # This uses all.data to estimate the missing variables in dataline:
  # moving_time, avg_speed, max_speed, avg_hr, avg_hr
  # combined <- rbind(all.data, dataline)  
  
  
  # Run the GAM for that race and get an estimated time in response
  est.time <- gam.combo(all.data, dataline) 
  
  # Determine the INTERVAL it will fall into
  # This is ABSOLUTELY not the final interval to use!
  pred.lo = est.time*0.95
  pred.hi = est.time*1.05
  
  out = data.frame(est.time, pred.lo, pred.hi)
}

test = predict.time(5193, dat.run.train, dat.run.test, dat.run.to.predict)


test = gam.combo.hr(dat.run.train,dat.run.train[1,])

# Run predict.time over all races to predict to get a result
raceID.predict <- dat.run.to.predict$raceID
predictions <- sapply(raceID.predict,
                      function(x) predict.time(x, dat.run.train, dat.run.test,
                                               dat.run.to.predict))

# Finally, determine which races to opt out of based on accuracy problems, etc.
opt_out = rep(0,nrow(dat.run.to.prediction))


# The final resulting CSV takes this form
final.df = data.frame(dat.run.to.predict$id, dat.run.to.predict$raceID,
                      predictions$est.time, predictions$pred.lo,
                      predictions$pred.hi, opt_out)