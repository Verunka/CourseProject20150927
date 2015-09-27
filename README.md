#Description of the script run_analysis.R

The main goal of the script is to:
* merge training and tests sets, 
* extracts only measurements on the mean and standard deviation for each measurements, 
* add subject and activity columns, 
* label all columns with appropriate names
* create a tidy data set with average for each activity and each subject.

Before running the script please make sure the whole directory UCI HAR Dataset is in your
working directory.

##Description

In the first step the script reads in both the data sets (training and test set) from your working directory.
Then it merges them into one data set mergedData.

In the second step the script extract only measurements with simple mean and standard deviation (all variables
denoted as -mean() or -std()). To perform this step the features.txt file is used which contains all the variables
names. New data set with only the required measurements is created (msData).

The next step firstly reads in activity files (y_train and y_test files) as well as subject files (subject_train
and subject_test) and merged them into mergedLables (for activity files) and mergedSubjects (for subject files). These
two new data sets are added (cbind) to our data set (msData). Appropriate column names are set.
Then it reads in the names of activities (activity_labels file) and merged this file with our data set by the column activity.

Next the script tidies up all the column names according to tidy-data-principles. (e.g. removing (), - ). 

The last step creates an independent tidy data set with the average of each mean/std measurement for each activity (1-6) and
each subject (1-30). To perform this step the functions melt and dcast from the r-package reshape2 are used. 

At the end the text file tidy_data.txt is created with the function write.table. The text file is saved in the 
UCI HAR Dataset directory in you working directory.