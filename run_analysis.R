

## 1. Merges the training and the test sets to create one data set.

xtrain <- read.table("./data/train/X_train.txt")
xtest <- read.table("./data/test/X_test.txt")
X <- rbind(xtrain, xtest)

strain <- read.table("./data/train/subject_train.txt")
stest <- read.table("./data/test/subject_test.txt")
S <- rbind(strain, stest)

ytrain <- read.table("./data/train/y_train.txt")
ytest <- read.table("./data/test/y_test.txt")
Y <- rbind(ytrain, ytest)

features <- read.table("./data/features.txt")

colnames(X) <- t(features[2])
View(X)
View(Y)
View(S)


colnames(Y) <- "Activity"
colnames(S) <- "Subject"
mergedData <- cbind(X,Y,S)
View(mergedData)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(mergedData), ignore.case=TRUE)
View(columnsWithMeanSTD)

requiredColumns <- c(columnsWithMeanSTD, 562, 563)
select <- mergedData[,requiredColumns]


## 3. Uses descriptive activity names to name the activities in the data set

activity <- read.table("./data/activity_labels.txt", header = FALSE)
View(activity)
View(select)

select$Activity <- as.character(select$Activity)
for (i in 1:6){
  select$Activity[select$Activity == i] <- as.character(activity[i,2])
}

## 4. Appropriately labels the data set with descriptive variable names. 

names(select)

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

select$Subject <- as.factor(select$Subject)
select <- data.table(select)

tidyData <- aggregate(. ~Subject + Activity, select, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
View(tidyData)
write.table(tidyData, file = "./data/Tidy.txt", row.names = FALSE)

