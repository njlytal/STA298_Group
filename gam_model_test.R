# Strava Data w/ gam()


test = gam(dat.run$moving_time ~ dat.run$elapsed_time + dat.run$distance +
             dat.run$elev_gain + dat.run$max_speed + dat.run$avg_speed)


# modified from lin_model_test.R (not much changed yet)
gam.combo = function(all.data, id)
{
  data = all.data[which(dat.run$id == id),]
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
  
  compare = data.frame(y, y.est, abs(y-y.est), 100*abs(y-y.est)/y)
  names(compare) = c("Actual", "Estimate", "Abs. Diff.", "% Diff.")
  
  out = list(samp.mod, beta, compare)
  out
}