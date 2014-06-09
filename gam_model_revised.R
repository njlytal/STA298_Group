# Strava Data w/ gam()
library(mgcv)
library(mboost)


# modified from lin_model_test.R (not much changed yet)
gam.combo.train = function(data)
{
  #browser()
  samp.mod = gam(elapsed_time ~ s(distance) + s(moving_time) + s(elev_gain) +
                                  s(avg_speed) + s(max_speed) + s(avg_hr) +
                                  s(max_hr), data = data)
  
  return(samp.mod)
  
  y = data$moving_time
  beta = t(t(as.numeric(samp.mod$coefficients)))
  X = as.matrix(data.frame(rep(1,length(y)), data$distance, data$moving_time,
                             data$elev_gain, data$avg_speed, data$max_speed, 
                             data$avg_hr, data$max_hr))
  y.est = X%*%beta
  
  err = abs(y-y.est)
  n = nrow(y.est)

  RMSE = sqrt(sum(err*err)/n)
  
  
  compare = data.frame(y, y.est, err, RMSE)
  names(compare) = c("Actual", "Estimate", "Abs. Err.", "RMSE")
  
  #out = list(samp.mod, beta, compare)
  compare
  #samp.mod
}

# gam is a gam object (like gam.train)
gam.tester = function(gam, traindata, testdata)
{
  #browser()
  preds = predict(gam, type = "terms", newdata = testdata)
  intercept = as.numeric(gam[[1]][1])
  
  y.est = sapply(1:nrow(preds), function(x) sum(preds[x,]) + intercept)
  y = traindata$elapsed_time
  
  err = abs(y-y.est)
  n = length(y.est)
  
  RMSE = sqrt(sum(err*err)/n)
  
  compare = data.frame(y, y.est, err, RMSE)
  names(compare) = c("Actual", "Estimate", "Abs. Err.", "RMSE")
  
  #out = list(samp.mod, beta, compare)
  compare  
}

gam.predict = function(gam, testdata)
{
  #browser()
  y.est = as.numeric(predict(gam, newdata = testdata))
  y.est
}

test.dat = dat.run.train[1,]
gam.predict(gam.train, test.dat)

# This is the GAM constructed by the Training Data
gam.train = gam.combo.train(dat.run.train) # 2:45 to construct

test = gam.tester(gam.train, dat.run.train, dat.run.train)
RMSE = test[1,4]

plot(test[,1],test[,2], main = "Predicted vs Actual Times (Training Data)",
     xlab = "Actual Times", ylab = "Predicted Times")
lines(test[,1], test[,1])

plot(test.2[,1],test.2[,2], main = "Predicted vs Actual Times (Training Data)",
     xlab = "Actual Times", ylab = "Predicted Times")
lines(test.2[,1], test.2[,1])

plot(test.3[,1],test.3[,2], main = "Predicted vs Actual Times (Training Data)",
     xlab = "Actual Times", ylab = "Predicted Times")
lines(test.3[,1], test.3[,1])

gam.combo.train.2 = function(data)
{
  #browser()
  samp.mod = gam(elapsed_time ~ s(distance) + s(elev_gain) +
                   s(avg_speed) + s(max_speed) + s(avg_hr) +
                   s(max_hr), data = data)
  
  return(samp.mod)

}





gam.combo.hr = function(data, dataline)
{
  # browser()
  samp.mod = gam(data$elapsed_time ~ data$distance + data$moving_time +
                   data$elev_gain + data$avg_speed + data$max_speed + 
                   data$avg_hr + data$max_hr)
  
  
  #y = data$moving_time
  beta = t(t(as.numeric(samp.mod$coefficients)))
  #X = as.matrix(data.frame(rep(1,nrow(all.data)), data$moving_time, data$distance,
  #                         data$elev_gain, data$max_speed, data$avg_speed))
  X = t(as.matrix(c(1,dataline)))
  # Remove elapsed_time and start_local_date
  y.est = X%*%beta # Estimates elapsed time using that particular race's data
  
  #compare = data.frame(y, y.est, abs(y-y.est), 100*abs(y-y.est)/y)
  #names(compare) = c("Actual", "Estimate", "Abs. Diff.", "% Diff.")
  
  #out = list(samp.mod, beta, compare)
  #out
  y.est # Returns the estimated moving_time for this particular race.
}





#####
#NEW STUFF!!!!!!
#####  
gam.combo.boost = function(data)
{
  y = data$elapsed_time
  x = data[,-c(3,5)]
  gb = gamboost(elapsed_time ~ distance + moving_time +
                     elev_gain + avg_speed + max_speed + 
                     avg_hr + max_hr, data = data)
  gb
}

boost.start = proc.time()
test.boost = gam.combo.boost(dat.run.train)
boost.time = proc.time() - boost.start

names(test.boost)
test.3 = gam.tester.2(test.boost, dat.run.train, dat.run.train)


# gam is a gam object (like gam.train)
gam.tester.2 = function(gam, traindata, testdata)
{
  browser()
  y.est = predict(gam, type = "response", newdata = testdata)
  intercept = as.numeric(gam[[3]])
  
  y = traindata$elapsed_time
  
  err = abs(y-y.est)
  n = length(y.est)
  
  RMSE = sqrt(sum(err*err)/n)
  
  compare = data.frame(y, y.est, err, RMSE)
  names(compare) = c("Actual", "Estimate", "Abs. Err.", "RMSE")
  
  #out = list(samp.mod, beta, compare)
  compare  
}

