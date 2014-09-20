Code book
======================================================================

Raw data (input)
------------------------------

The raw data for this project has been taken from the
[Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones),
which is hosted at the 
[UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/index.html).
The actual data is contained in a ZIP archive, which can be found
[here](http://archive.ics.uci.edu/ml/machine-learning-databases/00240/).

The files in the ZIP archive that are important for this project are the
following:

 - `README.txt` - a description of the smartphone data
 - `activity_labels.txt` - a mapping between activity IDs and their labels
 - `features.txt` - a list of all 561 features (note that some feature
   names are not unique, but these are not important for the project)
 - `features_info.txt` - a description of how features were generated 
 - The train data set:
    - `train/subject_train.txt` - subject IDs with values 1-30
    - `train/X_train.txt` - the values of the 561 features, normalized and
      bounded within the interval [-1, 1]
    - `train/y_train.txt` - activity IDs with values 1-6
 - The test data set (files are named in the same way as in the train data set):
    - `test/subject_test.txt`
    - `test/X_test.txt`
    - `test/y_test.txt`

A single record from the train or test data set consists of the same row
from the `subject`, `y`, and `X` files, ie the complete train or test data
set can be obtained by column-binding these files together.

Note that a 
[feature](http://en.wikipedia.org/wiki/Feature_%28machine_learning%29) 
in machine learning corresponds to an explanatory variable or a 
[covariate](http://en.wikipedia.org/wiki/Covariate)
in the usual statistical terminology.


Study design
------------------------------

The study design is documented in the `README.txt` file. Only a brief
summary is given here. For more information, please refer to the original
documentation. 

The study consisted of 30 volunteers, aged between 19 and 48 years. Each
subject performed six activities -- walking, walking upstairs, walking
downstairs, sitting, standing, and laying. The activities were performed
wearing a smartphone (Samsung Galaxy S II) on the waist, and data from the
accelerometer and gyroscope of the smartphone were recorded. These data
were the source of the 561 features mentioned above. 

The obtained data was randomly split into a train (21 or 70% subjects), and
a test (9 or 30% subjects) data set. Presumably, the intent of the original
project was to construct a classification algorithm that would recognize
the performed activity based on readings from the smartphone sensors. The 
[train data set](http://en.wikipedia.org/wiki/Training_set)
is used to tune the algorithm, while the 
[test data set](http://en.wikipedia.org/wiki/Test_set)
is used to check the performance of the so tuned algorithm.


Tidy data (output)
------------------------------

The output data file `aggregated.txt` has been produced by

 - joining (ie row-binding) the train and test data sets,
 - selecting only columns of means and standard deviations, besides subject
   and activity IDs (see below),
 - naming columns using names derived from the list of features (see below),
 - transforming acitivty ID into a factor, with appropriate labels,
 - averaging all numeric columns over subject and activity.

The output data file contains column names and can be read into R with
the following command:

    read.table("aggregated.txt", header=TRUE)

The resulting data frame has 180 rows and 68 columns. The columns are:

 - `subject` - subject ID with values 1-30
 - `activity` - factor with values 
   `WALKING`, `WALKING_UPSTAIRS`, `WALKING_DOWNSTAIRS`, `SITTING`, `STANDING`, `LAYING`
 - A total of 66 averaged numeric dimensionless (ie no units) features
   whose names can be obtained by appending `_mean` or `_std` followed by
   `_X`, `_Y` or `_Z` (only for identifiers marked with an asterisk) to the
   following identifiers:
    - `tBodyAcc*`
    - `tBodyAccJerk*`
    - `tBodyAccJerkMag`
    - `tBodyAccMag`
    - `tBodyGyro*`
    - `tBodyGyroJerk*`
    - `tBodyGyroJerkMag`
    - `tBodyGyroMag`
    - `tGravityAcc*`
    - `tGravityAccMag`
    - `fBodyAcc*`
    - `fBodyAccJerk*`
    - `fBodyAccMag`
    - `fBodyBodyAccJerkMag`
    - `fBodyBodyGyroJerkMag`
    - `fBodyBodyGyroMag`
    - `fBodyGyro*`

For a more detailed description of the features, please see the original
documentation.

The assignment somewhat vaguely says to "extract only the measurements on
the mean and standard deviation for each measurement". I think
that this means to extract features which are means and standard deviation
of measured signals. Therefore, only features with the sequence `-mean()` or
`-std()` in their name were selected. The code in `run_analysis.R` could
be easily modified to extract additional columns.

Original feature names were transformed to column names with the following
operations (performed in this order):

 - remove the string `()`,
 - replace all remaining left-parentheses `(`, commas `,` and dashes `-`
   with an undersore `_`,
 - remove all remaining right-parentheses `)`.

A few examples:

    ---------------------------------------------------
    Feature name                Column name
    ---------------------------------------------------
    tBodyAcc-mean()-X           tBodyAcc_mean_X
    tBodyAcc-std()-X            tBodyAcc_std_X
    tGravityAcc-arCoeff()-Z,4   tGravityAcc_arCoeff_Z_4
    angle(X,gravityMean)        angle_X_gravityMean
    ---------------------------------------------------

Of course, not all so generated column names were used in the output data
file, which contains only means and standard deviations.

For more details on the processing, please refer to the `run_analysis.R`
script, which is amply commented.

