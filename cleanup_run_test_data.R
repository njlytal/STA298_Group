# ==================== DATA CLEANUP ======================#
# Cleans the data by removing obvious errors and anomalies.
# This will isolate the events that have a raceID
# And further isolate those that we must predict.

load("~/Desktop/STA 298 findings/test_run_data_in_progress.RData")

# For cleaning all_data (test data)
dat.run.test <- all_data[all_data$type == "Run", ]
dat.run.test$type <- NULL
rm(all_data)
dat.run.test$row.names <- NULL

# Number of raceID races
sum(!is.na(dat.run.test$raceID))

# Convert appropriate data columns to numeric form - NOT NEEDED
#dat.run[,c(1:4,6:9)] <- sapply(dat.run[,c(1:4,6:9)], as.numeric)


# Isolates all races from test data by picking out
# which ones DO NOT have NA for a raceID (only events with a raceID fit this criterion)
dat.run.races <- dat.run.test[which(dat.run.test$raceID != "NA"),]

# Of these 10734 races, exactly HALF (5367) are missing "elapsed_time" entries,
# as well as other variables that would not be known beforehand (max_speed, etc.)

# Isolate races with missing elapsed_time entries. We must predict these.
dat.run.to.predict <- dat.run.races[-which(dat.run.races$elapsed_time != "NA") ,]

# dat.run <- read.csv(file = "run_data.csv", header=T) #line to read in the run_data.csv to avoid repeated processing

to.clean = c(which(is.na(dat.run.test$raceID) == T), which(dat.run.races$elapsed_time != "NA"))

# dat.run has all non-race data, and all race data that we AREN'T predicting
dat.run <- dat.run.test[to.clean,]
# dat.run -> dat.run.orig # for safekeeping
dat.run <- dat.run.orig


dat.run <- dat.run[dat.run$average_speed < 12, ] # 12 m/s is faster than world record 100m
# NOTE: We can't set the avg_speed much lower due to shorter, non-marathon runs existing
dat.run <- dat.run[dat.run$moving_time <= dat.run$elapsed_time, ] # Runners can't move more than total time
dat.run <- dat.run[dat.run$moving_time > (dat.run$elapsed_time/4), ] # But should be moving at least 25% of it

dat.run <- dat.run[dat.run$distance < 60000, ] # Marathon = 50k, with extra buffer to be sure
dat.run <- dat.run[dat.run$elapsed_time < 86400, ] # Keep total time under 1 day
dat.run <- dat.run[dat.run$max_speed < 12, ]#Usain Bolt world record speed 12.42m/s. May want to look at what we are throwing out, errors due to gps problems?
dat.run$avg_cadences = NULL # Remove this variable, which refers to cycling RPM


# Turn heart rate to NA if unrealistic
dat.run[which(dat.run$average_heartrate > 200 | dat.run$average_heartrate < 50), 13] = "NA"
dat.run[which(dat.run$max_heartrate > 200 | dat.run$max_heartrate < 50), 14] = "NA"

dat.run <- dat.run[complete.cases(dat.run[2:3]),] #remove entries with NA for elapsed and moving time

dat.run$V14 <- NULL
dat.run$HR <- NULL

dat.run.test <- dat.run
rm(dat.run)
#write.csv(dat.run, "run_data.csv") #write out processed data for later handling
