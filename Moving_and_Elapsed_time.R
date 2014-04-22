#Tyson Howell
#Code for comparing moving time and elapsed time between race and non race types
#input is all_data.csv output of create_data_mod.R

require(ggplot2)
require(gridExtra)
setwd("location/of/csvfile")

#Read in all Strava data
alldata <- read.table(file="all_data.csv",sep=",",header=T)
alldata$workout_type <- as.factor(alldata$workout_type)
#Subset run data only, remove data for runs >25 hours, and runs where moving time > elapsed time
rundata <- alldata[which(alldata$type=="Run" & alldata$elapsed_time < 90000 & alldata$moving_time<=alldata$elapsed_time),]

#subset races for run data
runrace <- rundata[which(rundata$workout_type=="1"),]

#subset non races for run data
runtrain <- rundata[which(rundata$workout_type!="1"),]

#create variable containing the difference between moving and elapsed time for races and training runs
racediff <- runrace$elapsed_time - runrace$moving_time
traindiff <- runtrain$elapsed_time - runtrain$moving_time

#plot elapsed time vs moving time
qplot(runrace$moving_time,runrace$elapsed_time,main="Races runs",xlab="Moving time",ylab="Elapsed time",xlim=c(0,89880),ylim=c(0,90000))
qplot(runtrain$moving_time,runtrain$elapsed_time,main="Training runs (all)",xlab="Moving time",ylab="Elapsed time",xlim=c(0,89880),ylim=c(0,90000))

p1 <- qplot(rundata[which(is.na(rundata$workout_type)),]$moving_time,rundata[which(is.na(rundata$workout_type)),]$elapsed_time,main="Training runs (NA)",xlab="Moving time",ylab="Elapsed time",xlim=c(0,89880),ylim=c(0,90000))
p2 <- qplot(runtrain[which(runtrain$workout_type=="0"),]$moving_time,runtrain[which(runtrain$workout_type=="0"),]$elapsed_time,main="Training runs (Default)",xlab="Moving time",ylab="Elapsed time",xlim=c(0,89880),ylim=c(0,90000))
p3 <- qplot(runtrain[which(runtrain$workout_type=="2"),]$moving_time,runtrain[which(runtrain$workout_type=="2"),]$elapsed_time,main="Training runs (Long run)",xlab="Moving time",ylab="Elapsed time",xlim=c(0,89880),ylim=c(0,90000))
p4 <- qplot(runtrain[which(runtrain$workout_type=="3"),]$moving_time,runtrain[which(runtrain$workout_type=="3"),]$elapsed_time,main="Training runs (Intervals)",xlab="Moving time",ylab="Elapsed time",xlim=c(0,89880),ylim=c(0,90000))
grid.arrange(p1,p2,p3,p4,ncol=2)

#histogram of difference between elapsed and moving times, first bin removed to adjust scale
qplot(racediff,gemom="histogram",ylim=c(0,100),xlab="Elapsed time-moving time",main="Race runs")
qplot(traindiff,gemom="histogram",ylim=c(0,1200),xlab="Elapsed time-moving time",main="Training runs")