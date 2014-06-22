### Create a tidy data set combine files 
#The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
#  
#  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#
#Here are the data for the project: 
#  
#  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
#You should create one R script called run_analysis.R that does the following. 
#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names. 
#5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
#tidydata <- function (){
library(reshape2)
library(plyr)
actLabel <- "activity_labels.txt"
features <- "features.txt"

testDataFile <- "X_test.txt"  # contains processed test data for subjects in test group
testActivFile <- "y_test.txt" # contains labels of activities associated with data
testSubjectFile <- "subject_test.txt" # contains test subject identifier
trainDataFile <- "X_train.txt"  # contains processed test data for subjects in test group
trainActivFile <- "y_train.txt" # contains labels of activities associated with data
trainSubjectFile <- "subject_train.txt" # contains test subject identifier

#step 1 combine data sets
#Assume we are starting in the UCI HAR Dataset directory
#setwd("C:/data scientist toolkit/GetCleanData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")
actLabel <- read.table(actLabel)
features <- read.table(features)
#Go to the test directory
setwd("test")
file1 <- read.table(testSubjectFile) # read in subject id
file2 <- read.table(testActivFile) # read in activity codes
file3 <- read.table(testDataFile) # read in processed data
td1 <- cbind(file1,file2,file3) # combine into 1 data frame columns: subject,activity, features 1-561
setwd("../train")
file1 <- read.table(trainSubjectFile) # read in subject id
file2 <- read.table(trainActivFile) # read in activity codes
file3 <- read.table(trainDataFile)# read in processed data
td2 <- cbind(file1,file2,file3) # combine into 1 data frame columns: subject,activity, features 1-561
td3 <- rbind(td1,td2) # combine the test and training data into one frame
dim(td3)
#Completion of step 1
#Step 2 strips out all columns(features) that are not std or mean measures
# use grep to find names containing mean and std in the features file 
# add two since our first two columns have subject id and activity label
# combine the result with columns 1 and two into a vector called keeps
# create a new data frame called td4 with only the selected columns
featuremean <- grep("mean",features[,2],ignore.case=TRUE) + 2
featurestd <- grep("std",features[,2],ignore.case=TRUE) +2
keeps <- c(1,2,featuremean,featurestd)
keepsort <- sort(keeps)
td4 <- td3[,keepsort] # select only the columns found to contain std or keep
dim(td4)

#Completion of step 2 keeping only Mean or std features
#step 3 Use descriptive activity names to name the activities in the data set
# prepare a vector from the second column (activity numbers) and replace numbers by labels
activ <-sub (1,"WALKING",td4[,2])
activ <-sub (2,"WALKING_UPSTAIRS",activ)
activ <-sub (3,"WALKING_DOWNSTAIRS",activ)
activ <-sub (4,"SITTING",activ)
activ <-sub (5,"STANDING",activ)
activ <-sub (6,"LAYING",activ)
# replace the second colmun in the data set with the labels
td4[,2] <- activ
#end of step 3
# step 4
# step 5 appropriately label the data set with descriptive variable names
# use vector of features from above (take out 1- subject and 2 activity)
# also subtract 2 to get us back to index on features
### - use this to keep original names
keeplbl <- keepsort[3:length(keeps)] -2
featlbls <- features[,2]
featlbl2 <- as.character(featlbls[keeplbl])
setwd("../")
# read file containing new names in 3rd column called new_name
### replace the following lines so they work standalone
###newnames <- read.csv("features3.csv")
### create character vector of new names
###featlbl2 <- as.character(newnames$new_name)
# add subject and activity as the firt two column lables
alllbl <- c("subject","activity",featlbl2)
# add column names to the data frame
colnames(td4) <- alllbl
# write file out without row names
#write.table(td4,file="td4.txt",row.names=FALSE)
#create new column combining subject and activity that we will summarize by
subjact <- paste(td4[,1],td4[,2])
td5 <- cbind(subjact,td4)

# sort the file by combination of subject and activity
td6 <- td5[order(td5$subject,td5$activity),]
# write file out without row names
#write.table(td6,file="td6.txt",row.names=FALSE)
tdMelt <- melt(td6,id=c("subjact","subject","activity"),measure.vars = featlbl2)
td7 <- dcast(tdMelt,subjact~ variable,mean)
#write.table(td7,file="td7.txt",row.names=FALSE)
splt <- data.frame(do.call('rbind',strsplit(as.character(td7$subjact),' ',)))
subjectnum <- as.numeric(splt[,1])
actnum <- splt[,2]
td8 <- cbind(subjectnum,actnum,td7[,2:87])
# rename the new columns
colnames(td8)[1]<- "subject"
colnames(td8)[2]<- "activity"
tidydata  <- td8[order(td8$subject,td8$activity),]
write.table(tidydata,file="tidydata.txt",row.names=FALSE)
