#1. Merges the training and the test sets to create one data set.

#read in both the test and the train set from the working directory
X_test <- read.table("UCI HAR Dataset\\test\\X_test.txt", quote = "\"")
X_train <- read.table("UCI HAR Dataset\\train\\X_train.txt", quote = "\"")

#merge the data into one data frame
mergedData <- rbind(X_train, X_test)


#2. Extracts only the measurements on the mean and standard deviation 
#for each measurement. 

#read the columnNames for the mergedData
names <- read.table("UCI HAR Dataset\\features.txt")

#set the columnNames   
colnames(mergedData) <- names[,2]

#find all the columnNames containing "mean" or "std"
meanColumns <- grep("-mean\\()", names[,2])
stdColumns <- grep("-std\\()", names[,2])

#combine meanColumns and stdColumns, sort the file
msColumns <- sort(c(meanColumns,stdColumns))

#extraxt only the measurements with mean or std into a new data frame
msData<- mergedData[msColumns]


#3.Uses descriptive activity names to name the activities in the data set

#read in the data for activity (both train and test files)
y_train <- read.table("UCI HAR Dataset\\train\\y_train.txt")
y_test <- read.table("UCI HAR Dataset\\test\\y_test.txt")

#read in the data for subjects (both train and test files)
subject_train <- read.table("UCI HAR Dataset\\train\\subject_train.txt")
subject_test <- read.table("UCI HAR Dataset\\test\\subject_test.txt")

#merge the train and test activity labels and subjects
mergedLabels <- rbind(y_train, y_test)
mergedSubjects <- rbind(subject_train, subject_test)

#read in the names of activities
activity_labels <- read.table("UCI HAR Dataset\\activity_labels.txt")

#add the activity labels column to the data
msDataAct <- cbind(msData, mergedLabels)

#rename the new column 
names <- colnames(msDataAct)
names <- gsub("V1", "activity", names)
colnames(msDataAct) <- names

#add subject column and rename the column name to subject
msDataActSub <- cbind(msDataAct, mergedSubjects)
names <- colnames(msDataActSub)
names <- gsub("V1", "subject", names)
colnames(msDataActSub) <- names

#merge the activity with the activity_label 
msDataActSub <- merge(msDataActSub, activity_labels, by.x = "activity", by.y = "V1")
msDataActSub <- msDataActSub[2:69]

#4.Appropriately labels the data set with descriptive variable names

#get all the columnNames
names <- colnames(msDataActSub)

#rename last columnName to ActivityLabel (all other have been already renamed)
names <- gsub("V2", "activityLabel", names)

#tidy the column names (remove the brackets and substitute "-" with dots)
names <- gsub("[()]", "", names)
names <- gsub("-",".", names)
colnames(msDataActSub) <- names


#5.From the data set in step 4, creates a second, independent tidy data set
#with the average of each variable for each activity and each subject.

install.packages("reshape2")
library(reshape2)

variables <- colnames(msDataActSub)
variables <- variables[1:66]

dataMelt <- melt(msDataActSub, id.vars = c("activityLabel", "subject"), measure.vars = variables)

dataCast <- dcast(dataMelt, activityLabel + subject ~ variable, mean)


#create a text file to submit
write.table(dataCast, file = "UCI HAR Dataset\\tidy_data.txt", row.name = FALSE)
