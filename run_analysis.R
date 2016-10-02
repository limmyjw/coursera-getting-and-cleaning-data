#run_analysis.R

#Part 1

#This is about getting the data and setting a working environment
#Create a new and clean directory
beginwd <- getwd()  

mydir <- paste(getwd(),"/dataM3Final4" ,sep="",collapse=NULL)
if(!file.exists(mydir)) {
        dir.create(mydir)
}

setwd(mydir)

#Download and unzip the files
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile= "./dataset.zip", mode= "wb") 
unzip("./dataset.zip",exdir=mydir)
#list.dirs('./dataM3Final', recursive= FALSE)
#list.files("./dataM3Final/UCI HAR Dataset")
dateDownloaded <- date()
mywd<-paste(mydir,"/UCI HAR Dataset", sep="",collapse=NULL)
setwd(mywd)
getwd()


#Part 2
#setting libraries
if (!require("dplyr")) install.packages("dplyr")
library(dplyr)
if (!require("tidyr")) install.packages("tidyr")
library(tidyr)

#library(RPostgreSQL)
#library(DBI)



#Part 3 Reading the data
# Step 1 Reading the test data
dttest10 <- read.table("./test/X_test.txt")  #testdata
# Step 2 Reading the columnnames data
kolomnaam10 <- read.table("./features.txt") #columnnames data
#Step 3 making unique columnnames
kolomnaam11<-kolomnaam10 %>%
        mutate(V2=sub("mean\\(\\)", "MEAN\\(\\)",V2)) %>%
        mutate(V2=sub("std\\(\\)", "STD\\(\\)",V2)) %>%
        mutate(V2=paste("VAR",V1,V2, sep="")) 
#Step 4 assign columnnames to testdata
colnames(dttest10) <- kolomnaam11[,2] 
#Step 5-1 read the subject_test data 
dttest11 <- read.table("./test/subject_test.txt")   #bestand met subjecten inlezen
#Step 5-2 assign a columnname
colnames(dttest11) <- "subject"                                 # kolomnaam toewijzen
#Step 6 create a new column called dataset with a default value "test"
dttest11["dataset"] <- "test"                                   #clean and tidy aangeven uit welke dataset
#Step 7 create activity labels by joining and assigning 
#Step 7-1 Read activity and activity-labels
dttest12 <- read.table("./test/y_test.txt")   #bestand met activiteiten inlezen
dttest13 <- read.table("./activity_labels.txt", stringsAsFactors=FALSE)
#Step7-2 join activity and activity-labels and assign columnnames
dttest14 <-inner_join(dttest12,dttest13, by=c("V1"="V1"))
colnames(dttest14) <- c("activity_code","activity")      # kolomnaam toewijzen
#Step 7-3 select the appropiate column from the table
dttest15 <- (select(dttest14, activity))

#Step 8 putting  all test data together
dttest <- cbind(dttest11, dttest15, dttest10)   #samenvoegen tabellen


#Bestanden train inlezen
#Step 1 Reading the train data
dttrain10 <- read.table("./train/X_train.txt")  #testdata
# Step 2 Reading the columnnames data
kolomnaam10 <- read.table("./features.txt") #columnames data
#Step 3 making unique columnnames
kolomnaam11<-kolomnaam10 %>%
        mutate(V2=sub("mean\\(\\)", "MEAN\\(\\)",V2)) %>%
        mutate(V2=sub("std\\(\\)", "STD\\(\\)",V2)) %>%
        mutate(V2=paste("VAR",V1,V2, sep="")) 
#Step 4 assign columnnames to traindata
colnames(dttrain10) <- kolomnaam11[,2] 
#Step 5-1 read the subject_test data 
dttrain11 <- read.table("./train/subject_train.txt")   #bestand met subjecten inlezen
#Step 5-2 assign a cloumnname
colnames(dttrain11) <- "subject"                                 # kolomnaam toewijzen
#Step 6 create a new column called dataset with a default value "train"
dttrain11["dataset"] <- "train"                                   #clean and tidy aangeven uit welke dataset
#Step 7 create activity labels by joining and assigning 
#Step 7-1 Read activity and activity-labels
dttrain12 <- read.table("./train/y_train.txt")   #bestand met activiteiten inlezen
dttrain13 <- read.table("./activity_labels.txt", stringsAsFactors=FALSE)
#Step7-2 join activity and activity-labels and assign columnnames
dttrain14 <-inner_join(dttrain12,dttrain13, by=c("V1"="V1"))
colnames(dttrain14) <- c("activity_code","activity")      # kolomnaam toewijzen
#Step 7-3 select the appropiate column from the table
dttrain15 <- (select(dttrain14, activity))
#Step 8 putting  all train data together
dttrain <- cbind(dttrain11, dttrain15, dttrain10) #samenvoegen tabellen


#Step 10 Now we have two datasets train and test. So we put them together with rbind
dttot <- rbind(dttest,dttrain)  

#Step 11 select all fields containing MEAN() or STD
dttotq4 <- dttot %>%
        select(subject, activity,contains("MEAN()"), contains("STD"))

#Step 12 Group the data and calculate means and write the data file
dftotq4 <- data.frame(dttotq4)
by_actsub <- dftotq4 %>%
        group_by(activity,subject) %>%
        summarise_each(funs(mean))

write.table(by_actsub,file="./by_actsub.txt", row.name=FALSE) 

