gal_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 

# setwd("C:/Users/Virtual/Documents/Coursera/Course3")

gal_zip <- "dataset.zip"

if (!file.exists(gal_zip)) {
  download.file(gal_url, destfile = gal_zip)
}

features <- read.table(unz(gal_zip, "UCI HAR Dataset/features.txt"),
                       col.names=c("Feature.Index", "Feature.Name"))

activity_labels <- read.table(unz(gal_zip, "UCI HAR Dataset/activity_labels.txt"),
                              col.names=c("Activity.Index", "Activity.Label"))

subject_test <- read.table(unz(gal_zip, "UCI HAR Dataset/test/subject_test.txt"),
                           col.names="Subject.Index")
x_test <- read.table(unz(gal_zip, "UCI HAR Dataset/test/X_test.txt"),
                     col.names=features$Feature.Name)
y_test <- read.table(unz(gal_zip, "UCI HAR Dataset/test/y_test.txt"),
                     col.names="Activity.Index")

subject_train <- read.table(unz(gal_zip, "UCI HAR Dataset/train/subject_train.txt"),
                            col.names="Subject.Index")
x_train <- read.table(unz(gal_zip, "UCI HAR Dataset/train/X_train.txt"),
                      col.names=features$Feature.Name)
y_train <- read.table(unz(gal_zip, "UCI HAR Dataset/train/y_train.txt"),
                      col.names="Activity.Index")



subject <- rbind(subject_train, subject_test)
x_combined <- rbind(x_train,x_test)
y_combined <- rbind(y_train,y_test)

feature_is_mean <- grepl("-mean\\(\\)", features$Feature.Name)
feature_is_std <- grepl("-std\\(\\)", features$Feature.Name)

x_mean_std_only <- x_combined[,which(feature_is_mean | feature_is_std)]

y_merged <- merge(y_combined, activity_labels, sort=FALSE)

tidy_data <- cbind(subject, y_merged, x_mean_std_only)
tidy_data <- tidy_data[order(tidy_data$Subject.Index,tidy_data$Activity.Index),]


full_data <- cbind(subject, y_combined, x_combined)
full_aggregate <- aggregate(full_data, 
                            by = list(full_data$Subject.Index, 
                                      full_data$Activity.Index), 
                            FUN="mean")
full_merged <- merge(full_aggregate, activity_labels, sort=FALSE)
full_tidy_data <- cbind(full_merged$Subject.Index, 
                        full_merged$Activity.Index,
                        full_merged$Activity.Label,
                        full_merged[,5:565])
