#Getting and cleaning Data Course Project

rm(list=ls(all=TRUE))


#--------------------[Set Working Direcotry]--------------------
getwd()

setwd('C:/Coursera/Getting and Cleaning Data')

getwd()

#---------------------[Create Project Directory]------------------------

if(!file.exists('./Course Project')){
        dir.create('./Course Project')
}

#---------------------[Dowload dataset and unzip files]------------------

fileUrl<-'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(fileUrl, destfile='./Course Project/Smartphones.zip')
unzip('./Course Project/Smartphones.zip', exdir='./Course Project/DataSet')

#----------------------[List Files]------------------------------------

fileList<-list.files('./Course Project/DataSet/UCI HAR Dataset', recursive=TRUE)

fileList

#---------------------[Load Features Labels dataset]-----------------------------

features_labels<-read.table('./Course Project/DataSet/UCI HAR Dataset/features.txt')

dim(features_labels)

head(features_labels)

#--------------------[Load y-test (Activity) dataset]-----------------------------

y_test<-read.table('./Course Project/DataSet/UCI HAR Dataset/test/y_test.txt', header=FALSE)

dim(y_test)

head(y_test)

unique(y_test)



#--------------------[load y-train (Activity) dataset]-----------------------------
y_train<-read.table('./Course Project/DataSet/UCI HAR Dataset/train/y_train.txt', header=FALSE)

dim(y_train)

head(y_train)

unique(y_train)


#----------------------[Load SQLDF library]-----------------------------
library(sqldf)


#----------------------[Merge y_test and y_train (Activities)]-----------------------

activities<-sqldf('SELECT V1 FROM y_test UNION ALL SELECT V1 FROM y_train;' )

dim(activities)

head(activities)

unique(activities)

#----------------------[Load x_test (Features)]-------------------------------------

x_test<-read.table('./Course Project/DataSet/UCI HAR Dataset/test/x_test.txt', header=FALSE)

dim(x_test)

head(x_test)

names(x_test)

#----------------------[Load x_train (Features)]-------------------------------------

x_train<-read.table('./Course Project/DataSet/UCI HAR Dataset/train/x_train.txt', header=FALSE)

dim(x_train)

head(x_train)

names(x_train)
#--------------------[merge x_train and x_test (Features)]--------------------------------------

features<-sqldf('SELECT * FROM x_test UNION ALL SELECT * FROM x_train;')

dim(features)



#---------------------[load subject_test (Tester)]-------------------------------------------
#Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
subject_test<-read.table('./Course Project/DataSet/UCI HAR Dataset/test/subject_test.txt', header=FALSE)

dim(subject_test)

unique(subject_test)


#----------------------[load subject_train (Tester)]----------------------------------------
#Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30
subject_train<-read.table('./Course Project/DataSet/UCI HAR Dataset/train/subject_train.txt', header=FALSE)

dim(subject_train)

unique(subject_train)

#------------------------[Merge subject_train and subject_test]-------------------------

subject<-sqldf('SELECT * FROM subject_test UNION ALL SELECT * FROM subject_train;')

dim(subject)

head(subject)

unique(subject)

#------------------------[Add names to variables]----------------------------------------

names(subject)<-c('subject')

names(activities)<-c('activity')

names(features)<-features_labels$V2

features[1:5, 1:5]

head(subject)

head(activities)

#--------------[Q1: Merges the training and the test sets to create one data set]------------------

subject_activity<-cbind(subject, activities)

dim(subject_activity)

head(subject_activity)

#Human Activity Recognition Using Smartphones Data Set = HARUS

HARUS<-cbind(subject_activity, features) 

dim(HARUS)

str(HARUS)

#------------[Q2: Extracts only the measurements on the mean and standard deviation for each measurement]----

names(HARUS)


