run_analysis <- function(){
  get_data()
  sim_data <- merge_set()
  filtered_data <- filter_data(sim_data)
  filtered_data <- apply_descriptive_name(filtered_data)
  tidied_data <- tidy_data(filtered_data)
  
  write.table(tidied_data, file="tidy_data.txt", row.name=FALSE)
}

# This function will get the file from the site suggested

get_data <- function() {
  
#creating a variable to have the URL of the file
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  
#creating dataDirectory and dataFile variables
  dataDirectory <- "./data"
  dataFile <- paste(dataDirectory, "/datafile.zip", sep="")
  
  print(dataFile)

#checking if the dataFile is already there...if yes, we have already completed the getting of
#data file process
  if (!file.exists(dataFile)) {
    
#Data file is not there, let us check if ./data directory is there
    if (!file.exists(dataDirectory)) {
      
#./data directory is not there, let us create the same
      dir.create(dataDirectory)
    }

#download the file into ./data directory with datafile.zip as the name

    download.file(fileURL, dataFile, method="auto")
    
#unzip datafile.zip in the data directory...
    unzip (dataFile, exdir=".")
  }
  
}

# This function will be called to merge training and the test sets. The return value is the
# merged set
merge_set <- function() {

#training data
  x_train <- read.table("UCI HAR Dataset//train/X_train.txt")
  subject_train <- read.table("UCI HAR Dataset//train/subject_train.txt", col.names="subject")
  y_train <- read.table("UCI HAR Dataset//train/y_train.txt", col.names="activity")
  
  train_data <- cbind(x_train, subject_train, y_train)
  
#testing data
  x_test <- read.table("UCI HAR Dataset//test/X_test.txt")
  subject_test <- read.table("UCI HAR Dataset//test/subject_test.txt", col.names="subject")
  y_test <- read.table("UCI HAR Dataset//test/y_test.txt", col.names="activity")
  
  test_data <- cbind(x_test, subject_test, y_test)
  
#add training and testing data

  data <- rbind(train_data, test_data)

  data
}

# from this merged set, the measurements on the mean and standard deviation will be extracted
# and sent back as data set

filter_data <- function(sim_data) {

  features <- read.table("UCI HAR Dataset//features.txt", col.names=c("id", "name"))
  feature_name <- c(as.vector(features[, "name"]), "subject", "activity")
  
  features_with_mean_and_std <- grepl("mean|std|subject|activity", feature_name) & !grepl("meanFreq", feature_name)
  
  filtered_data <- sim_data[, features_with_mean_and_std]
  
  names(filtered_data) <- feature_name[features_with_mean_and_std]
  
  filtered_data
}

apply_descriptive_name <- function(filtered_data){
  activities <- read.table("UCI HAR Dataset//activity_labels.txt", col.names=c("id", "name")) 
  for (i in 1:nrow(activities)) { 
    filtered_data$activity[filtered_data$activity == activities[i, "id"]] <- as.character(activities[i, "name"]) 
  } 
  
  feature_names <- names(filtered_data)
  
  feature_names <- gsub("\\(\\)", "", feature_names)
  feature_names <- gsub("Acc", "-Acceleration", feature_names)
  feature_names <- gsub("Mag", "-Magnitude", feature_names)
  feature_names <- gsub("^t", "\\time-", feature_names)
  feature_names <- gsub("^f", "\\frequency-", feature_names)
  feature_names <- gsub("BodyBody", "Body", feature_names)
  
  names(filtered_data) <- feature_names
  
  filtered_data
}

tidy_data <- function(filtered_data){
  tidy_data <-  tbl_df(filtered_data) %>%
    group_by(subject,  activity) %>%
    summarise_each(funs(mean)) %>%
    gather(measurement, mean, -activity, -subject)
  
  tidy_data
}