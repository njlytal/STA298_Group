
#========= Adam Austin==========#

#============ SETUP ============#
# To run this:
# (1) install jsonlite
# (2) unzip the Strava data to the point where you have raw .json files
# (3) point the following function to that directory
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
demo <- read.csv("~/Desktop/STA 298 findings/anonAthleteInfo_1000.csv")
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

# *****************************************************************************
# ************************ NEW MATERIAL ***************************************
# **********************(Nicholas Lytal)***************************************

# *** DATA CLEANING ***
# Convert some data types from character to numeric
dat[,6:15] <- sapply(dat[,6:15], as.numeric)

# Average speed as an additional variable
dat[,31] = dat$distance/dat$moving_time
colnames(dat)[31] = "avg_speed"



# Create separate data set for the specific event types desired
dat.run <- dat[dat$type == "Run" ,]     # Running
dat.ride <- dat[dat$type == "Ride" ,]   # Bicycling
dat.swim <- dat[dat$type == "Swim" ,]   # Swimming

# ********************* PLOTS *************************

# Sorting by country
library("lattice")

# Future task: Look at individuals' performances, not just overall
# runs for countries


dat.mod = dat.run[which(dat.run$distance < 70000 & dat.run$avg_speed < 12 & dat.run$max_speed < 20),]

xyplot(avg_speed ~ distance | country, data = dat.mod, xlab = "Distance (m)",
       ylab = "Avg. Speed (m/s)")

xyplot(max_speed ~ distance | country, data = dat.mod, xlab = "Distance (m)",
       ylab = "Max Speed (m/s)")

fili = dat.run[which(dat.run$country == "Philippines"),] 





# This person made a typo in his own country! # 367!
noreg = dat.run[which(dat.run$country == "Noreg"),]

all.country = unique(dat$country)

avg.distance = lapply(length(all.country),
                      function(x) mean(dat$country == all.country[x]))

# Smooth Scatter of USA run times (avg_speed v distance)
test1 = dat.run[which(dat.run$country == "United States" & dat.run$distance < 75000 & dat.run$avg_speed < 15),]
smoothScatter(x = test1$distance, y = test1$avg_speed)

# Smooth Scatter of USA run times (max_speed v distance)
test2 = dat.run[which(dat.run$country == "United States" & dat.run$distance < 75000 & dat.run$max_speed < 20),]
smoothScatter(x = test2$distance, y = test2$max_speed)

test = dat[which(dat$country == ""),]
# World Distribution of all events: From Junli's code

library("maps")

# NOTE: These are only data with recorded coordinates,
# so it may not be entirely representative

# 13196/399758 locations unlisted
pdf(file="run_loc.pdf",width=12)
map(xlim=range(dat.run$longitude,na.rm=T),
    ylim=range(dat.run$latitude,na.rm=T), col="wheat", fill=T)
points(dat.run$longitude,dat.run$latitude, col="red", pch=21, cex=0.5)
title("Running Data Locations")
dev.off()

# 15754/134050 locations unlisted
pdf(file="ride_loc.pdf",width=12)
map(xlim=range(dat.ride$longitude,na.rm=T),
    ylim=range(dat.ride$latitude,na.rm=T), col="wheat", fill=T)
points(dat.ride$longitude,dat.ride$latitude, col="red", pch=21, cex=0.5)
title("Cycling Data Locations")
dev.off()

# 9395/15060 locations unlisted
pdf(file="swim_loc.pdf",width=12)
map(xlim=range(dat.swim$longitude,na.rm=T),
    ylim=range(dat.swim$latitude,na.rm=T), col="wheat", fill=T)
points(dat.swim$longitude,dat.swim$latitude, col="red", pch=21, cex=0.5)
title("Swimming Data Locations")
dev.off()


# ***