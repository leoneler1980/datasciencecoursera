## Course Project for the Getting and Cleaning Data 

To obtain the tidy.txt as a dataset result using the following R script (run_analysis.R)

is based mostly with tidyverse/dplyr verbs:


- Load the activity and feature info (to get the labels and columns names or specific features)

- Loads both the training, test and activities and subjects datasets and rename the feature columns

- merge train and test datasets into a master set

- Converts the activity column into factors

- Creates a tidy dataset with the mean  of each feature variable for each subject and activity

- Export the final dataset into a text table
