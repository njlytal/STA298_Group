#========= Adam Austin, Nicholas Lytal, et al=============#

#============ SETUP ============#
# To run this:
# (1) install jsonlite
# (2) unzip the Strava data to the point where you have raw .json files
# (3) place demographic csv file in same directory
# (4) point the following function to that directory
# END RESULT: Run Data + Demographic Data, UNCLEANED
setwd("~/Desktop/StravaSample1")
library(jsonlite)

### Parse JSON files
# Output: list of data frames
dats <- lapply(1:1000, function(i)
    fromJSON(txt = paste(i, ".json", sep = "")))

### Create runner ID and activity number, and combine data frames
# Generate runner ID and activity number as variables in each data frame
for(individual in 1:length(dats)) {
    dats[[individual]]$id       <- individual
    dats[[individual]]$activity <- 1:nrow(dats[[individual]])
}

# Remove duplicated entries (ind refers to "individual")
dats <- lapply(dats, function(ind) ind[!duplicated(ind), ])

# === NEW ADDITIONS ===
# For reference: dats[[1]][1,] is the first row for the first person

# *** DEMOGRAPHIC INFO ***

# Directory will vary depending on user
setwd("~/Desktop")
demo <- read.csv("anonAthleteInfo_1000.csv")
demo.orig <- demo # Unmodified copy of original demo data
# demo <- demo.orig # Restore to original data

# Friend & Follower columns dropped (they only have NA entries anyway)
# Date & Measurement preferences dropped (probably insignificant?)
demo <- demo[,-c(6,7)]

# Change created_at & updated_at to be Date objects
demo[,7] <- as.Date(demo[,7])
demo[,8] <- as.Date(demo[,8])

# NOTE: Consider dropping date & measurement preferences as unimportant

# Merge demographic data with raw data
# Whenever id = X, put in column X of demographic data
for(i in 1:1000){
    dats[[i]][,19:30] <- demo[i,]
}

# === END NEW ADDITIONS ===

# Combine data frames
dat <- do.call(rbind, dats)  # create data frame
rm(dats)                     # remove list
gc()                         # clean up memory

# Write file for later access
write.csv(dat, "all_data.csv")

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
