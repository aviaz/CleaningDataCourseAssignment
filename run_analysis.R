library(maditr)

# Unzipping the data
#unzip("getdata_projectfiles_UCI HAR Dataset.zip")

# Loading activity and features
activities = read.table("UCI HAR Dataset/activity_labels.txt")
features = read.table("UCI HAR Dataset/features.txt")
col_numbers = grep("std|mean[^F]", features[,2])

# Loading train dataset
X_train = read.table("UCI HAR Dataset/train/x_train.txt")
y_train = read.table("UCI HAR Dataset/train/y_train.txt")
subject_train = read.table("UCI HAR Dataset/train/subject_train.txt")

# Loading test dataset
X_test = read.table("UCI HAR Dataset/test/X_test.txt")
y_test = read.table("UCI HAR Dataset/test/y_test.txt")
subject_test = read.table("UCI HAR Dataset/test/subject_test.txt")


X_merged = rbind(X_train,X_test)
df = X_merged[,col_numbers]
y_merged = rbind(y_train,y_test)
subject_merged = rbind(subject_train,subject_test)

# Make the new names of columns legitimate and beautify
names_vector = features[col_numbers, 2]
names_vector = gsub("[()]","",names_vector)
names_vector = gsub("[-]","_",names_vector)
names(df) = names_vector

# Give names to the activity and subject columns
names(y_merged) = "activity_custom"
names(subject_merged) = "subject"
names(activities)<-c("number","activity")

# Bind df with subject and activity
df = cbind(df,subject_merged, y_merged)
df = merge(df,activities,by.x="activity_custom",by.y="number",sort=FALSE)
df$activity_custom = NULL

# Melting df with id which is subject + activity, and apply mean to new file
df = melt(df,id=c("subject","activity"))
df = dcast(df,subject + activity~variable,mean)
write.table(df,file="tidy.txt")
