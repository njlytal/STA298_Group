# ==================== DATA CLEANUP ======================#
# Cleans the data by removing obvious errors and anomalies.

# From here, we specify limitations on the data
# Please add any additional limitations as they are discovered

# For cleaning all_data (test data)
# dat.run <- all_data[all_data$type == "Run", ]
# dat.run$type <- NULL
# rm(all_data)
# dat.run$row.names <- NULL

#dat.run <- read.csv(file = "run_data.csv", header=T) #line to read in the run_data.csv to avoid repeated processing
dat.run -> dat.run.orig

dat.run <- dat.run[dat.run$avg_speed < 12, ] # 12 m/s is faster than world record 100m
# NOTE: We can't set the avg_speed much lower due to shorter, non-marathon runs existing
dat.run <- dat.run[dat.run$moving_time > 30, ] # Clean out some junk data where they aren't moving
dat.run <- dat.run[dat.run$moving_time <= dat.run$elapsed_time, ] # Runners can't move more than total time
dat.run <- dat.run[dat.run$moving_time > (dat.run$elapsed_time/4), ] # But should be moving at least 25% of it


dat.run <- dat.run[dat.run$distance < 60000, ] # Marathon = 50k, with extra buffer to be sure
dat.run <- dat.run[dat.run$elapsed_time < 86400, ] # Keep total time under 1 day
dat.run <- dat.run[dat.run$max_speed < 12, ]#Usain Bolt world record speed 12.42m/s. May want to look at what we are throwing out, errors due to gps problems?
dat.run$avg_cadences = NULL # Remove this variable, which refers to cycling RPM


# Turn heart rate to NA if unrealistic
dat.run[which(dat.run$avg_hr > 200 | dat.run$avg_hr < 50), 13] = NA
dat.run[which(dat.run$max_hr > 200 | dat.run$max_hr < 50), 14] = NA

dat.run <- dat.run[complete.cases(dat.run[8:9]),] #remove entries with NA for elapsed and moving time

write.csv(dat.run, "run_data_clean.csv") #write out processed data for later handling

# Working on a way to isolate duplicates not already covered earlier
# (i.e. Same time, place, and person, but different other variables like description)
