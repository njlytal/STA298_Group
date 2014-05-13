# STA 298 - Class Notes 140513

# *** GENERAL INFO ***
# WEEK 10 - PRESENTATIONS on TUES 6/3

# Common Problems
#   - Handling missing data
#   - Working with nonlinear methods

# MISSING DATA...
# 1) MCAR: Completely at random (got lost in the mail)
# 2) MAR: At random (some cities lose mail more frequently--could 
# stratify to find correlation)
# 3) Not at random (Certain groups choose to exclude data on purpose)

# Y = y_ij
# M = M_ij

# When being missing has nothing to do with Y
# MCAR: P(M | y, phi) = P(M | phi) for all Y, phi 

# When missing status depends on observed data, but not missing data
# MAR:  P(M | y, phi) = P(M | Y_obs, phi) for all Y_obs, phi


# IN RESPONSE, WE CAN:
# Impute (base it off other variables that DO exist -- an educated guess)
# Multiple Imputation
# Remove the variable (If there are MANY NAs, it may not be a viable variable)


# NOTE: We probably want to do imputation because we need all the valuable
# variables we can get. Using heart rate, even a largely imputed version, is
# still worth pursuing
# NOTE: For columns missing LOTS of data (e.g. heart rate), we want to have
# a fairly robust imputation method, but for ones with very little missin data,
# we can take a naive approach with little penalty

# EXAMPLES w/Strava
#               PR.marathon train.speed # runs
# Bob Smith     10000 s     ...         ...
# Mo Farah      NA          ...         ...

# Naive way: Find average value for the column missing the value, and
# impute that as the value -- EASY, but NOT THAT EFFECTIVE

# Want to use OTHER info, like training times or # of runs (seen above)
# If someone has a 7000s training time, they probably will do better
# than 10000s for their PR.marathon time.

# Whenever you impute values, however, you INTRODUCE NEW NOISE
# into the data, which can make your estimates more inaccurate...but are
# they more inaccurate than if you had ignored that variable entirely?

# MULTIPLE IMPUTATION: Impute a variety of different values and try out
# estimates with each value:
# Assuming a normal distribution for the given data, Impute, say, X
# different potential values and randomly select among these X each time
# you replace an NA.
# Repeat this process many times to see the effects of variability
# included in your model.
# NOTE: Only about 3-10 imputations are needed if done well

# EXAMPLE
# Observed data yields N(5000, 2000)
# Select 3-10 values from this distribution
# Choose among these values randomly to replace each NA in the data

imputed.pool = rnorm(5, 5000, 2000)
newdata = sample(imputed.pool, number.of.NAs, replace = TRUE)
# Plug in the values of newdata in for the NA values (or do it 1 at a time)

# We can combine Multiple Imputation with a bootstrap approach to
# average out the results for multiple "replaced" data sets
# i.e. do this many times and take the averages of the replaced NA values

# Y = Xb + e
# b1*, Y1*
# b2*, Y2*
# ...
# bn*, Yn*

