# STA 298 Class - 140429

# NOTE: Next week we meet with the profs as groups!
# GET SOME PLANS UNDERWAY!
# Sort out potential methods.

# NOTE: We don't want to just blindly apply methods without
# understanding. Make sure you know what each one is doing
# practically, and whether they are worth pursuing.


# POTENTIAL APPROACH
# Determine which variables are redundant/collinear
# Remove them, apply variable selection to a 


# STRAVA

# LET'S BE HONEST: What variables really matter?
# Useful: avg_speed, max_speed, distance, workout_type, sex
# Maybe?: latitude, longitude, premium, friend_count

# Is Multiple Factor Analysis an option?

# *** PCA ***
# Mix of categorical and numerical
# Don't bother using it on categorical-- it will be arbitrary assignment
# Could just use it on the numerical variables
# NOTE: You probably don't even want to use PCA in this case

# If you want to do a model selection approach, don't need it
# maybe consider linear or exponential models?

# Don't feel like you NEED to use a method like PCA to get a
# good model. Sometimes it's just overkill or uninformative.

# PCA converts data of, say, 1000 columns into 1000 principal
# components. They are ordered by importance, so we can focus
# on first few and discard the rest. THIS DOES NOT GET RID OF
# ANY VARIABLES! Still have combos of 1000 variables, but some
# downplay the importance of certain variables.

# NOTE: PCA is LINEAR dimension reduction, so beware.
# You COULD use PCA in a non-linear fashion by taking
# the variables to be V1^2, V2^3, V1V2, etc., but this
# can make things much worse if overdone.

# PCA can't predict something not used in the data.
# i.e. Can't predict Cat/Dog if the variable isn't used in PCA.

# BIG DOWNSIDE: You MUST have data for all variables to use
# PCA, since the PCs are dependent on every variable!
# However, PCA CAN be good at limiting multicollinearity, since
# the PCs are, by definition, UN-correlated & orthogonal.

# We will get the "percentage" importance of each PC based on
# the matrix itself of observations.

# NOW say you have some y separate from the data:
# lm(y ~ V1 + V2 + ... + V1000)
# From this model, do variable selection and get a FINAL MODEL,
# consisting of only some of these variables

# Consider minimizing this:
# sum(Y - beta*X_i)^2 + lambda*sum(abs(beta_p))
# For adaptive lasso, a high lambda indicates a high penalty
# Once lambda gets huge, you get rid of more and more variables
# as you become more strict

# Cross-Validation
# We aren't using data we created from training data to test
# predictions, just to use on test data.


# You could do a t-test or likelihood-ratio test at each step,
# but may need to correct the confidence interval each time too.
# 

# NOTE: City is not the best variable on its own, but it may
# lead to other useful ones (i.e. elevation).
# There may be various hotspots (Marin, Boulder) where elite
# runners tend to group.

# ---

# Other problems due to data structure: KNN
# Categorical data variables need DEFINED DISTANCES
# But consider the fact that numeric variables are already
# standardized to begin with.

# Some more with problems: 


# *** CATS & DOGS ***
# Want to MAXIMIZE the variance between the two groups.

# PCA won't do the trick since the groups are fairly similar
# in terms of colors, position in picture, etc.