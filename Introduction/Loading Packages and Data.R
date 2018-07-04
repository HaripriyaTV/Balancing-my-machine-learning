#loading required package
library(data.table) #for loading data
library(dplyr) #for data manipulation
library(ggplot2) #for data visualization
library(cowplot) #for plotting
library(corrplot) #for visualizing correlation matrix
library(VIM) #for visualization of missing values
library(mice) #for imputation of missing values
library(caret) #for modelling
library(vcd) #for visualizing categorical data
library(GoodmanKruskal) #for association analysis of categorical variables
library(DMwR) #for data mining
library(ROCR) #for visualizing performance measures
library(pROC) #to analyze roc curves
library(xgboost) #to model xgboost algorithm
library(e1071) #to model svm

#reading data
bank_marketing_data <- fread("bank.csv")
test_bank_data <- fread("bank-additional.csv")

#checking the data
dim(bank_marketing_data)
str(bank_marketing_data)
names(bank_marketing_data)

dim(test_bank_data)
str(test_bank_data)
names(test_bank_data)

#there is no pdays variable in the test data
#so pdays is removed from the bank_marketing_data
bank_marketing_data$pdays <- NULL

#removing duration variable from both the data sets
##reason: from the data source website -  the duration is not known before a call is performed. Also, after the end of the call y is obviously known. Thus, this input should only be included for benchmark purposes and should be discarded if the intention is to have a realistic predictive model.
#other attributes:
bank_marketing_data$duration <- NULL
test_bank_data$duration <- NULL