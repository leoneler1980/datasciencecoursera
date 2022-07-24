library(tidyverse)


## get dataset and unzip

setwd("course_getting_data_and_cleaning_project")

  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  

    if (!file.exists("datazipped.zip")){
  
    download.file(URL, "datazipped.zip")
  
    unzip("datazipped.zip")
  }

  
  
# Load labels and features

activityLabels <- read_table("UCI HAR Dataset/activity_labels.txt", col_names =  F) %>% 
  pull(X1, X2)

labels <- read_table("UCI HAR Dataset/activity_labels.txt", col_names = F)

features <- read_table("UCI HAR Dataset/features.txt", col_names = F)


# Extract only the columns with the data ofmean and standard deviation

target_features_names <- features %>% 
filter(str_detect(X2, "mean")|str_detect(X2, "std")) %>% 
  pull(X2)

id_target_features <- features %>% 
  filter(str_detect(X2, "mean")|str_detect(X2, "std")) %>%
 pull(X1)


# Load the datasets and rename columns
train_data <- read_table("UCI HAR Dataset/train/X_train.txt", col_names = F) %>% 
  select(all_of(id_target_features)) %>% 
  setNames(target_features_names)

train_activities <- read_table("UCI HAR Dataset/train/Y_train.txt", col_names = F)

train_subjects <- read_table("UCI HAR Dataset/train/subject_train.txt", col_names=F)

train_master <- bind_cols(train_subjects, train_activities, train_data) %>% 
  select(subject=1, activity_id=2, everything()) %>% 
  mutate(activity=factor(activity_id, levels = activityLabels, labels = names(activityLabels)),
         db="train") %>% 
  select(db, subject, activity_id, activity, everything())
         
test_data <- read_table("UCI HAR Dataset/test/X_test.txt", col_names = F) %>% 
  select(all_of(id_target_features)) %>% 
  setNames(target_features_names)

test_activities <- read_table("UCI HAR Dataset/test/Y_test.txt", col_names = F)

test_subjects <- read_table("UCI HAR Dataset/test/subject_test.txt", col_names = F)

test_master <- bind_cols(test_subjects, test_activities, test_data) %>% 
  select(subject=1, activity_id=2, everything()) %>% 
  mutate(activity=factor(activity_id, levels = activityLabels, labels = names(activityLabels)),
         db="test") %>% 
  select(db, subject, activity_id, activity, everything())
  
# merge datasets and make it tidy
master_data <- bind_rows(train_master, test_master)

master_tidy <- master_data %>% 
  pivot_longer(5:ncol(.), names_to = "measurement", values_to = "value") %>% 
  group_by(subject, activity, measurement) %>% 
  summarise(mean_val=mean(value))

master_mean <- master_data %>% 
  group_by(subject, activity) %>% 
  summarise(across(where(is.numeric), mean, na.rm=T), .groups = "drop")

#export dataset
write.table(master_mean, "tidy.txt", row.names = FALSE, quote = FALSE)

