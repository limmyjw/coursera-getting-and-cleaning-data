# coursera-getting-and-cleaning-data
# README.md 
The files used for the Peer Graded Assignment: Getting and Cleaning Data Course Project

Files submitted:

1. README.md
2. run_analysis.R
3. Codebook.txt
4. by_actsub.txt


# Description of run_analysis.R Walkthrough

Part 1 This is about getting the data and setting a working environment
 Create a new and clean directory
 Download and unzip the files
 set working directory

Part 2 Setting the necessary libraries

Part 3 Reading the data
 Before merging the train and test dataset, I decided to make each dataset nice and complete for easier use later on

* Step 1  read the testdata 
* Step 2  read the columnames dataset
* Step 3  It turns out that the table with columnames has duplicate records.
        I decided to subsitute "mean()" with "MEAN()"  which allows me to select on MEAN() later on  
		I decided to replace "std()" with "STD()" which allows me to select on STD later on
		I decided to make the records in the table containing the columnames unique by pasting the constant VAR with the recordnumber and the recordvalue
* Step 4  the columnames are assigned to the testdata (descriptive variable names).
* Step 5	read the subject_test data in a table and assign a cloumnname 
* Step 6 	Create a new column called dataset with a default value "test" in the table containng the subjects (This not becessary to do in this table)
* Step 7  The appropiate (activity) labels are wanted in the dataset. We have to make a join between the activity and the activity_label dataset and assign columnames
* Step 8 putting it all together cbind subject,activity and measurements
* Step 9	Repeat the steps 1 to 8 with the train dataset make in step 6 the default value "train"
* Step 10	Now we have two datasets train and test. So we put them together with rbind
* Step 11 select all fields containing MEAN() or STD. That's how I interpreted assignment 2 (Extracts only the measurements on the mean and standard deviation for each measurement.)
		so columns with meanFREQ() in it, and the columns 
			angle(tBodyAccMean,gravity), 
			angle(tBodyAccJerkMean),gravityMean), 
			angle(tBodyGyroMean,gravityMean), 
			angle(tBodyGyroJerkMean,gravityMean), 
			angle(X,gravityMean),
			angle(Y,gravityMean),
			angle(Z,gravityMean)
			are excluded on purpose.
* Step 12 Order and group the data to create a data set with the average of each variable for each activity and each subject.
This dataset is written to a file called by_actsub.txt 

# Codebook 
The file codebook.txt is a description of the data and the variables.

# by_actsub.txt
This file is the result of the run_analysis.R script.


