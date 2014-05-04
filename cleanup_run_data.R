# ==================== DATA CLEANUP ======================#
# Cleans the data by removing obvious errors and anomalies.

# From here, we specify limitations on the data
# Please add any additional limitations as they are discovered
dat.run -> dat.run.orig

dat.run <- dat.run[dat.run$avg_speed < 12, ] # 12 m/s is faster than world record 100m
# NOTE: We can't set the avg_speed much lower due to shorter, non-marathon runs existing
dat.run <- dat.run[dat.run$moving_time < dat.run$elapsed_time, ] # Runners can't move more than total time
dat.run <- dat.run[dat.run$moving_time > (dat.run$elapsed_time/4), ] # But should be moving at least 25% of it

dat.run <- dat.run[dat.run$distance < 60000, ] # Marathon = 50k, with extra buffer to be sure
dat.run <- dat.run[dat.run$moving_time < 86400, ] # Keep moving time under 1 day
dat.run <- dat.run[dat.run$elapsed_time < 86400, ] # Keep moving time under 1 day
dat.run <- dat.run[complete.cases(dat.run[8:9]),] #remove entries with NA for elapsed and moving time
dat.run <- dat.run[dat.run$max_speed < 12, ]#Usain Bolt world record speed 12.42m/s
dat.run$avg_cadences = NULL # Remove this variable, which refers to cycling RPM

# Turn heart rate to NA if unrealistic
dat.run[which(dat.run$avg_hr > 200 | dat.run$avg_hr < 50), 13] = NA
dat.run[which(dat.run$max_hr > 200 | dat.run$max_hr < 50), 14] = NA

# write.csv(dat.run, "run_data.csv")
# Working on a way to isolate duplicates not already covered earlier
# (i.e. Same time, place, and person, but different other variables like description)
