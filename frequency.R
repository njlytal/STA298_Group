# Junli Zhang
# Explore the running frequncy
# Not completed yet: have not found a way to better express the frequency

# read data from the saved csv file from script "create_data_mod.R"
dat <- read.csv("all_data.csv",row.names=1,as.is=T)
dat[,6:15] <- sapply(dat[,6:15], as.numeric)
dat$avg_speed <- dat$distance/dat$moving_time
dat.run <- dat[dat$type == "Run" ,]     # Running
rm(dat)
gc()
nrow(dat.run)

# Date format
library(chron)
dat.run$dtime <- as.chron(dat.run$start_date_local)
# Remove duplicated time for the same person
# Because two activities should not have the same date and time for the same person
dat.run2 <- dat.run[!duplicated(dat.run[c(5,17)]),]
nrow(dat.run)
nrow(dat.run2)
# I think we can limit our analysis for just normal runs: distance < marathon, time < 24 hours, and normal heart rate
dat.run3 <- subset(dat.run2, avg_speed<12 & distance<42200 & moving_time/3600 <= 24 & avg_hr<1000 & avg_hr > 50)
nrow(dat.run2)
nrow(dat.run3)

# I did not include 2 -> ‘long run’, 3 -> ‘intervals’
run.race <- subset(dat.run3, workout_type=="1") # race
nrow(run.race)
run.default <- subset(dat.run3, workout_type=="0") # default
nrow(run.default)
run01 <- subset(dat.run3, workout_type=="0" | workout_type=="1") # either races or default
unique(run.race$id) # People with races, 258
run.raced <- subset(run01, id %in% unique(run.race$id)) # People with both races and default
nrow(run.raced)

# check the distances in different time for each person
# Color workout type
pdf(file="run_freq_distance.pdf")
for (i in unique(run.race$id)){
	plot(distance~dtime,col=as.numeric(workout_type)+1, subset(run.raced, id==i))
}
dev.off()

# check the average speed in different time for each person
# Color workout type
pdf(file="run_freq_speed.pdf")
for (i in unique(run.race$id)){
	plot(avg_speed~dtime,col=as.numeric(workout_type)+1, subset(run.raced, id==i))
}
dev.off()
