##Getting And Cleaning Data Course Project readme file 

####The purpose of this file is to provide step-by-step instructions on how to the run_analysis.R script work so an exact copy of the data set Average Human Activity Recognition Using Smartphones can be recreated.

*1. Launch RStudio
*2. Open the file run_analysis.R
*3. Clear all variables from memory using the rm(list=ls(all=TRUE)) command
*4. Set the working directory
*5. Create the project directory
*6. Download the dataset from the web and unzip the files
*7. Review the file list manifest
*8. Load the features labels data set
*9. Load the y-test(Activity) data set
*10. Load the y-train (Activity) data set
*11. Load the SQLDF library
*12. Merge the y-test and y-train data set using SQLDF
*13. Load the x-test(Features) data set
*14. Load the x-train(Features) data set
*15. Merge the x-traing and x-test data sets using SQLDF
*16. Load the subject-test data set
*17. Load the subject-train data set
*18. Merge the subject-test and subject-train data sets using SQLDF
*19. Add names to the variables in each data set (subject, activity, features)
*20. Merge the training and test data sets to create a single dataset
*21. Extracts only the measurements on the mean and standard deviation for each measurement
*22. Use descriptive activity names to replace the activity identification numbers in the new data set (averages and standard diviation) as well as the original data set
*23. Appropriately label the data set with descriptive variable names in the new data set (averages and standard diviation) as well as the original data set
*24. Create a second data frame by copying the HARUS_mean_std into the HARUS_2 data frame
*25. Load the DPLYR library
*26. Load the HARUS_2 data frame into the HARUS2 data frame using the tbl_df function
*27. Group by the HARUS2 data frame by subject and activity and assign the results to the harus2_by_subject_and_activity data frame
*28. Calculate the average of each variables in the harus2_by_subject_and_activity data frame by using the summarise_each function; assign the results to the harus2_averages data frame
*29. store the harus2_averages data frame into a text file using the write.table function. Remember to ommit the row names by using the row.names=FALSE argument in the write.table function.

