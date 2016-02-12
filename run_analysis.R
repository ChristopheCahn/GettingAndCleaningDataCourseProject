## Assume you are in the 'GettingAndCleaningDataCourseProject/' directory
library(dplyr)

## Downloading the file
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "data.zip")

## We collect train and test sets
train.raw <- read.table(unz("data.zip", "UCI HAR Dataset/train/X_train.txt"), header=F)
train.lbl <- read.table(unz("data.zip", "UCI HAR Dataset/train/y_train.txt"), header=F)
train.sub <- read.table(unz("data.zip", "UCI HAR Dataset/train/subject_train.txt"), header=F)

test.raw <- read.table(unz("data.zip", "UCI HAR Dataset/test/X_test.txt"), header=F)
test.lbl <- read.table(unz("data.zip", "UCI HAR Dataset/test/y_test.txt"), header=F)
test.sub <- read.table(unz("data.zip", "UCI HAR Dataset/test/subject_test.txt"), header=F)

## Now, we can append both train and test sets
# Measures
data.raw <- rbind(train.raw, test.raw)
# labels
data.lbl <- rbind(train.lbl, test.lbl)
# Subjects
data.sub <- rbind(train.sub, test.sub)
                  
## We can collect the descriptive labels for features and activities
features <- read.table(unz("data.zip", "UCI HAR Dataset/features.txt"), header=F)
activity <- read.table(unz("data.zip", "UCI HAR Dataset/activity_labels.txt"), header=F)

## And now, bind all data
data <- cbind(data.sub,data.lbl, data.raw)
names(data) <- c("subject","activities",as.character(features[,2]))

## Extracts only the measurements on the mean and standard deviation for each 
# measurement (without forgetting the two first columns).
data <- data[,c(1:2,grep("(mean|std)\\(\\)", names(data)))]

## Finally, we put the descriptive labels for activities
data[,2] <- activity[data[,2],2]

## Now, compute average by activities
by.activity.and.subject <- group_by(data, activities, subject)
meanData <- summarise_each(by.activity.and.subject,funs(mean))

