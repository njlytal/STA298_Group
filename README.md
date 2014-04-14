STA298_Group
============

An exploration of data related to athletic performance.


***** FILE LIST *****

NAME                            DESCRIPTION

Class Notes                   - Contains some notes from in-class sessions.

Strava.R                      - Uses R to read in the Strava data. Also trims data to include only runs
                                without duplicates, and within certain distance and pace restrictions.
                                Also generates various histograms of the running data.

create_data.R                 - Alternative to Strava.R that reads in the data without trimming it. Also
                                includes columns for user ID and activity.
                                
create_data_mod.R             - Modified create_data.R code to do some additional cleaning and work with
                                the demographic data. Consider merging with create_data.R in the future.
                                Currently in progress.
                
stravaJsonData_timeofday.py   - Python code to parse Strava data and create a plot for time of day.
