# Strava Data w/ gam()
library(gam)

test = gam(dat.run$moving_time ~ dat.run$elapsed_time + dat.run$distance +
             dat.run$elev_gain + dat.run$max_speed + dat.run$avg_speed)


# modified from lin_model_test.R (not much changed yet)
gam.combo = function(data)
{
  browser()
  samp.mod = gam(data$moving_time ~ data$elapsed_time + data$distance +
                  data$elev_gain + data$max_speed + data$avg_speed)
  
  # Residuals info - Can uncomment for use on single runners
  # plot(samp.mod[[2]])
  # qqnorm(samp.mod[[2]])
  # qqline(samp.mod[[2]])
  
  
  y = data$moving_time
  beta = t(t(as.numeric(samp.mod$coefficients)))
  X = as.matrix(data.frame(rep(1,length(y)), data$elapsed_time, data$distance,
                           data$elev_gain, data$max_speed, data$avg_speed))
  y.est = X%*%beta
  
  err = y-y.est
  n = nrow(y.est)
  RMSE = sqrt(sum(err*err)/n)

  
  compare = data.frame(y, y.est, RMSE)
  names(compare) = c("Actual", "Estimate", "RMSE")
  
  #out = list(samp.mod, beta, compare)
  compare
}

test = gam.combo(dat.run.train)


summary(dat.run.train[,10])

dat.run.train = dat.run.train[-which(is.na(dat.run.train[,10])),]