mean_std_variables<-sqldf('SELECT V2 FROM features_labels WHERE
                                V2 LIKE "%mean%"
                                OR
                                V2 LIKE "%std%"')

class(mean_std_variables)

str(mean_std_variables)

mean_std_variables<-transform(mean_std_variables, 
                              V2= as.character(V2))

sa<-c('subject', 'activity')

sa

subset_variables<-mean_std_variables$V2

subset_variables

subset_names<-c(sa, subset_variables)

class(subset_names)

subset_names

HARUS_mean_std<-subset(HARUS, select=c(subset_names))

dim(HARUS_mean_std)

str(HARUS_mean_std)


#-----------[Q3: Uses descriptive activity names to name the activities in the data set]-------------

#----------------[HARUS Dataset]------------------------------
HARUS[1:10, 1:3]

activity_labels<-read.table('./Course Project/DataSet/UCI HAR Dataset/activity_labels.txt', header=FALSE)

dim(activity_labels)

activity_labels

names(activity_labels)<-c('activity','activity_description')

activity_labels

attributes(HARUS$activity)

HARUS<-transform(HARUS,
                 activity=as.factor(activity))

attributes(HARUS$activity)

HARUS[1:20, 1:3]

HARUS$activity<-factor(HARUS$activity, 
                       levels=c("1", "2", "3", "4" ,"5", "6"), 
                       labels=c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS","SITTING", "STANDING", "LAYING")
                       )

HARUS[1:20, 1:3]

attributes(HARUS$activity)



#----------------------[HARUS_mean_std]-------------------------------

names(HARUS_mean_std)

attributes(HARUS_mean_std$activity)

HARUS_mean_std<-transform(HARUS_mean_std,
                          activity=as.factor(activity)
                          )

str(HARUS_mean_std)

HARUS_mean_std$activity<-factor(HARUS_mean_std$activity,
                                levels=c("1", "2", "3", "4", "5", "6"),
                                labels=c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS","SITTING", "STANDING", "LAYING")
                                )

attributes(HARUS_mean_std$activity)

head(HARUS_mean_std$activity, 200)

#--------------[Q4: Appropriately labels the data set with descriptive variable names.]-----------------------
#Feature Selection:
#These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz

#Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

#The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ

#Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

names(HARUS)

names(HARUS)<-gsub('^t', 'time', names(HARUS))

names(HARUS)

names(HARUS)<-gsub('^f', 'frequency', names(HARUS))

names(HARUS)

names(HARUS)<-gsub('Acc', 'Accelerometer', names(HARUS))

names(HARUS)

names(HARUS)<-gsub('Gyro', 'Gyroscope', names(HARUS))

names(HARUS)

names(HARUS)<-gsub('BodyBody', 'Body', names(HARUS))

names(HARUS)

names(HARUS)<-gsub('Mag', 'Magnitude', names(HARUS))

names(HARUS)

names(HARUS)<-gsub('\\.', '', names(HARUS))

names(HARUS)

#----------------------------[Fix HARUS_mean_std dataset variable names]---------------------------

dim(HARUS_mean_std)

names(HARUS_mean_std)

names(HARUS_mean_std)<-gsub('^t', 'time', names(HARUS_mean_std))

names(HARUS_mean_std)

names(HARUS_mean_std)<-gsub('^f', 'frequency', names(HARUS_mean_std))

names(HARUS_mean_std)

names(HARUS_mean_std)<-gsub('Acc', 'Accelerometer', names(HARUS_mean_std))

names(HARUS_mean_std)

names(HARUS_mean_std)<-gsub('Mag','Magnitude', names(HARUS_mean_std))

names(HARUS_mean_std)

names(HARUS_mean_std)<-gsub('BodyBody', 'Body', names(HARUS_mean_std))

names(HARUS_mean_std)

names(HARUS_mean_std)<-gsub('Gyro', 'Gyroscope', names(HARUS_mean_std))

names(HARUS_mean_std)

names(HARUS_mean_std)<-gsub('\\.', '', names(HARUS_mean_std))

names(HARUS_mean_std)

#------[Q:5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.]---------------------------------------

HARUS_2<-HARUS_mean_std

dim(HARUS_2)

names(HARUS_2)

library(dplyr)

HARUS2<-tbl_df(HARUS_2)

rm("HARUS_2")

rm(HARUS_mean_std)

HARUS2

select(HARUS2, subject, activity, timeBodyAccelerometermeanX)

filter(HARUS2, activity=="SITTING")

arrange(HARUS2, subject, activity )

harus2_by_subject_and_activity<-group_by(HARUS2, subject, activity)

harus2_by_subject_and_activity

harus2_averages<-summarise_each(harus2_by_subject_and_activity, funs(mean))

write.table(harus2_averages, 'C:/Coursera/Getting and Cleaning Data/Course Project/DataSet/harus2_averages.txt', row.names=FALSE)


