## About the Samsung Galaxy S Data Set

The orinal dataset comprises a number of files and folders, but the ones used for this project are as follows:

1. From the parent directory (data):

  * "features.txt": Lists all the variables/features which will form the column headings (The information about the features is given in the "features_info.txt" file if required)
  
  * "activity_labels.txt": Links the class labels with their activity name


2. From the train directory (under the parent "data" directory): 

  * "X_train.txt": The trainig data set
  
  * "y_train.txt": The training labels
  
  * "subject_train": Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30


3. From the test directory (under the parent directory): 

  * "X_test.txt": The test data set
  
  * "y_test.txt": The test labels

  * "subject_test": Each row identifies the subject who performed the activity for each window sample. Its range is from 2 to 24 (these are for those subjects who do not appear in the training data set)


## The R-code

The R code is given in the "run_analysis.R" file. The whole code in the file is commented which is self-explanatory on how each line of code works and respecitive object names. In summary:

* The "dplyr" library is used to do the data mangling

* All the training, test, activity labels and subject datasets are combined together to create a complete data frame (called as "full_df" in the code)

* Features are then added to the full dataset as variable names using the make.names() function

* All columns containing "mean", "std", "subject" and "ActivityName"" names are extracted using a regex expression (called as "extract_df" in the code)

* A tidy dataframe is then created which calculates the averages of each extracted column (called as "tidy_df" in the code)

* Finally, all un-necessary dataframe objects are removed from the workspace


###Note: The final tidy dataframe is not saved as a file in the R-code
