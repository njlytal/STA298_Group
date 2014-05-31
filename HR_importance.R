# HR_importance

# Determine whether or not heart rate matters

# dat.run is the data set with only numerical variables
dat.run$HR <- -1*is.na(dat.run$max_hr)+1
test.dat.run <- dat.run[-c(7,8)]


gam.combo = function(all.data, id)
{
  data = all.data[which(dat.run$id == id),]
  samp.mod = gam(data$moving_time ~ data$elapsed_time + data$distance +
                   data$elev_gain + data$max_speed + data$avg_speed + data$HR)
  
  # Residuals info - Can uncomment for use on single runners
  # plot(samp.mod[[2]])
  # qqnorm(samp.mod[[2]])
  # qqline(samp.mod[[2]])
  
  
  y = data$moving_time
  beta = t(t(as.numeric(samp.mod$coefficients)))
  X = as.matrix(data.frame(rep(1,length(y)), data$elapsed_time, data$distance,
                           data$elev_gain, data$max_speed, data$avg_speed,
                           data$HR))
  y.est = X%*%beta
  
  compare = data.frame(y, y.est, abs(y-y.est), 100*abs(y-y.est)/y)
  names(compare) = c("Actual", "Estimate", "Abs. Diff.", "% Diff.")
  
  out = list(samp.mod, beta, compare)
  out
}


lm.combo = function(all.data, id)
{
  browser()
  data = all.data[which(dat.run$id == id),]
  samp.mod = lm(data$moving_time ~ data$elapsed_time + data$distance +
                  data$elev_gain + data$max_speed + data$avg_speed, data$HR)
  
  # Residuals info - Can uncomment for use on single runners
  # plot(samp.mod[[2]])
  # qqnorm(samp.mod[[2]])
  # qqline(samp.mod[[2]])
  
  
  y = data$moving_time
  beta = t(t(as.numeric(samp.mod$coefficients)))
  X = as.matrix(data.frame(rep(1,length(y)), data$elapsed_time, data$distance,
                           data$elev_gain, data$max_speed, data$avg_speed, data$HR))
  y.est = X%*%beta
  
  compare = data.frame(y, y.est, abs(y-y.est), 100*abs(y-y.est)/y)
  names(compare) = c("Actual", "Estimate", "Abs. Diff.", "% Diff.")
  
  out = list(samp.mod, beta, compare)
  out
}