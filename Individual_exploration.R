library(plyr)
library(ggplot2)
library(gridExtra)
#rundata <- read.table("run_data.csv",sep=",",header=T)

#calculate some stats for each individual
means <- ddply(dat.run, "id", numcolwise(mean))
sds <- ddply(dat.run, "id", numcolwise(sd))
maxs <- ddply(dat.run, "id", numcolwise(max))
mins <- ddply(dat.run, "id", numcolwise(min))

#plot some data for means
p1 <- qplot(means$moving_time/60,means$elapsed_time/60, xlab = "Moving time (min)", ylab = "Elapsed time (min)", main = "Individual means")
p2 <- qplot(means$distance,means$moving_time/60, xlab = "Distance (meters)",ylab = "Moving time (min)", main = "Individual means")
p3 <- qplot(means$distance,means$elapsed_time/60, xlab = "Distance (meters)",ylab = "Elapsed time (min)", main = "Individual means")
grid.arrange(p1,p2,p3, ncol=2)

#plot some data for standard deviations
p1 <- qplot(sds$moving_time/60,sds$elapsed_time/60, xlab = "Moving time (min)", ylab = "Elapsed time (min)", main = "Individual sds")
p2 <- qplot(sds$distance,sds$moving_time/60, xlab = "Distance (meters)",ylab = "Moving time (min)", main = "Individual sds")
p3 <- qplot(sds$distance,sds$elapsed_time/60, xlab = "Distance (meters)",ylab = "Elapsed time (min)", main = "Individual sds")
grid.arrange(p1,p2,p3, ncol=2)

#plot some data for maximum values
p1 <- qplot(maxs$moving_time/60,maxs$elapsed_time/60, xlab = "Moving time (min)", ylab = "Elapsed time (min)", main = "Individual maxs")
p2 <- qplot(maxs$distance,maxs$moving_time/60, xlab = "Distance (meters)",ylab = "Moving time (min)", main = "Individual maxs")
p3 <- qplot(maxs$distance,maxs$elapsed_time/60, xlab = "Distance (meters)",ylab = "Elapsed time (min)", main = "Individual maxs")
grid.arrange(p1,p2,p3, ncol=2)

#plot some data for minimum values
p1 <- qplot(mins$moving_time/60,mins$elapsed_time/60, xlab = "Moving time (min)", ylab = "Elapsed time (min)", main = "Individual mins")
p2 <- qplot(mins$distance,mins$moving_time/60, xlab = "Distance (meters)",ylab = "Moving time (min)", main = "Individual mins")
p3 <- qplot(mins$distance,mins$elapsed_time/60, xlab = "Distance (meters)",ylab = "Elapsed time (min)", main = "Individual mins")
grid.arrange(p1,p2,p3, ncol=2)

#Look at distance
p1 <- qplot(means$distance, main = "Means")
p2 <- qplot(sds$distance, main = "SDs")
p3 <- qplot(maxs$distance, main = "Maximums")
p4 <- qplot(mins$distance, main = "Minimums")

grid.arrange(p1,p2,p3,p4, ncol=2, main = "Distance")

#Look at moving time
p1 <- qplot(means$moving_time/60, main = "Means")
p2 <- qplot(sds$moving_time/60, main = "SDs")
p3 <- qplot(maxs$moving_time/60, main = "Maximums")
p4 <- qplot(mins$moving_time/60, main = "Minimums")

grid.arrange(p1,p2,p3,p4, ncol=2, main = "Moving time")

#Look at elapsed time
p1 <- qplot(means$elapsed_time/60, main = "Means")
p2 <- qplot(sds$elapsed_time/60, main = "SDs")
p3 <- qplot(maxs$elapsed_time/60, main = "Maximums")
p4 <- qplot(mins$elapsed_time/60, main = "Minimums")

grid.arrange(p1,p2,p3,p4, ncol=2, main = "Elapsed time")