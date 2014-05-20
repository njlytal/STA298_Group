# STA 298 Class 140520

# PRESENTATION DAY NOTES (Remember, TUES 6/3)
# Options: Oral presentation, poster, paper

# CATEGORICAL DATA
# Remember, if you have a variable of categories (as in the sleep data,
# not hungry to extremely hungry) represented as numbers,
# DON'T treat it as a continuous variable! The "distance"
# between any two groups is NOT the same as the distance
# between the actual numbers!

# Instead, turn them into factors. You can LABEL them 0, 1, 2, etc.,
# but they aren't ACTUALLY those numbers.
# Use binary terms to distinguish them.

# ALWAYS specify categorical variables!
# Often, inputted strings are converted to factors by default, so beware.

# *** EXAMPLE ***
# intercept     B   C   D       Group
#        1      0   0   0       A
#        1      0   1   0       C
#        1      0   0   1       D

# E[y(x*b)] =     b0    if x = A
#               b0+b1   if x = B
#               b0+b2   if x = C
#               b0+b3   if x = D

# Don't forget to examine options() and Rprofile


# STRAVA DATA

# Try using gbm
# Elevation gain: Why use a tree for this?

# TYPES OF MODELS
# Linear models (e.g. Elevation gain has a linear effect on race time)
# Fit a tree and you determine a split (elevation > x gives a different
# unique value than elevation < x, where x is the split value chosen)
# If you fit many trees, you would get lots of splits instead of a
# straight line

# Note that groups separated by trees have no relation to each other,
# whereas smoother plots imply a relation exists. Both have benefits.

# A discontinuous plot allows for extreme changes to exist that a
# smooth model would not allow as easily.

# Parametric v. Non-parametric
# Linear v. Not linear (poly, etc.)
# Continuous v. discontinuous (smoothness)
