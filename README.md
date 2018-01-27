This file explains how the "run_analysis.R" script works to obtain and tidy the UCI HAR dataset. The data was collected from the accelerometers of the Samsung Galaxy S smartphone. A full description is available at:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The source data is zipped and can be found at this location:
"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

The script first loads the required libraries
plyr
dplyr
readr
reshape2

STEP 1

Merge the training and the test sets to create one data set. First download the data files for the training and test data. Then read these data sets into two separate data frames. Next, merge these data frames by binding the rows together.

Read the column names from "features.txt". Then set the column names for the merged data frame (X_data).

STEP 2

Extract only mean and standard deviation for each measurement. Do this by selecting only columns that contain ".mean." or ".std." in the column name, and binding these two column selections. This data is stored in X_data_meanstd.

STEP 3

Use descriptive activity names to name the activities in the data set. First read in the activity indices from "y_train.txt" and "y_test.txt" and merge them together by binding the rows. Then read in the more descriptive labels from "activity_labels.txt" and replace the indices with the descriptive labels. Finally, add the activity labels to the data set and store the result in labelled_data.

STEP 4

Label the data set with descriptive variable names. First, tidy the column names by removing unneccessary text and replacing "." with "_". Then read the subjects for the data and merge them by binding the columns. Store the result in final_data. Finally, label the "subject" and "activity" columns.

STEP 5

Create a second, independent tidy data set with the average of each variable for each activity and each subject. First put each observation in a separate row using the melt() function. Calculate the average of each variable for each activity and each subject using the dcast() function. Finally, write the data to a CSV file called "Course3ProjectSummary.txt".
