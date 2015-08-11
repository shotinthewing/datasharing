#Coursera Getting and Cleaning Data 
#
#Project Assignment:
#Source of the data for the project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#
library(plyr)
#This script is divided in 5 parts and does the following:
#
#1) merges the training and the test set creating one data set
#first we read the test data:
x_test<-read.table("test/X_test.txt")
y_test<-read.table("test/y_test.txt")
subject_test<-read.table("test/subject_test.txt")
#then we do the same thing for the train data:
x_train<-read.table("train/X_train.txt")
y_train<-read.table("train/y_train.txt")
subject_train<-read.table("train/subject_train.txt")
#now we bind together the X data for train and test in the x dataset
x<-rbind(x_train,x_test)
#and we do the same for the y and subject data
y<-rbind(y_train,y_test)
subject<-rbind(subject_train,subject_test)
#we can also create a unique data set for the X, y and subject data
fulldata<-cbind(x,y,subject)
#----------------------------------------------------------------------------------------------------------------------------------------------------
#2)Extracts only the measurments on the mean and standard deviation for each measurement
#we read the feature.txt files to get the name of the measurements
features<-read.table("features.txt", col.names=c("N","Measurement_Name"))
#now we create the filter for our measures, we only want means and standard deviations
filter<-grep('mean\\(\\)|std\\(\\)',features$Measurement_Name)
#now we can filter the x dataset containing the values of the measurements on mean and standard deviation
mean_std<-x[,filter]
#now we assign the correct names of the features to the coulumns of the database
featuresnew<-features[filter,]
names(mean_std)<-featuresnew$Measurement_Name
#----------------------------------------------------------------------------------------------------------------------------------
#3)Uses descriptive activity names to name the activities in the data set:
#we read the file with the activity labels
activities<-read.table("activity_labels.txt")
#we want to substitute the names of the 5 activities in the y database, which only has the corresponding numbers
#we give the correct name to the y database
names(y)<-"Activity"
#and then we rename the single rows
y$Activity<-activities[y$Activity,2]
#----------------------------------------------------------------------------------------------------------------------------------
#4)Appropriately labels the data set with descriptive variable names
#we give the appropriate variable name to the subject dataset

#we create the final, clean data set binding the ones we manipulated, mean_std, subject and 
names(subject)<-"Subject"
#then we bind the three data sets we manipulated to obtain the final clean data set with all the correct variable names
cleanset<-cbind(mean_std,y,subject)
#----------------------------------------------------------------------------------------------------------------------------------
#5)From the data set in step 4, creates a second, independent tidy data set with the average of each variable for 
#each activity and each subject.
library(reshape2)
#we first need to melt the data set
cleanset_melted<-melt(cleanset,id=c("Subject","Activity"))
#then we cast the data frame we want, averaging on the other variables
finalset<-dcast(cleanset_melted,Subject+Activity~variable,mean)

#finally we write on a text file the clean data base we obtained
write.table(finalset, "tidy.txt", sep="\t",row.names=FALSE)
