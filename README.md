getcleandata
============

repository for Data Scientist Toolkit Getting and cleaning data course

explains the workings of the 

Starting with the following files as obtained from zip

UCI HAR Dataset
activity_labels.txt – this file lists the labels for the identified activities

1 – walking, 2 walking upstairs, 3 walking downstairs 4 sitting 5 standing 6 laying

features.txt – this file contains all the labels (561) for the processed sensor data found in X_train.txt and X_test.txt files
 
features_info.txt – more descriptions of the features above (not used in processing)

in the test directory  are:
subject_test.txt – identifies the subject for each row of the data found in the X_test.txt data set (2947 rows)
y_test.txt – gives the assigned activity labels for the data in each row of the test data set (2947 rows)
X_test.txt – give the actual reading for the subject for the activity labeled (561 features for 2947 rows)

Another directory providing the raw data for the processed data found in X_test – files in this directory will not be used
In the train directory are the same files only containing data for subject in the training category

Step 1 combining test and train datasets

Processing steps – combining data 
We read in the activity_labels.txt into the r object -  actLabel
We read the features.txt file into the r object - features

Starting with the test data
Change to the test working directory
We read the subject_test.txt file and the y_test.txt file and the subject_test.txt files in for file1, file2 and file 3 and combine them using cbind which gives us:
Rows with subjectID, activity label, and 561 readings/features – this is stored in the r object testData

We put this in an r object called TD1

This same process is repeated for the training data resulting in an r object call trainData resulting in an R object called TD2

These two data sets are then combined using rbind into and R object named td3

This gives us all the processed data with the subject and activity number in the first two columns

Step 2  Extract only the measurements on the mean and standard deviation for each measurement

Since it is somewhat ambiguous as to whether some of the feature names should be included or not I decided to include them in the final data set so thay could be
 processed if needed

I used grep to find all the variable names with mean or std in their name
I then retrieved these names from the features file and used them to retain only the wanted features and placed these into a frame called td4
We now had a data set with only subject, activity number and readings with either mean or std in their name

Step 3 use descriptive activity names in the data set
I next replaced the activity numbers by text for the activity in the second column by creating a vector from the second column and using sub to replace the numbers
 with values, I then replaced the second column in td4 with the activity labels
I created a file with new observation names from the features file and placed this into a file called features3
-------------------------
activ <-sub (1,"WALKING",td4[,2])
activ <-sub (2,"WALKING_UPSTAIRS",activ)
activ <-sub (3,"WALKING_DOWNSTAIRS",activ)
activ <-sub (4,"SITTING",activ)
activ <-sub (5,"STANDING",activ)
activ <-sub (6,"LAYING",activ)
# replace the second colmun in the data set with the labels
td4[,2] <- active
------------------------------

Step 4 appropriately labels data set
I created a file of new names based on the tagged names and read this in to create new names - I had to comment this secton off in the source because this file would 
not be present in the submittal test area.. so I left the original names


Step 5 – create a new data set with only the averages of the features

I created a new column by combining the subject and activity labels – e.g. 1 Walking
I then did a melt of the data frame with subject (new field) as id and the readings as measure.var
I then used a dcast by subject (combined subject and activity) 
td7 <- dcast(tdMelt,subjact~ variable,mean)
and asked for the mean of the variables
this gave me a dataset with the means of all variables for every combination of subject and activity
since this dataset only had the combined subject and activity as the first column I had to split this back off
into two columns and add them back to replace the combined subject +activity
I then sorted the dataset and wrote it to tindydata.txt

