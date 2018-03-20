fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="C:/Users/lnsei/Documents/GettingandCleaningData/Dataset.zip")
unzip(zipfile="C:/Users/lnsei/Documents/GettingandCleaningData/Dataset.zip",exdir="C:/Users/lnsei/Documents/GettingandCleaningData")

x_train <- read.table("C:/Users/lnsei/Documents/GettingandCleaningData/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("C:/Users/lnsei/Documents/GettingandCleaningData/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("C:/Users/lnsei/Documents/GettingandCleaningData/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("C:/Users/lnsei/Documents/GettingandCleaningData/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("C:/Users/lnsei/Documents/GettingandCleaningData/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("C:/Users/lnsei/Documents/GettingandCleaningData/UCI HAR Dataset/test/subject_test.txt")

features <- read.table("C:/Users/lnsei/Documents/GettingandCleaningData/UCI HAR Dataset/features.txt")
activityLabels = read.table("C:/Users/lnsei/Documents/GettingandCleaningData/UCI HAR Dataset/activity_labels.txt")

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
merged <- rbind(mrg_train, mrg_test)

colNames <- colnames(merged)
mean_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)
MeanAndStd_table <- merged[ , mean_std == TRUE]
ActivityNames_table <- merge(MeanAndStd_table, activityLabels,
                              by='activityId',
                              all.x=TRUE)
TidySet2 <- aggregate(. ~subjectId + activityId, ActivityNames_table, mean)
TidySet2 <- TidySet2[order(TidySet2$subjectId, TidySet2$activityId),]
write.table(TidySet2, "TidySet2.txt", row.name=FALSE)
