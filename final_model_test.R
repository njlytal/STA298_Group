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

avg_hr = numeric(nrow(dat.run.train.imp1))
max_hr = numeric(nrow(dat.run.train.imp1))

for(i in 1:nrow(dat.run.train.imp1))
{
  avg_hr[i] = mean(c(dat.run.train.imp1[i,8], dat.run.train.imp2[i,8],
                         dat.run.train.imp3[i,8], dat.run.train.imp4[i,8],
                         dat.run.train.imp5[i,8]))
  max_hr[i] = mean(c(dat.run.train.imp1[i,9], dat.run.train.imp2[i,9],
                         dat.run.train.imp3[i,9], dat.run.train.imp4[i,9],
                         dat.run.train.imp5[i,9]))
}

dat.run.train = am.test2$imputations[[1]][,c(13,12,11,14,8,34,15)]
dat.run.train = cbind(dat.run.train, avg_hr, max_hr)
rm(dat.run.train.imp1, dat.run.train.imp2, dat.run.train.imp3,
   dat.run.train.imp4, dat.run.train.imp5)

rm(avg_hr, max_hr)

# Now dat.run.train has all the training data with imputed values
# Reduces training data to the following variables:
# distance, moving_time, elapsed_time, elev_gain, start_date_local, avg_speed, max_speed,
# avg_hr, max_hr

# REPEAT for the TEST data
load("~/Desktop/STA 298 findings/test_data_imputed.RData")
imp1 = am.test2$imputations[[1]]
imp2 = am.test2$imputations[[2]]
imp3 = am.test2$imputations[[3]]
imp4 = am.test2$imputations[[4]]
imp5 = am.test2$imputations[[5]]

# Average the imputations for avg_hr and max_hr
avg_hr = numeric(nrow(imp1))
max_hr = numeric(nrow(imp1))

avg.hr.combo = cbind(imp1[,8],imp2[,8], imp3[,8], imp4[,8], imp5[,8])
avg_hr = sapply(1:nrow(imp1), function(x) mean(avg.hr.combo[x,]))

max.hr.combo = cbind(imp1[,9],imp2[,9], imp3[,9], imp4[,9], imp5[,9])
max_hr = sapply(1:nrow(imp1), function(x) mean(max.hr.combo[x,]))


dat.run.test = am.test2$imputations[[1]]
dat.run.test$average_heartrate <- avg_hr
dat.run.test$max_heartrate <- max_hr
rm(avg.hr.combo, avg_hr, max.hr.combo, max_hr)
rm(imp1, imp2, imp3, imp4, imp5)

# EXTRA IF PREDICTED LINES WERE IMPUTED TOO
dat.predict = dat.run.test[625692:631058,]


# Now dat.run.test has all the test data with imputed values
# Reduces test the following variables:
# distance, moving_time, elapsed_time, total_elevation_gain, start_date_local,
# average_speed, max_speed,
# average_heartrate, max_heartrate, raceID, id, eventID

# AT THIS POINT, CAN LOAD
load("~/Desktop/STA 298 findings/all_train_test_amelia_data.RData")
# TO GET ALL UPDATED DATA!

# Create a function that does the following:

# 1. Reads in a line of data from dat.run.to.predict. These non-missing
# values are our variables to use

# 2. Reads in the training data AND all test data for the person of
# the SAME ID, UP TO the date mentioned
# training data has   yyyy-mm-dd 00:00:00"
# test data has       yyyy-mm-ddT00:00:00Z"
# But as.Date() yields the same result, so no changes are needed to format
# before converting to a Date object (actually, this occurs earlier as well)

# 3. Use all the given data to run on our
# id: which racer is it
# dataline: a single row from dat.run.to.predict
# train.data: All data from the training set
# racer.data: All data from this particular racer (same ID)


# Here's the ultimate data file!
load("~/Desktop/STA 298 findings/all_train_test_FINAL_data.RData")
#dat.predict: races to predict, pre-imputed
#dat.run.test: the cleaned run data, with no races that we must calculate
#dat.run.to.predict: races to predict, NO imputation
#dat.run.train: all the training data, imputed
#dat.test.imputed: ALL the data, included races to find, pre-imputed

# TESTING ZONE

