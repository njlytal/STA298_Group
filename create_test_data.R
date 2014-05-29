#========= Adam Austin, Nicholas Lytal, et al=============#
# NOTE: This is modified to read in the TEST data!

# GOALS TO REACH WITH THIS CODE
# 1. Isolate a data.frame of appropriate test data (no extraneous variables).
# This contains ONLY NON-RACE DATA
# This means distance, elapsed_time, elev_gain, max_speed, & avg_speed.
# COULD include heart_rate, but this variable doesn't exist for everyone.

# 2. Isolate a data.frame of test data consisting ONLY of RACES (i.e. any
# event with a raceID that isn't NA). These are the races we are trying
# to predict. 

# 3. 



#============ SETUP ============#
# To run this:
# (1) install jsonlite
# (2) unzip the Strava data to the point where you have raw .json files
# (3) place demographic csv file "anonAthleteInfo_1000.csv" (Week 2 handout)
#     in same directory
# (4) point the following function to that directory
# END RESULT: Run Data + Demographic Data, UNCLEANED
setwd("~/Desktop/StravaTest") # For the test data for final project
library(jsonlite)

setwd("~/Desktop/StravaSample1") 
dats.2 <- lapply(2:4, function(i)
  fromJSON(txt = paste(i, ".json", sep = "")))



### Parse JSON files
# Output: list of data frames
filenames = list.files()

dats <- lapply(2:4, function(i)
  fromJSON(txt = filenames[i]))

dats <- lapply(1:1000, function(i)
  fromJSON(txt = filenames[i]))

# WARNING! There are DIFFERENT VARIABLES in the Test Data!
# Common ones include: names, distance, moving_time, elapsed_time,
# type, start_date_local, max_speed, description (All the ones in our lin/gam model)
# Ones with analogues include:
# elev_gain -> total_elevation_gain
# avg_spd -> average_speed (NOTE: We did this one manually, but now it's included)
# avg_hr -> average_heartrate
# max_hr -> max_heartrate
# avg_cadence -> average_cadence


### Create runner ID and activity number, and combine data frames
# Generate runner ID and activity number as variables in each data frame
for(individual in 1:length(dats)) {
  dats[[individual]]$id       <- individual
  dats[[individual]]$eventID <- 1:nrow(dats[[individual]])
  # raceID is different
}

# Remove duplicated entries (ind refers to "individual")
dats <- lapply(dats, function(ind) ind[!duplicated(ind), ])



# Combine data frames
dat <- do.call(rbind, dats)  # create data frame
rm(dats)                     # remove list
gc()                         # clean up memory


# Write file for later access
write.csv(dat, "~/Desktop/all_data.csv")

# ================== FINAL CONVERSIONS ================== #
# Slight modifications to isolate run + demo data

# Convert some data types from character to numeric
dat[,6:15] <- sapply(dat[,6:15], as.numeric)

# Average speed as an additional variable
dat[,31] <- dat$distance/dat$moving_time
colnames(dat)[31] <- "avg_speed"

# Reduce to run data ONLY
dat.run <- dat[dat$type == "Run" ,]
rm(dat)
