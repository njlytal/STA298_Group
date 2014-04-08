STA 298 - Class 140408

# GENERAL NOTES
    # Be prepared to give a status update each week!
    # Cut the group down to about 6 people!

    # Start univariate for data until you peg down
    # more specific relations
    # Find some RACE PREDICTIONS!


# STRAVA ("STRAW-VUH") DATA UPDATES/FINDINGS

# It appears that the heart rates are almost normally distributed
# Of course, there is a spike at lower values for resting heart rate...
# NOTE: That plot was for ALL activities: should break these up!
# There are probably errors: that many people over 240 bpm max?
# Apparently the max value is 10 billion bpm....yep.
# TEN BILLION BEATS PER MINUTE

# Max and Avg Speed are somewhat normally distributed,
# but max is right skewed, as would be expected

# Perhaps those who have more entries are more fitness inclined
# and have higher performance

# Note: average speed as distance/moving time may not be
# ideal unless you realize we're changing the question

# Plotting speed against distance for the running data results
# in noticeable vertical "bands" that correspond to common race
# distances (5K, 10K, half-marathon, marathon, etc.)
# This is due to more variance among racers at commonly run
# distances.
# There's also a clear cone of speeds that narrows as fewer
# slow or fast runners make it longer distances.

# Many running data points reside in world record range!
# Maybe some of them are actually cycling data?

# How do we deal with these outliers? Do we remove them?

# Can we do a mixture model (cone portion and "too high" portion)?
# Several separate Normal distrib. within the overall data
# "Roll a die" to determine which distribution you sample
# a data point from.
# Question: HOW MANY POPULATIONS DO WE HAVE?
# In this case, presumably 2: REAL and FAKE.

# Think: do we want to use the median/trimmed mean to get rid
# of contamination from outliers?

# This data is HIGHLY STRUCTURED, but there are definitely errors.
# There are MANY DUPLICATE activities!
# Some data have entry errors (0012 instead of 2012)
# One person has 66275 duplicate runs...and several others
# have hundreds of duplicates.

# We do NOT have gender or age, which could be useful attributes.

# Next up: We'll get more detailed accounts for a few individuals
# Extra data includes calories burned, split data (among miles)
# fastest "X distance" run, etc.

# Note: This will get VERY LARGE (several GB)


# CATS & DOGS

# Neural networks completely dominate the Kaggle leaderboards (OverFeat)
# These use massive training data from outside sources to improve
# prediction of cats & dogs by pulling out important features
# Eyes, for instance, are quite different between the two, as
# are muzzle shape and tail length (insofar as these are visible)
# Other methods exist (random forests, etc.) but these are inferior,
# especially taken on their own without combination

# 