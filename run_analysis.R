## This script reads train and test data and merge them in one table. 
##It also extracts Extracts only the measurements on the mean and standard deviation for each measurement
##Uses descriptive activity names to name the activities in the data set
##Appropriately labels the data set with descriptive variable names.
##Creates independent tidy data set with the average of each variable for each activity and each subject.

##Reads features and activity labels table.Please set appropriate working directory before running the step.

activity_labels<-read.table("activity_labels.txt")
feature<-read.table("features.txt")


##Converts second column of features table into character vector

feature_character<-as.character(feature[[2]])


##Reads test data.Please set appropriate working directory.

y_test<-read.table("y_test.txt")
subject_test<-read.table("subject_test.txt")
X_test<-read.table("X_test.txt")

##Join Activity Laebels and y_test to get descriptive activity name
y_test<-merge(activity_labels,y_test,by='V1')
##Creates a data frame with 563 variables for test data.

data_test<-data.frame(subject_test,V2=as.character(y_test[[2]]),X_test,stringsAsFactors=FALSE)

##Reads train data.Please set appropriate working directory

y_train<-read.table("y_train.txt")
subject_train<-read.table("subject_train.txt")
X_train<-read.table("X_train.txt")

##Join Activity Laebels and y_test to get descriptive activity name
y_train<-merge(activity_labels,y_train,by='V1')

##Creates a data frame with 563 variables for train data.

data_train<-data.frame(subject_train,V2=as.character(y_train[[2]]),X_train,stringsAsFactors =FALSE)

##Merges train and test data.

merge_data<-rbind(data_test,data_train,stringsAsFactors =FALSE)

##Set column names of the Merge data. Character vector created above from features table is used here.

merge_data<-setNames(merge_data,c("Subject","Activity",feature_character))

##Idenitfy positions of measurements on mean and Standard deviations.

mean<-grep("mean",names(merge_data))
std<-grep("std",names(merge_data))

##Subsets so that final table only contains required variables.
Final_Data<-merge_data[c(1,2,mean,std)]


##Load reshape2 pacakge
library(reshape2)

##Uses melt and dcast function from reshape2 package to do  
##the average of each variable for each activity and each subject.

dfmelt<-melt(Final_Data,id=c("Subject","Activity"))
output<-dcast(dfmelt, Subject + Activity ~ variable,mean.default)

##Output of the table

write.table(output,"c:/TidyData.txt",sep="\t",row.name=FALSE)