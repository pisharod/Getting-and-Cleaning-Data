# Getting-and-Cleaning-Data
Repo for Project work on Getting and Cleaning Data
This script primarily contains run_analysis function which calls 5 functions internally
The functions are
  get_data() - this function is called to download the file and unzip the same
  merge_set() - this function is called to read the training and testing data and merge the two to get the simulation data
  filter_data() - this function will filter the simulation data to get the mean, std, subject and activity columns
  apply_descriptive_name() -this function is called with the filtered data to change the coded activity data 
                            with descriptive name. In addition the column name is made more readable by remove the function
                            paranthesis, modify acc and mag to acceleration and magnitude, to add time and frequency
                            description, to remove double body to body
  tidy_data() - this function is called get the average of each variable for each activity and subject
