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

# Set directory to location of json files
setwd("/Volumes/DATA2/users/trhowell/tmp/sta298/testdata/") # For the test data for final project
library(jsonlite)

### Parse JSON files
# Output: list of data frames
filenames = list.files()

# TAKES ABOUT 16-17 min. for each 100


dats <- lapply(1001:1001, function(i)
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
# Also creates a "dummy" variable that detects the presence of a heart rate
# variable, which is NOT present in all .json files.

# List of variables to keep (for equal number of columns)

keep.list = c("moving_time", "elapsed_time", "distance", "max_speed",
              "average_speed", "total_elevation_gain", "id",
              "eventID", "raceID", "HR", "average_heartrate", "max_heartrate",
              "type", "start_date_local")

# Takes about 33 sec. for 100 files
  for(individual in 1:length(dats)) {

    # Search for presence of heart rate data (HR indicates this)
    if(sum(names(dats[[individual]]) == "average_heartrate") > 0)
    {
      dats[[individual]]$HR <- 1
    }
    else # otherwise initialize the variables as NA so they aren't totally absent
    {
      dats[[individual]]$average_heartrate <- NA
      dats[[individual]]$max_heartrate <- NA
    }
    dats[[individual]]$id       <- individual
    dats[[individual]]$eventID <- 1:nrow(dats[[individual]])
    dats[[individual]]$HR <- 0
    # Cut unneeded variables from an existing object without making a new one
    
    cut.cols = numeric(length(names(dats[[individual]])))
    for(i in 1:length(names(dats[[individual]]))) # for each variable...
    {
      x = numeric(length(keep.list))
      
      for(j in 1:length(keep.list)) # For each variable to keep
      {
        x[j] = (names(dats[[individual]][i]) == keep.list[j]) # tries to match ith var with list
      }
      if(sum(x) == 0)
      {
        cut.cols[i] = 1 # Notes that the column of this index can be cut
      }
      
    }
    # Now cut everything in cut.cols
    cut = which(cut.cols == 1)
    
    dats[[individual]] = dats[[individual]][,-cut]
    
  }



# Remove duplicated entries (ind refers to "individual")
dats <- lapply(dats, function(ind) ind[!duplicated(ind), ])




# Combine data frames
dat <- do.call(rbind, dats)  # create data frame
rm(dats)                     # remove list
gc()                         # clean up memory


# Write file for later access
<<<<<<< HEAD
write.csv(dat.run, "~/Desktop/all_data.csv")
=======
write.csv(dat, "all_data.csv")
>>>>>>> FETCH_HEAD

# ================== FINAL CONVERSIONS ================== #
# Slight modifications to isolate run + demo data



# Reduce to run data ONLY
dat.run <- dat[dat$type == "Run" ,]
dat.run$type <- NULL # Remove variable "type" one we're down to Run data only
rm(dat)


# Convert all data columns to numeric form
dat.run[,1:12] <- sapply(dat.run[,1:12], as.numeric)
# This may introduce NAs by coercion, but this is only for "NA" to begin with.
# Only did so within first 100

# Repeat for all groups

dat.run.test = dat.run # Establish the name as dat.run.test to differentiate from training data

write.csv(dat.run.test,"test.run.data.csv") #write out processed data