# raceID: Number of the race to test
# train.data: The entire dataframe of training data
# test.data: The entire dataframe of test data
# test.predict: The dataframe ONLY of races with times missing (to predict)
# failsafe: set of imputable values if no previous racer data exists
# RMSE: The calculated RMSE of the gam being used (for prediction intervals)

predict.time.new <- function(raceID, train.data, test.data, test.predict, failsafe, RMSE)
{
  # Isolate a race to predict among those than need prediction
  dataline = test.predict[which(test.predict$raceID == raceID),]
  ID = dataline$id # Identifies the racer
  racer.data = test.data[which(test.data$id == ID),] # All data for the racer in question
  
  race.date <- as.Date(dataline$start_date_local) # Date of race  
  
  # Reduce racer data to only entries BEFORE this race time,
  # as well only variables that matter for our model
  racer.data <- racer.data[which(as.Date(racer.data$start_date_local) < race.date),]
  racer.data <- racer.data[,1:9]
  dataline <- dataline[,1:9]
  names(racer.data) <- names(train.data) # Make the names match properly for the 2 dataframes
  names(dataline) <- names(train.data)
  racer.data$start_date_local <- NULL
  dataline$start_date_local <- NULL

  # train.data is what we use to predict times
  # racer.data is what we use to IMPUTE missing values in dataline
  
  # Imputation for missing variables
  # This uses all.data to estimate the missing variables in dataline:
  # moving_time, avg_speed, max_speed, avg_hr, avg_hr

  # browser()
  
  combined <- rbind(as.matrix(dataline), as.matrix(racer.data))
  
  if(nrow(combined) == 1)
  {
    combined[1,c(2,3,5,6,7,8)] <- failsafe[c(2,3,5,6,7,8)]
    new.dataline <- combined[1,]
  }
  if(nrow(combined) == 2)
  {
    combined[1,c(2,3,5,6,7,8)] <- combined[2,c(2,3,5,6,7,8)]
    new.dataline <- combined[1,]
  }
  if(nrow(combined) >= 3)
  {
    imputed <- impute.NN_HD(data = combined)
    new.dataline <- imputed[1,]
  }
  
  # Truncate to remove elapsed_time (since we want to predict it)
  new.dataline <- new.dataline[c(1:2,4:8)]
  
  # Run the GAM for that race and get an estimated time in response
  est.time <- gam.combo.hr(train.data, new.dataline) 
  
  # Determine the INTERVAL it will fall into
  # This is a very lax and unspecific interval, but it's
  # doing the job for now
  pred.lo = est.time - 0.5*RMSE
  pred.hi = est.time + 0.5*RMSE
  
  out = data.frame(est.time, pred.lo, pred.hi)
  print("Iteration done!")
  out
}

predict.time.newer <- function(raceID, train.data, test.data, test.predict, failsafe, gam.object, RMSE)
{
  # browser()
  
  # Isolate a race to predict among those than need prediction
  dataline = test.predict[which(test.predict$raceID == raceID),]
  ID = dataline$id # Identifies the racer
  racer.data = test.data[which(test.data$id == ID),] # All data for the racer in question
  
  race.date <- as.Date(dataline$start_date_local) # Date of race  
  
  # Reduce racer data to only entries BEFORE this race time,
  # as well only variables that matter for our model
  racer.data <- racer.data[which(as.Date(racer.data$start_date_local) < race.date),]
  racer.data <- racer.data[,1:9]
  dataline <- dataline[,1:9]
  names(racer.data) <- names(train.data) # Make the names match properly for the 2 dataframes
  names(dataline) <- names(train.data)
  racer.data$start_date_local <- NULL
  dataline$start_date_local <- NULL
  
  var.names <- names(dataline)
  # train.data is what we use to predict times
  # racer.data is what we use to IMPUTE missing values in dataline
  
  # Imputation for missing variables
  # This uses all.data to estimate the missing variables in dataline:
  # moving_time, avg_speed, max_speed, avg_hr, avg_hr
  
  #browser()
  
  combined <- rbind(as.matrix(dataline), as.matrix(racer.data))
  
  if(nrow(combined) == 1)
  {
    combined[1,c(2,3,5,6,7,8)] <- failsafe[c(2,3,5,6,7,8)]
    new.dataline <- combined[1,]
  }
  if(nrow(combined) == 2)
  {
    combined[1,c(2,3,5,6,7,8)] <- combined[2,c(2,3,5,6,7,8)]
    new.dataline <- combined[1,]
  }
  if(nrow(combined) >= 3)
  {
    imputed <- impute.NN_HD(data = combined)
    new.dataline <- imputed[1,]

  }
  # Restore variable names after imputation (which turned it into numeric class)
  new.dataline <- as.data.frame(t(new.dataline))
  names(new.dataline) <- var.names

  #browser()
  # Run the GAM for that race and get an estimated time in response
  
  est.time <- gam.predict(gam.object, new.dataline)
  
  # Determine the INTERVAL it will fall into
  # This is a very lax and unspecific interval, but it's
  # doing the job for now
  pred.lo = est.time - RMSE
  pred.hi = est.time + RMSE
  
  out = data.frame(est.time, pred.lo, pred.hi)
  print("Iteration done!")
  out
}





