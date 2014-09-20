Getting and Cleaning Data 2014/09 Course Project
======================================================================

This repository contains the files necessary for the completion of the
course project in the Coursera course 
[Getting and Cleaning Data](https://class.coursera.org/getdata-007), 
started in September 2014.

The project goal is essentially to read in data from the 
[Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones),
join the train and test data sets, and write out an aggregation of selected
columns per participant and activity. See the course page for a detailed
description of the assignment.

This repository contains the following files:

 - `run_analysis.R` - R script that completes the assignment
 - `aggregated.txt` - the resulting, tidy aggregated data set
 - `CodeBook.md` - the code book describing the data
 - `README.md` - this file

To regenerate the resulting data file, just source the `run_analysis.R`
script in R:

    source("run_analysis.R")

The script assumes that the smartphones data set has been unzipped in the
working directory, which must therefore contain a subdirectory named 
`UCI HAR Dataset`, with all data files inside this subdirectory.

The script `run_analysis.R` is amply commented. Please, read the comments to
find out what the script does. Also, have a look at the code book for more
information on the input and output data files.

The script has been written and tested on a Linux machine running R version
3.1.1, but should work on other systems too.

