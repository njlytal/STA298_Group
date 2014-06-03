#Script for imputing missing data in the cleaned dataset using the Amelia II package

#Some notes from the Amelia manual:
#The imputation model in Amelia II assumes that the complete data (that is, both 
#observed and unobserved) are multivariate normal

#we need to make the usual assumption in multiple
#imputation that the data are missing at random (MAR).

require(Amelia)
dat.run.test <- read.csv(file="test_run_data_clean.csv", header=T)
#put the dates into date format for R
dat.run.test$start_date_local <- as.Date(dat.run.test$start_date_local,origin="1970-01-01")

#Run amelia. Note this is running with 5 threads, you may need to change this.
am.test2 <- amelia(dat.run.test,
                   m=5,
                   ts="start_date_local", 
                   cs="id", 
                   parallel = "multicore", 
                   ncpus=5, 
                   idvars=c("X","X.1","raceID","HR"))

save(am.test2, file = "amelia5-2.RData")
write.amelia(obj=am.test2, file.stem = "am5-2imp", format = "csv")
