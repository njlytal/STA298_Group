# Loading in the cleaned data

load('~/Downloads/run_data.RData')
run.data <- dat.run
hrm.runners <- run.data[!is.na(run.data$avg_hr) | !is.na(run.data$max_hr),]
length(unique(hrm.runners$id))
# Out of the 1000 runners that we have, 793 (79.3%) of them used a
# heart rate monitor for at least one of their activities.

# Find out what percentage of the time those that use heart rate monitors 
# use them.

percent.use <- sapply(unique(hrm.runners$id), function(i) {
	100*(nrow(hrm.runners[hrm.runners$id == i, ])/nrow(run.data[run.data$id == i, ]))})

summary(percent.use)
hrm.density <- density(percent.use)
d.x <- hrm.density$x
d.y <- hrm.density$y
d.max <- hrm.density$x[which.max(hrm.density$y)]
new.y <- d.y[366:512]
d.max2 <- d.x[366:512][which.max(new.y)]

plot(density(percent.use), main = "Heart Rate Monitor Usage")
abline(v = d.max)
abline(v = d.max2)

# From this we see that, for those people who have used a heart rate monitor at
# least once, the usage is bimodal. The majority of runners who used a heart 
# rate monitor at least once only actually used it in around 6.026% of their 
# activies. The second peak shows that a lot of individuals also used the 
# heart rate monitor ver often. Many used their heart rate monitors about
# 91.44% of the time. The center (use of a heart rate moniter about 50% of
# the time) dips down much lower than the two extremes. Thus, we see that for
# people who use heart rate monitors, they tend to either rarely use them, or
# use them very often.

# Find out how often heart rate monitors were used in races

hrm.runners$workout_type <- as.numeric(hrm.runners$workout_type)
hrm.not.races <- sapply(unique(hrm.runners$id), function(i){
	runner.mat <- hrm.runners[hrm.runners$id == i, ]
	not.races <- runner.mat[-which(runner.mat$workout_type == 1), ]
	100*(nrow(not.races)/nrow(runner.mat))
	
})

no.hrm.runners <- run.data[-hrm.runners]