# run_analysis.R: Getting and Cleaning Data 2014/09 Course Project
# ======================================================================

# Directory containing data files
dataDir <- "UCI HAR Dataset"

# Full name of a data file
# This function prepends dataDir to its arguments, and then joins
# everything with a "/" character, thus giving us a quick way to access
# data files. The name of the function, df, is short for "data file".
df <- function(...) paste(dataDir, ..., sep="/")

# Read complete train or test set
# This function uses mapply to read in data from the subject, y, and X data
# files, which gives us a list, containing three data frames, with
# different numbers of columns, but with the same number of rows. The list
# is then converted to a data.frame using as.data.frame, which amounts to
# column-binding the list elements. The resulting data.frame has the
# following columns: subject, activity, feature1, ..., feature561 (but
# these column names are for convenience only, they are not the descriptive
# column names that the assignment asks for, which are set later). The call
# to read.table uses colClasses for increased speed. The argument set has
# to be one of "train" or "test".
readSet <- function(set) {
    files <- paste(c("subject", "y", "X"), "_", set, ".txt", sep="")
    classes <- c("integer", "integer", "numeric")
    readFile <- function(f, c) read.table(df(set, f), colClasses=c)
    result <- as.data.frame(mapply(readFile, files, classes))
    colnames(result) <- c("subject", "activity", paste0("feature", seq_len(ncol(result) - 2)))
    return(result)
}

# The processing starts here

# Features
# First we read feature names from the file features.txt. We then search
# for features we want to keep (those with -mean() or -std() in their
# name). Finally, we create descriptive column names by first
# removing (), then by translating the characters (,- to an underscore _,
# and finally by removing ). For example, tGravityAcc-arCoeff()-X,1 will
# become tGravityAcc_arCoeff_X_1, and angle(X,gravityMean) will become
# angle_X_gravityMean. 
features <- read.table(df("features.txt"), as.is=TRUE)[, 2]
keep <- grep("-(mean|std)\\(\\)", features)
colNames <- gsub("\\)", "", gsub("[(,-]", "_", gsub("\\(\\)", "", features)))

# Read train and test sets
# Here we read in the train and test sets, immediately row-binding them,
# and keeping only the columns that we need, ie subject, activity, means
# and standard deviations. We also take care of column names by renaming
# all columns except the first two using the names generated above. The
# name din is short "data input". This completes steps 1, 2 and 4 of the
# assignment.
din <- rbind(readSet("train"), readSet("test"))[, c(1, 2, keep + 2)] # 10299 x 68
colnames(din)[-c(1, 2)] <- colNames[keep]

# Activity labels
# First we read activity labels from the file activity_labels.txt, then we
# convert din$activity to a factor, using the labels we have. This
# completes step 3.
activityLabels <- read.table(df("activity_labels.txt"), as.is=TRUE)[, 2]
din$activity <- factor(din$activity, levels=1:6, labels=activityLabels)

# Aggregated data set
# Finally, we aggregate the data by computing the mean for each combination
# of subject and activity. The resulting data frame dout (which stands for
# "data output") is saved to the file aggregated.txt in the current
# directory. The file contains nice column names, and activities are saved
# as WALKING, WALKING_UPSTAIRS, ... and so on. The file can be read in
# using
#
# read.table("aggregated.txt", header=TRUE)
# 
# This completes step 5 of the assignment.
dout <- aggregate(din[, -c(1, 2)], by=list(subject=din$subject, activity=din$activity), mean) # 180 x 68
write.table(dout, "aggregated.txt", quote=FALSE, row.names=FALSE)

# EOF
