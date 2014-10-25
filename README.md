---
title: "README.md"
author: "Herpich"
date: "October 24, 2014"
output: html_document
---

The run_analysis.R script is designed to merge the training and test datasets from the Samsung Galaxy S human activity recognition dataset sourced from UCI at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.  Running the run_analysis.R script assumes that the user has downloaded and extracted the dataset to the local directory keeping the folder structure intact.  Only the training and test .txt data files along with the features .txt data files are used for this analysis.

The first step in the code is to load the training data from the X_train.txt file along with the corresponding Activity (6 total numbered 1:6; see activity_labels.txt file for detail) from the Y_train.txt and the subject performing the Activity (30 total) from the subject_train.txt file.  The code then performs the same sourcing activities on the test data.  The test data and training data are then merged into one data frame called merged_data.  Finally, the actual measurements from each Activity as represented in the features.txt file (561 total) are loaded and added to the names vector.  The merged_data frame is then appended for the representative subject and Activity vectors corresponding to each observation.

Once the merged_data frame has been assembled, the mean() and standard deviation() measruements are extracted into the extracted_data frame.  This data frame is then cleaned.  The Activity variable is labeled by string to represent the actual activity.  Additionally, the measurement variables are cleaned to remove extraneous characters, to expand some abbreviations, and to remove duplicate words.

The cleaned merged_data frame is then simplified through the reshape2 package (needs to be initialized) such that the resulting tidy_data frame presents the mean of each extracted variable organized by subject and Activity.  The output is then exported to a .txt file.  The resulting data frame is considered tidy given that each variable is one column, each row is one observation, the data frame shows only one type of output (mean of mean() and std dev() of measurements), and the names are descriptive.

