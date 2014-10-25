##Step 1: read in dataset sourced in local directory; Read in x, y, and subject training data from text files
options(stringsAsFactors = FALSE)
x_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
y_train <- read.table('./UCI HAR Dataset/train/y_train.txt')
subject_train <- read.table('./UCI HAR Dataset/train/subject_train.txt')
xtrain_data <- length(x_train$V1)

##Create variable to keep track if data training or test
train_vec <- rep("Training",xtrain_data)

##Step 2: read in dataset sourced in local directory; Read in x, y, and subject test data from text files
x_test <- read.table('./UCI HAR Dataset/test/X_test.txt')
y_test <- read.table('./UCI HAR Dataset/test/y_test.txt')
subject_test <- read.table('./UCI HAR Dataset/test/subject_test.txt')
xtest_data <- length(x_test$V1)

##Create variable to keep track if data training or test
test_vec <- rep("Test",xtest_data)
name_vec <- c(train_vec,test_vec)

##Step 3: read in dataset sourced in local directory; Read in activity data from features text file
header_data <- read.table('./UCI HAR Dataset/features.txt', as.is = TRUE)

##Step 4: assemble merged data frame
merged_data <- rbind(x_train,x_test)
names(merged_data) <- header_data$V2
y_var <- rbind(y_train,y_test)
sub_var <- rbind(subject_train,subject_test)
merged_data <- cbind(name_vec,sub_var,y_var,merged_data)
names(merged_data)[1] <- "Category"
names(merged_data)[2] <- "SubjectNumber"
names(merged_data)[3] <- "Activity"

##Step 5: extract mean and std deviation data into new data frame
extracted_data <- merged_data[,c(1,2,3)]
mean_data <- merged_data[,grep("mean()",names(merged_data),value=TRUE)]
std_data <- merged_data[,grep("std()",names(merged_data),value=TRUE)]
extracted_data <- cbind(extracted_data,mean_data,std_data)

##Step 6: assign descriptive activity names
extracted_data$Activity <- gsub("[1]","Walking",extracted_data$Activity)
extracted_data$Activity <- gsub("[2]","Walking_Upstairs",extracted_data$Activity)
extracted_data$Activity <- gsub("[3]","Walking_Downstairs",extracted_data$Activity)
extracted_data$Activity <- gsub("[4]","Sitting",extracted_data$Activity)
extracted_data$Activity <- gsub("[5]","Standing",extracted_data$Activity)
extracted_data$Activity <- gsub("[6]","Laying",extracted_data$Activity)

##Step 7: assign descriptive variable names
namevec <- names(extracted_data)[4:82]

for(i in seq_along(namevec)) {
  if(grepl("-std()",namevec[i])){
    namevec[i] <- gsub("-std()","",namevec[i])
    namevec[i] <- paste("StdDeviation",namevec[i],sep="")
  } else if (grepl("-mean()",namevec[i])) {
    namevec[i] <- gsub("-mean()","",namevec[i])
    namevec[i] <- paste("Mean",namevec[i],sep="")
  }
} 

for(i in seq_along(namevec)){
  if (grepl("-X",namevec[i])) {
    namevec[i] <- gsub("-X","XAxis",namevec[i])
  } else if (grepl("-Y",namevec[i])) {
    namevec[i] <- gsub("-Y","YAxis",namevec[i])
  } else if (grepl("-Z",namevec[i])) {
    namevec[i] <- gsub("-Z","ZAxis",namevec[i])
  }
}

for(i in seq_along(namevec)){
  if (grepl("()",namevec[i])) {
    namevec[i] <- gsub("\\()","",namevec[i])
  } 
}

for(i in seq_along(namevec)){
  if (grepl("BodyBody",namevec[i])) {
  namevec[i] <- gsub("BodyBody","Body",namevec[i])
  }
}

for(i in seq_along(namevec)){
  if (grepl("tBody",namevec[i])) {
    namevec[i] <- gsub("tBody","Body",namevec[i])
    namevec[i] <- paste(namevec[i],"TimeDomain",sep="")
  } else if (grepl("tGravity",namevec[i])) {
    namevec[i] <- gsub("tGravity","Gravity",namevec[i])
    namevec[i] <- paste(namevec[i],"TimeDomain",sep="")
  }
}

for(i in seq_along(namevec)){
  if (grepl("fBody",namevec[i])) {
    namevec[i] <- gsub("fBody","Body",namevec[i])
    namevec[i] <- paste(namevec[i],"FreqDomain",sep="")
  } else if (grepl("fGravity",namevec[i])) {
    namevec[i] <- gsub("fGravity","Gravity",namevec[i])
    namevec[i] <- paste(namevec[i],"FreqDomain",sep="")
  }
}
names(extracted_data)[4:82] <- namevec

##Step 8: re-shape data frame to organize by subject, activity, and mean
library(reshape2)
reshaped_data <- melt(extracted_data,id=c("SubjectNumber","Activity"),measure.vars=namevec)
avgreshaped_data <- dcast(reshaped_data, SubjectNumber + Activity ~ variable, mean)
tidy_data <- melt(avgreshaped_data,id=c("SubjectNumber","Activity"),measure.vars=namevec)
names(tidy_data)[3:4] <- c("Measurement","MeanValue")

##Step 9: export to txt file
write.table(tidy_data,"GettingCleaningDataProject.txt",row.name=FALSE)
