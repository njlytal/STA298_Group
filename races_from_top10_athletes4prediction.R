# Junli Zhang
# races_from_top10_athletes4prediction.R
# Prepare some race data for prediction
# I selected 10 athletes with the most races

dat.run <- read.csv("run_data.csv",row.names=1) # read run data
run.race <- subset(dat.run, workout_type=="1")  # race data
n.race <- by(run.race, run.race$id, nrow)       # number of races for each person
sort(n.race,decreasing=T)[1:10]                 # top 10 athletes
# run.race$id
# 205  11 871 252 266 387  77 311 381 408 
#  33  32  27  24  24  24  22  22  21  19 

race.top10 <- subset(dat.run, id %in% c(205, 11, 871, 252, 266, 387, 77, 311, 381, 408) & workout_type=="1")
nrow(race.top10)
save(race.top10, file="races_from_top10_athletes4prediction.Rdata")
