STA 298 - Class 140422

# FUTURE
    # Profs will meet with each group individually
    # Work out what questions your group is going to ask
    # Key features & decisions (what you cut, etc.)

# CATS & DOGS
    # Using overfeat to create weighted features like "Labrador"
    # Standardizing image sizes and using PCA


# FUTURE CHALLENGE FOR STRAVA
    # Given test data, predict actual race times based on current data
# Feature engineering/extraction/selection
    # Given Strava runs, etc., don't use in raw form, construct
    # relevant features and choose which are meaningful
    # Response = Race time
    # Features = "Is it a Race?", 
    # You shouldn't get rid of non-race data just because a person
    # doesn't do any races--this information is still important
    # Athlete-specific features? Spreads, etc.?

    # Would we be able to train a simulator on existing data in order
    # to predict future data sets without times listed?

    
# GENERAL PROBLEMS
    # COVARIATES/FEATURES                       # RESPONSE
    # ???                                       # Cat/Dog
                                                # Race times
                                                # Dropout rate from STEM
                                                # Major change

# METHODS (Supervised Learning)
    # Linear/logistic regression / GLM
    # SVM
    # Trees
    # Random Forests
    # K-nearest Neighbors
    # HMM
    # Neural Networks
    # LDA/QDA
    # Boosting/Bagging
    # Naive Bayes
    # Time Series (model future predictions, spatial/temporal data)

# REMINDER
# Boosting: Keep making new models by weighting non-fitting values
# until you have many possible models and let them "vote"

# Take a sample from your population, then take a sample from THAT,
# with replacement, MANY times, and get a value for 1/median(x_i) for
# each group and gather the results as a variable distribution.

# MISC.