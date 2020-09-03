setwd("~/Desktop/Coursera/Data_Science")

# 1. Merges the training and the test sets to create one data set.

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("id","features"))

X_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = t(features[2]))
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
merge_train <- cbind(X_train, y_train, subject_train)

X_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = t(features[2]))
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
merge_test <- cbind(X_test, y_test, subject_test)

all_data <- rbind(merge_train, merge_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

cols_measurement <- grep(".*mean.*|.*std.*", names(all_data), ignore.case=TRUE)
measurement_data <- all_data[,cols_measurement]
measurement_data$activity <- all_data$activity
measurement_data$subject <- all_data$subject

# 3. Uses descriptive activity names to name the activities in the data set

activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("id", "activity"))
measurement_data$activity <- as.character(measurement_data$activity)
for (i in activities[,1]) {
  measurement_data$activity[measurement_data$activity == i] <- as.character(activities[i,2])
}

# 4. Appropriately labels the data set with descriptive variable names.

names(measurement_data)<-gsub("^t", "Time", names(measurement_data))
names(measurement_data)<-gsub("^f", "Frequency", names(measurement_data))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(plyr)
measurement_data$subject <- as.factor(measurement_data$subject)
measurement_data$activity <- as.factor(measurement_data$activity)
tiny_data <- aggregate(. ~subject+activity, measurement_data, mean)
write.table(tiny_data, file = "tidy_data.txt", row.name=FALSE)


