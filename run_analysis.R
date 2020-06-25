library(tidyverse)

# read the data
x_train = read.table("./train/X_train.txt")
x_test = read.table("./test/X_test.txt")
y_train = read.table("./train/y_train.txt")
y_test = read.table("./test/y_test.txt")
subject_train = read.table("./train/subject_train.txt")
subject_test = read.table("./test/subject_test.txt")

# Merge the training and the test sets to create one data set
x = rbind(x_train, x_test)
y = rbind(y_train, y_test)
subject = rbind(subject_train, subject_test)

# Extract only the measurements on the mean and standard deviation for each measurement
feature = read.table("./features.txt")
means = grep("mean", feature$V2)
stds = grep("std", feature$V2)
x_extract = x[, c(means, stds)]

# Uses descriptive activity names to name the activities in the data set
y_named = recode(y$V1, "1" = "WALKING", "2" = "WALKING_UPSTAIRS", 
                 "3" = "WALKING_DOWNSTAIRS", "4" = "SITTING",
                 "5" = "STANDING", "6" = "LAYING")
y_named = data.frame(y_named)
colnames(y_named) = "Activity"

# Appropriately labels the data set with descriptive variable names
colnames(x) = feature$V2
x_extract = x[, c(means, stds)]

# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject
colnames(subject) = "subject"
df = cbind(x_extract, y_named, subject)
summary_table <- df %>% 
  group_by(Activity, subject) %>%
  summarise_all(mean)

write.table(summary_table, file = "./summary_table.txt", row.name=FALSE)