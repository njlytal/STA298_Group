# STA 298 Tests for Models



# Heart Rate imputing experiments

runner3 = dat.run[which(dat.run$id == 3),] # Has a small amount of HR data

runner5 = dat.run[which(dat.run$id == 5),] # Has a fair amount of HR data


# Takes in a single runner and imputes missing average & max heart rate data
# HOWEVER: this won't work if NO heart rate data exists!
hr.test = function(data)
{
    # Impute heart rate data
    avg.hr = data$avg_hr
    avg.hr.avg = mean(avg.hr, na.rm = TRUE) # Finds average "avg hr" for existing values
    avg.hr[is.na(avg.hr)] = avg.hr.avg
    data$avg_hr = avg.hr
    
    max.hr = data$max_hr
    max.hr.avg = mean(max.hr, na.rm = TRUE) # Finds average "max hr" for existing values
    max.hr[is.na(max.hr)] = max.hr.avg
    data$max_hr = max.hr
    
    data.frame(data$avg_hr, data$max_hr)
}

#####################################################################
###################### PRELIMINARY LINEAR MODEL #####################

# This code creates a linear model for a single runners data,
# based on a handful of numeric variables.

# all.data = The matrix of cleaned run data (run.dat)
# id = The ID number of the runner you want to test
lm.combo = function(all.data, id)
{
    data = all.data[which(dat.run$id == id),]
    samp.mod = lm(data$moving_time ~ data$elapsed_time + data$distance +
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

# Same as lm.combo, but includes heart rate imputation.
# NOTE: WON'T work if no heart rate data exists!
lm.combo.hr = function(all.data, id)
{
    data = all.data[which(dat.run$id == id),]
    
    # Impute heart rate data
    avg.hr = data$avg_hr
    avg.hr.avg = mean(avg.hr, na.rm = TRUE) # Finds average "avg hr" for existing values
    avg.hr[is.na(avg.hr)] = avg.hr.avg
    data$avg_hr = avg.hr
    
    max.hr = data$max_hr
    max.hr.avg = mean(max.hr, na.rm = TRUE) # Finds average "max hr" for existing values
    max.hr[is.na(max.hr)] = max.hr.avg
    data$max_hr = max.hr
    
    # Compose linear model
    samp.mod = lm(data$moving_time ~ data$elapsed_time + data$distance +
                      data$elev_gain + data$max_speed + data$avg_speed +
                      data$avg_hr + data$max_hr)
    
    # Residuals info - Can uncomment for use on single runners
    # plot(samp.mod[[2]])
    # qqnorm(samp.mod[[2]])
    # qqline(samp.mod[[2]])
    
    y = data$moving_time
    beta = t(t(as.numeric(samp.mod$coefficients)))
    X = as.matrix(data.frame(rep(1,length(y)), data$elapsed_time, data$distance,
                             data$elev_gain, data$max_speed, data$avg_speed, data$avg_hr,
                             data$max_hr))
    y.est = X%*%beta
    
    compare = data.frame(y, y.est, abs(y-y.est), 100*abs(y-y.est)/y)
    names(compare) = c("Actual", "Estimate", "Abs. Diff.", "% Diff.")
    
    out = list(samp.mod, beta, compare)
    out
}


# Difference is subtle at best...
r5.no.hr = lm.combo(dat.run, 5)
r5.with.hr = lm.combo.hr(dat.run, 5)

r3.no.hr = lm.combo(dat.run, 3)
r3.with.hr = lm.combo.hr(dat.run, 3)


#Compare both versions
summary(r3.no.hr[[3]])
summary(r3.with.hr[[3]])

# Effectiveness stats for first 20 runners
# NOTE: Can't use test[3,] if testing too many runners at a time (usually > 300)
test = sapply(1:333, function(x) summary(lm.combo(dat.run, x)[[3]][,4]))
test[3,] # Median of percentage off-base from actual moving time.

# NOTE: For first 333 runners, the average median percentage off base for
# estimated moving_time is 2.642 %

# HOWEVER, this is using model that have been fit to the exact data
# to begin with. Ideally, we would divide the data into training and
# test sets, which will likely lead to significantly worse
# performance.

##################################################################
###################### IMPROVED LINEAR MODEL #####################

runner5 = dat.run[which(dat.run$id == 5),]
nrow(runner5)
size = as.integer(nrow(runner5)/2) # Size of training data (1/2 total)
r5.train.num = sample(1:nrow(runner5), size, replace = FALSE) # First half of data

r5.train = runner5[r5.train.num,]
r5.test = runner5[-r5.train.num,]


# Functions just like lm.combo, but now builds the model on
# one half of the data (randomly selected), and tests on the
# other half of the data.

lm.combo.2 = function(all.data, id)
{
    data = all.data[which(dat.run$id == id),]
    
    # Divide data into train and test data sets
    size = as.integer(nrow(data)/2)
    train.num = sample(1:nrow(data), size, replace = FALSE) # First half of data
    train = data[train.num,]
    test = data[-train.num,] # Everything not in training set is in test set
    
    samp.mod = lm(train$moving_time ~ train$elapsed_time + train$distance +
                      train$elev_gain + train$max_speed + train$avg_speed)
    
    # Residuals info - Can uncomment for use on single runners
    # plot(samp.mod[[2]])
    # qqnorm(samp.mod[[2]])
    # qqline(samp.mod[[2]])
    
    
    y = test$moving_time
    beta = t(t(as.numeric(samp.mod$coefficients)))
    X = as.matrix(data.frame(rep(1,nrow(test)), test$elapsed_time, test$distance,
                             test$elev_gain, test$max_speed, test$avg_speed))
    y.est = X%*%beta
    
    compare = data.frame(y, y.est, abs(y-y.est), 100*abs(y-y.est)/y)
    names(compare) = c("Actual", "Estimate", "Abs. Diff.", "% Diff.")
    
    out = list(samp.mod, coeffs, compare)
    out
}


test = lm.combo.2(dat.run, 3)

summary(lm.combo(dat.run,3)[[3]])
summary(lm.combo.2(dat.run,3)[[3]])

# NEXT: Expand beyond linear models



########### MISC. STUFF (unrelated) ##############

# Note on which variables have how many NAs
NAs = sapply(1:length(runner1), function(x) sum(is.na(runner1[,x])))

fullvals = which(NAs == 16)
viable.vars = names(dat.run[,fullvals])

dat.run = as.matrix(dat.run)

mean(dat.run$avg_hr, na.rm = TRUE) # Overall AVG HR

mean(dat.run$max_hr, na.rm = TRUE) # Overall MAX HR

# TOTAL NUMBER OF RACES
sum(dat.run$workout_type == 1, na.rm = TRUE) # only 1980

