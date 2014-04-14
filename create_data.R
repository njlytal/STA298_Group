#============ SETUP ============#
# To run this:
# (1) install jsonlite
# (2) unzip the Strava data to the point where you have raw .json files
# (3) point the following function to that directory
setwd("C:/Users/Adam/Desktop/strava/")
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

# Combine data frames
dat <- do.call(rbind, dats)  # create data frame
rm(dats)                     # remove list
gc()                         # clean up memory

# Write file for later access
write.csv(dat, "all_data.csv")