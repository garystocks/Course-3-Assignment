## Course 3 (Getting and Cleaning Data) Project
## This script downloads the UCI HAR data set, imports it into R and tidies the data

## Load packages
library(plyr)
library(dplyr)
library(readr)
library(reshape2)


## STEP 1: Merge the training and the test sets to create one data set

## Download data file
setwd("D:/Users/Gary.stocks/Desktop/Coursera/Course 3 Project")
if (!file.exists("data")) {
 dir.create("data")
 setwd("D:/Users/Gary.stocks/Desktop/Coursera/Course 3 Project/data")
 fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
 download.file(fileURL, destfile = "dataset.zip")
}
setwd("D:/Users/Gary.stocks/Desktop/Coursera/Course 3 Project/data")

## Read the training and test data sets
initial <- read.table(unz("dataset.zip", "UCI HAR Dataset/train/X_train.txt"), nrows = 100)
classes <- sapply(initial, class)
X_train <- read.table(unz("dataset.zip", "UCI HAR Dataset/train/X_train.txt"), colClasses = classes)

initial <- read.table(unz("dataset.zip", "UCI HAR Dataset/test/X_test.txt"), nrows = 100)
classes <- sapply(initial, class)
X_test <- read.table(unz("dataset.zip", "UCI HAR Dataset/test/X_test.txt"), colClasses = classes)

## Merge the training and test data sets
X_data <- rbind(X_train, X_test)

## Read the column names for the data
con <- unz("dataset.zip", "UCI HAR Dataset/features.txt")
col_names <- readLines(con)
close(con)

# Set the column names
colnames(X_data) <- make.names(col_names)


## STEP 2: Extract only mean and standard deviation for each measurement
X_data_mean <- select(X_data, contains(".mean."))
X_data_std <- select(X_data, contains(".std."))
X_data_meanstd <- cbind(X_data_mean, X_data_std)


## STEP 3: Use descriptive activity names to name the activities in the data set

## First read in the activity labels and merge them
activity_index_train <- read.table(unz("dataset.zip", "UCI HAR Dataset/train/y_train.txt"))
activity_index_test <- read.table(unz("dataset.zip", "UCI HAR Dataset/test/y_test.txt"))
activity_index <- rbind(activity_index_train, activity_index_test)

## Read the more descriptive activity labels
con <- unz("dataset.zip", "UCI HAR Dataset/activity_labels.txt")
activity_labels <- readLines(con)
close(con)

## Then replace the index with the more descriptive activity_labels
tidy_activity_labels <- sapply(activity_index, function(x) activity_labels[x])
char <- nchar(tidy_activity_labels)
tidy_activity_labels <- substr(tidy_activity_labels, 3, char)

## Add the activity labels to the data set
labelled_data <- cbind(tidy_activity_labels, X_data_meanstd)


## STEP 4: Label the data set with descriptive variable names

## Tidy the column names
names <- names(labelled_data)
str <- "[^x]([0-9]*)[\\.]"
names <- sub(str, "", names)

str <- "[(\\.*)]"
names <- gsub(str, "_", names)

colnames(labelled_data) <- names

## Read the subjects for the data and merge them
train_subjects <- read.table(unz("dataset.zip", "UCI HAR Dataset/train/subject_train.txt"))
test_subjects <- read.table(unz("dataset.zip", "UCI HAR Dataset/test/subject_test.txt"))
subjects <- rbind(train_subjects, test_subjects)

## Create the final data set with subject index
final_data <- cbind(subjects, labelled_data)

## Set the column names
colnames(final_data)[1] <- "subject"
colnames(final_data)[2] <- "activity"


## STEP 5: Creates a second, independent tidy data set with the average of each variable 
## for each activity and each subject

## First put each observation in a separate row
indices <- grep("subject|activity", names(final_data), invert = TRUE)
final_data_melt <- melt(final_data, id = c("subject", "activity"), measure.vars = names(final_data[, indices]))

## Calculate the average of each variable for each activity and each subject
tidy_data <- dcast(final_data_melt, subject + activity ~ variable, mean)

## Write the data to a CSV file
write.table(tidy_data, file = "Course3ProjectSummary.txt", row.names = FALSE)
