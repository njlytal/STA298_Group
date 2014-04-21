#Tyson Howell
#Code for comparing moving time and elapsed time between race and non race types
#input is all_data.csv output of create_data_mod.R

require(ggplot2)
setwd("location/of/csvfile")

#Read in all Strava data
alldata <- read.table(file="all_data.csv",sep=",",header=T)
alldata$workout_type <- as.factor(alldata$workout_type)
#Subset run data only, remove data for runs >25 hours, and runs where moving time > elapsed time
rundata <- alldata[which(alldata$type=="Run" & alldata$elapsed_time < 90000 & alldata$moving_time<=alldata$elapsed_time),]

#subset races for run data
runrace <- rundata[which(rundata$workout_type=="1" & rundata$elapsed_time < 90000 & rundata$moving_time<=rundata$elapsed_time),]

#subset non races for run data
runtrain <- rundata[which(rundata$workout_type!="1" & rundata$elapsed_time < 90000),]

#create variable containing the difference between moving and elapsed time for races and training runs
racediff <- runrace$elapsed_time - runrace$moving_time
traindiff <- runtrain$elapsed_time - runtrain$moving_time

#plot elapsed time vs moving time
qplot(runrace$moving_time,runrace$elapsed_time,main="Races runs",xlab="Moving time",ylab="Elapsed time")
qplot(runtrain$moving_time,runtrain$elapsed_time,main="Training runs",xlab="Moving time",ylab="Elapsed time")

#histogram of difference between elapsed and moving times, first bin removed to adjust scale
qplot(racediff,gemom="histogram",ylim=c(0,100),xlab="Elapsed time-moving time",main="Race runs")
qplot(traindiff,gemom="histogram",ylim=c(0,1200),xlab="Elapsed time-moving time",main="Training runs")