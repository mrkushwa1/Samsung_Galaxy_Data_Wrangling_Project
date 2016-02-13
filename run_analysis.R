# load the dplyr library
suppressMessages(library(dplyr))
library(dplyr)

# remove all existing objects in the current working environment
rm(list = ls())


### Step 1: Acquire the data sets and read them into respective dataframes

# Read the "activity_lables.txt" dataset and label the columns to "ActivityLabel" and "ActivityName"
activity_df <- tbl_df(read.table("activity_labels.txt", header = FALSE, sep = " ", col.names = c("ActivityLabel", "ActivityName"), na.strings = "NA", stringsAsFactors = FALSE))

# Read the "X_test.txt" dataset
xtest_df <- tbl_df(read.table("data/test/X_test.txt", header = FALSE, na.strings = "NA", stringsAsFactors = FALSE))

# Read the "y_test.txt" dataset
ytest_df <- tbl_df(read.table("data/test/y_test.txt", header = FALSE, na.strings = "NA", stringsAsFactors = FALSE))

# Read the "X_train.txt" dataset
xtrain_df <- tbl_df(read.table("data/train/X_train.txt", header = FALSE, na.strings = "NA", stringsAsFactors = FALSE))

# Read the "y_train.txt" dataset
ytrain_df <- tbl_df(read.table("data/train/y_train.txt", header = FALSE, na.strings = "NA", stringsAsFactors = FALSE))

# Read the "subject_train.txt" dataset
strain_df <- tbl_df(read.table("data/train/subject_train.txt", header = FALSE, na.strings = "NA", stringsAsFactors = FALSE))

# Read the "subject_test.txt" dataset
stest_df <- tbl_df(read.table("data/test/subject_test.txt", header = FALSE, na.strings = "NA", stringsAsFactors = FALSE))

# Read the "features.txt" dataset
features_df <- tbl_df(read.table("data/features.txt", header = FALSE, na.strings = "NA", stringsAsFactors = FALSE))



##Step 2: Check for any "NA" values in each of the datasets

# create a dataframe 'dfs' which contains all the R dataframe objects in current workspace
dfs <- ls()[sapply(mget(ls(), .GlobalEnv), is.data.frame)]

# sum all "NA" values in 'dfs' to see how many 'NA's are present and print the result
sapply(dfs, function(x) sum(is.na(x)))



### Step 3: Merge the test, train and subject datasets

# create a new xset_df dataframe by appending xtest_df to xtrain_df by rows
xset_df <- bind_rows(xtrain_df, xtest_df)

# create a new yset_df dataframe by appending ytest_df to ytrain_df by rows
yset_df <- bind_rows(ytrain_df, ytest_df)

# create a new subject_df dataframe by appending stest_df to strain_df by rows
subject_df <- bind_rows(strain_df, stest_df)

# check for dimensions of the each dataframe in the current workspace
sapply(mget(ls(),.GlobalEnv), function(x) dim(as.data.frame(x)), USE.NAMES = TRUE)



### Step 4: Merge x, y and subject datasets

# create a new full_df dataframe by appending yset_df to xset_df by cols
full_df <- bind_cols(xset_df, yset_df)

# merge subject_df with full_df dataframe by appending subject_df by cols
full_df <- bind_cols(full_df, subject_df)

# check for dimensions of the full_df dataframe to ensure completeness
dim(full_df)



### Step 5: Adding 1 more observation to the feature_df dataset 

# create 1 new observation "ActivityLabel" to the feature_df dataframe
features_df <- features_df %>% rbind(c(562, "ActivityLabel"), c(563, "Subject"))



### Step 6: Converting the second column of the feature_df dataset into names

# convert the second column of the feature_df dataset into names and assign them as variable names to full_df
names(full_df) <- make.names(features_df$V2, unique = TRUE, allow_ = TRUE)



### Step 7: Join the activity dataframe to the full_df

# left-join activity dataframe to full_df on the ActivityLabel column
full_df <- full_df %>% left_join(activity_df, by = "ActivityLabel")

# Optional Step - move subject column to a position before ActivityLabel in the full_df dataframe 
# full_df <- full_df[c(setdiff(names(full_df), c("Subject", "ActivityLabel", "ActivityName")), c("Subject", "ActivityLabel", "ActivityName"))]

# check for dimensions of the full_df dataframe to ensure completeness
dim(full_df)



### Step 8: Extract all columns from full_df dataframe containing specific strings

# extracting all columns from full_df dataframe containing ".mean.", ".std.", ActivityLabel and ActivityName into extract_df
extract_df <- full_df %>% select(matches('(\\.mean\\.|\\.std\\.|Subject|ActivityName)', ignore.case = FALSE))

# Below will extract all clolumns that contain the word mean or std in them
# extracting all columns from full_df dataframe containing "mean", "std", ActivityLabel and ActivityName into extract_df
#extract_df <- full_df %>% select(matches('(mean|std|Subject|ActivityName)', ignore.case = FALSE))

# check dimensions of extract_df to ensure completeness
dim(extract_df)



### Step 9: Create a tidy data set from the extract_df dataframe to calculate average of each variable for each activity and each subject

# generating the tidy_df dataframe with averages for each activity and subject
tidy_df <- extract_df %>%
  group_by(ActivityName, Subject) %>%
  summarise_each(funs(mean))


# remove all un-necessary dataframes ----------------------------------------
rm(activity_df, features_df, stest_df, strain_df, subject_df, xset_df, yset_df, xtrain_df, xtest_df, ytest_df, ytrain_df, dfs)