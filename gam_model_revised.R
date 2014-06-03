# Strava Data w/ gam()
library(gam)


# modified from lin_model_test.R (not much changed yet)
gam.combo.no.hr = function(data, dataline)
{
  samp.mod = gam(data$elapsed_time ~ data$moving_time + data$distance +
                   data$elev_gain + data$max_speed + data$avg_speed)
  
  # Residuals info - Can uncomment for use on single runners
  # plot(samp.mod[[2]])
  # qqnorm(samp.mod[[2]])
  # qqline(samp.mod[[2]])
  
  
  #y = data$moving_time
  beta = t(t(as.numeric(samp.mod$coefficients)))
  #X = as.matrix(data.frame(rep(1,nrow(all.data)), data$moving_time, data$distance,
  #                         data$elev_gain, data$max_speed, data$avg_speed))
  X = dataline
  y.est = X%*%beta # Estimates elapsed time using that particular race's data
  
  #compare = data.frame(y, y.est, abs(y-y.est), 100*abs(y-y.est)/y)
  #names(compare) = c("Actual", "Estimate", "Abs. Diff.", "% Diff.")
  
  #out = list(samp.mod, beta, compare)
  #out
  y.est # Returns the estimated moving_time for this particular race.
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
