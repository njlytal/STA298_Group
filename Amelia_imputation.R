#Script for imputing missing data in the cleaned dataset using the Amelia II package

#Some notes from the Amelia manual:
#The imputation model in Amelia II assumes that the complete data (that is, both 
#observed and unobserved) are multivariate normal

#we need to make the usual assumption in multiple
#imputation that the data are missing at random (MAR).

require(Amelia)

#put the dates into date format for R
dat.run$start_date_local <- as.Date(dat.run$start_date_local,format="%Y-%m-%d %H:%M:%S")

#Run amelia. Note this is running with 5 threads, you may need to change this.
am.test2 <- amelia(dat.run,
                   m=5,
                   ts="start_date_local", 
                   cs="id", 
                   parallel = "multicore", 
                   ncpus=5, 
                   idvars=c("X",
                            "name",
                            "description",
                            "type", 
                            "workout_type",
                            "has_streams",
                            "activity",
                            "firstname",
                            "city",
                            "state",
                            "country",
                            "sex",
                            "premium",
                            "created_at",
                            "updated_at",
                            "date_preference",
                            "measurement_preference"))


