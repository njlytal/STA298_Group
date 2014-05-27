# STA 298 - Class 140527

# GENERAL INFO

# FIVE MINUTE PRESENTATION!
# 9 groups, goal is to finish with everyone
# Quick reminder of background info?
# What did you do?
# What did you find?
# What were some complications and what would you do differently?

# FOR GRADE: Write a short report, maybe a little extra explanation.
# Only a max of 7 pages text (can do fewer), plus plots
# REPORT IS DUE FINALS WEEK.


# STRAVA GUIDELINES
# See: http://eeyore.ucdavis.edu/ExplorationsInDataScience/Spring14/strava_prediction

# Given 1001 new athletes to analyze (total 2001 with existing ones)
# Each has at least ONE race
# You can use all non-races
# You can't use ANY of the new data ahead of the time of the race you're predicting
# HOWEVER, you can always use the entirety of the training set (first 1000 athletes)
# when predicting your race times.

# You can opt out of a very inaccurate race, but MUST predict at least 99% of the data


# MODELING TIPS

# Residuals: Explains lack of fit
# Cross-Validation: Reduce overfitting
# Understand the predictive nature of your model: smoothness
# variable importances, uncertainty

# We can analyze the heteroscedasticity of a model:
# With a cone-shaped residual plot, we see there are unequal
# variances of residuals/errors
# Note the hard cut for the lower residuals: the response is positive,
# but the model produces negative times--impossible!

# How can we improve this?
# Could instead take a transformation, like log(time) ~ distance
# (This is improved, but still a linear model)
# Could add more terms...but it's still a linear model
# Linear models are not good, because they can give negative times
# Best of all: take a non-linear model, of which MANY exist

# NON-LINEAR MODELS - Note: DON'T just use default settings! Experiment!
# Splines
# Generalized Additive Models - fits a smooth function, use gam() in R
# Random Forests - default setting is likely to seriously overfit, but
# could make it smoother by changing nodesize to something better
# SVM - tends to be iffy around the tails, but good otherwise,
# and could be even better with a different kernel
# Neural Networks
# See STA298_Class_140422 for more

# Don't forget to use cross-validation, otherwise you may overfit!
# Look at SPECIFIC RESIDUALS that are extreme to determine why this
# is such an exception (severe elevation? bad weather?)