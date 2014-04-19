## libraries
library(jsonlite)
library(parallel)
library(chron)
library(maps)
# raw files
ff <- list.files(pattern=".json")
length(ff)
ff[1:10]

run.list <- mclapply(ff, fromJSON, mc.cores=4)
length(run.list)
names(run.list) <- sub(".json","",ff)
str(run.list[[1]])

# change columns 6:12 from character to numeric
run.list2 <- lapply(run.list, function(x) {x[,6:12] <- apply(x[,6:12],2,as.numeric);return(x)})
# add average speed and date.time
run.list3 <- lapply(run.list2, transform, avg_speed=distance/moving_time, daytime=as.chron(start_date_local))

# filter the data
# only for run, distance < marathon (42.2 km), average speed < 12 m/s, moving time < 11 hours
run.list4 <- lapply(run.list3, subset, type=="Run" & distance<42200 & avg_speed<12 & moving_time/3600 < 11)
# filter duplicated entries (with the same time)
run.list5 <- lapply(run.list4, function(x) x[!duplicated(x$start_date_local),])

## statistics
# record days by person
nday3 <- sapply(run.list3,nrow)
nday5 <- sapply(run.list5,nrow)

max.speed5 <- sapply(run.list5,function(x) max(x$avg_speed,na.rm=T)) #m/s
max.distance5 <-  sapply(run.list5,function(x) max(x$distance/1000,na.rm=T)) # km
max.time5 <-  sapply(run.list5,function(x) max(x$moving_time/3600,na.rm=T)) #hours

pdf(file="Summary_of_running.pdf")
hist(nday5, main="",xlab="Days of Running by Person")
hist(nday3-nday5, main="Histogram of removed entry number")
hist(max.speed5)
hist(max.distance5)
hist(max.time5)
dev.off()

# concatenate all the data
run.all <- do.call("rbind",run.list5)
pdf(file="Running_Occurcence_with_Time.pdf")
hist(hours(run.all$daytime),main="Running Occurrence During the Day",xlab="Hour")
plot(months(run.all$daytime),main="Running Occurrence During the Year",xlab="Month")
plot(weekdays(run.all$daytime),main="Running Occurrence During the Weed",xlab="Week Days")
plot(years(run.all$daytime),main="Running Occurrence In the Past Years",xlab="Year")

# I found a problem: there are some very old data, older than 2005, might be not right
ys <- years(run.all$daytime)
plot(droplevels(ys[ys>2005]),main="Running Occurrence In the Past Years",xlab="Year")
dev.off()

## world distribution
pdf(file="World_distribution.pdf",width=12)
map(xlim=range(run.all$longitude,na.rm=T),ylim=range(run.all$latitude,na.rm=T),col="wheat",fill=T)
points(run.all$longitude,run.all$latitude,col="red",pch=21,cex=0.5)
title("World Distribution")
dev.off()
