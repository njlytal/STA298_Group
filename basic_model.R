# A Basic Linear Regression Model
# to estimate race times


# Numerical Variables
sapply(1:31, function(x) class((dat.run[,x])))
dat.run.num = dat.run[,which(sapply(1:31, function(x) class((dat.run[,x])))=="numeric")]


# Model moving_time ~ distance, max_speed, elev_gain

# dat.run.num = as.matrix(dat.run.num)
comp.num = complete.cases(predictors)

race.time = dat.run.num$moving_time

predictors = as.matrix(dat.run.num[,-c(3,4, 10)])

test = dat.run.num

test$avg_speed = NULL

basic.mod = lm(race.time~predictors)
basic.mod


leaps(x = predictors, y = race.time, method ="Cp" )

sapply(1:11, function(x) summary(dat.run.num[,x]))


# 2 Stage Approach
# Decide variables
# 1. Use algorithm (EM, etc.) to find missing values
# 2. Use complete data frame for prediction

# solve(t(X)%*%X)%*%t(X)%*%Y

