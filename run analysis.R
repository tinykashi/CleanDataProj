### run_analysis.R
# Getting and Cleaining Data Course Project
# creates a tidy data set from the UCI HAR Dataset
# outputs the data set into a text file called "data_tidy.txt"

# load required librarys
library(plyr)

# read in all data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
s_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
s_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Step 1: merge training and test data
# combine data sets
dat <- cbind(x_test,y_test,s_test)
dat2 <- cbind(x_train,y_train,s_train)
dat <- rbind(dat,dat2)

# remove variables that are no longer needed
rm(x_test,y_test,s_test)
rm(x_train,y_train,s_train)
rm(dat2)

# Step 2: extract only mean and std data
# grab the features and find only mean and std
feat <- read.table("UCI HAR Dataset/features.txt",stringsAsFactors=FALSE)
ixm <- grep("mean",feat$V2)
ixs <- grep("std",feat$V2)
ix = sort(union(ixm,ixs))
# filter out unrelevant data (keep only mean and std)
dat <- dat[,c(ix,562,563)]

# Step 4: create descriptive labels based on features
names(dat) <- c(feat$V2[ix],"Activity","Subject")

# Step 3: change activity numbers to activity labels
act <- read.table("UCI HAR Dataset/activity_labels.txt",stringsAsFactors=FALSE)
dat$Activity <- as.factor(dat$Activity)
levels(dat$Activity) <- act$V2

# Step 5: create a new tidy dataset
# that is the mean for variable for each activity and each subject
# write to a .txt file, will output to working directory

datnew <- ddply(dat, .(Activity,Subject), numcolwise(mean))
write.table(datnew,"data_tidy.txt")