sapply(1:ncol(dat.run.train), function(x) summary(dat.run.train[,x]))

train.avgs = sapply(c(1:4,6:9), function(x) mean(dat.run.train[,x]))

test.pred = predict.time.newer(10468, dat.run.train, dat.run.test, dat.run.to.predict, train.avgs, gam.train)


test = gam.combo.hr(dat.run.train,dat.run.train[2,])

#test = lapply(1:10, function(x) gam.combo.hr(dat.run.train,dat.run.train[x,]))
#test = unlist(test)
#dat.run.train$elapsed_time[1:10]


# Run predict.time over all races to predict to get a result
raceID.predict <- dat.run.to.predict$raceID
# NOTE: raceID == 33 causes HotDeck to Fail without the extra failsafe
# due to lack of data to impute upon!
# NOTE: raceID == 221 has NO entries before the race...need failsafe.
start = proc.time()
predictions <- sapply(raceID.predict[1:length(raceID.predict)],
                      function(x) predict.time.newer(x, dat.run.train, dat.run.test,
                                               dat.run.to.predict, train.avgs, gam.train))
time = proc.time() - start

# Put into a usable form

predictions.df = as.data.frame(t(predictions))

pred.est.time = unlist(predictions.df[,1])
pred.lo = unlist(predictions.df[,2])
pred.hi = unlist(predictions.df[,3])


pred.df = as.data.frame(cbind(pred.est.time, pred.lo, pred.hi))

# Finally, determine which races to opt out of based on accuracy problems, etc.
opt_out = rep(0,nrow(dat.run.to.predict))

# NOTES: Some negative predictions exist. These are opted out, of course
# Remove results and races to predict that don't make sense or are highly unlikely.
opt_out[which(pred.est.time < 0)] <- 1
opt_out[which(pred.est.time > 50000)] <- 1
opt_out[which(dat.run.to.predict$distance > 50000 & pred.est.time < 5000)] <- 1
opt_out[which(dat.run.to.predict$distance == 0)] <- 1
opt_out[which(dat.run.to.predict$distance > 130000)] <- 1

#dat.run.to.predict[which(dat.run.to.predict$distance > 50000),]

#pred.est.time[which(dat.run.to.predict$distance > 50000)]

#data.frame(dat.run.to.predict$distance, pred.est.time, pred.lo, pred.hi)


athleteID = numeric(length(raceID.predict))
for(i in 1:length(raceID.predict))
{
  athleteID[i] = dat.run.to.predict[which(dat.run.to.predict$raceID == raceID.predict[i]),11]
}

# The final resulting CSV takes this form
final.df = data.frame(athleteID, raceID.predict,
                      pred.df$pred.est.time, pred.df$pred.lo,
                      pred.df$pred.hi, opt_out)

names(final.df) = c("athleteID", "raceID", "elapsed_time",
                    "pred_lo", "pred_hi", "opt_out")

write.csv(final.df,"gam_alt2.csv", row.names = FALSE) #write out processed data



# Extra Material


examine = data.frame(final.df[,3], dat.run.to.predict[,1])
names(examine) = c("Pred. Time", "Distance")


gam.model = gam(dat.run.train$elapsed_time ~ dat.run.train$distance + dat.run.train$moving_time +
                  dat.run.train$elev_gain + dat.run.train$avg_speed + dat.run.train$max_speed + 
                  dat.run.train$avg_hr + dat.run.train$max_hr)

data.frame(predictions.df[,1], dat.run.to.predict[,1])

