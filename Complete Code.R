
#loading required packages
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

##############################################################################


#Data Exploration

#univariate analysis

#visualizing the target variable
p1 <- ggplot(bank_marketing_data %>% group_by(y) %>% summarise(Count = n())) +
  geom_bar(aes(y, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(y, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  ggtitle("Term Deposit Subscription")

p1
#the target variable is highly imbalanced

#visualizing the categorical variable
#plot for job
p2 <- ggplot(bank_marketing_data %>% group_by(job) %>% summarise(Count = n())) +
  geom_bar(aes(job, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(job, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Type of Job")
p2

#plot for marital
p3 <- ggplot(bank_marketing_data %>% group_by(marital) %>% summarise(Count = n())) +
  geom_bar(aes(marital, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(marital, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Marital Status")
p3

#plot for education
p4 <- ggplot(bank_marketing_data %>% group_by(education) %>% summarise(Count = n())) +
  geom_bar(aes(education, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(education, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Education")
p4

#plot for default
p5 <- ggplot(bank_marketing_data %>% group_by(default) %>% summarise(Count = n())) +
  geom_bar(aes(default, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(default, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Credit in default")
p5

#plot for housing
p6 <- ggplot(bank_marketing_data %>% group_by(housing) %>% summarise(Count = n())) +
  geom_bar(aes(housing, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(housing, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  ggtitle("Possessing Housing Loan")
p6


#plot for loan
p7 <- ggplot(bank_marketing_data %>% group_by(loan) %>% summarise(Count = n())) +
  geom_bar(aes(loan, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(loan, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  ggtitle("Possessing Personal Loan")
p7

#plot for contact
p8 <- ggplot(bank_marketing_data %>% group_by(contact) %>% summarise(Count = n())) +
  geom_bar(aes(contact, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(contact, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  ggtitle("Contact Communication Type")
p8

#plot for month
p9 <- ggplot(bank_marketing_data %>% group_by(month) %>% summarise(Count = n())) +
  geom_bar(aes(month, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(month, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  ggtitle("Last Contacted Month")
p9

#plot for day
p10 <- ggplot(bank_marketing_data %>% group_by(day_of_week) %>% summarise(Count = n())) +
  geom_bar(aes(day_of_week, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(day_of_week, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  ggtitle("Last Contacted Day")
p10

#plot for poutcome
p11 <- ggplot(bank_marketing_data %>% group_by(poutcome) %>% summarise(Count = n())) +
  geom_bar(aes(poutcome, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(poutcome, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  ggtitle("Outcome of Previous Campaign")
p11

#combining the above plots
forth_row <- plot_grid(p10, p11, p9, nrow = 1)
third_row <- plot_grid(p8, p7, p6, nrow = 1)
second_row <- plot_grid(p5, p4, p3, nrow = 1)
first_row <- p2
combined_plot_1 <- plot_grid(p2, second_row, ncol = 1)
combined_plot_2 <- plot_grid(third_row, forth_row, ncol = 1)
combined_plot_1
combined_plot_2

#visualizing numeric data

#plot of age
p12 <- ggplot(bank_marketing_data) + geom_histogram(aes(bank_marketing_data$age),
                binwidth = 0.5, fill = "palegreen3") + xlab ("Age")
p12

#plot for campaign
p13 <- ggplot(bank_marketing_data) + geom_histogram(aes(bank_marketing_data$campaign),
                binwidth = 1.5, fill = "palegreen3") + xlab ("Campaign")
p13

#plot for previous
p14 <- ggplot(bank_marketing_data) + geom_histogram(aes(bank_marketing_data$previous),
                binwidth = 0.5, fill = "palegreen3") + xlab ("Previous")
p14

#plot for emp.var.rate
p15 <- ggplot(bank_marketing_data) + geom_histogram(aes(bank_marketing_data$emp.var.rate),
                binwidth = 0.2, fill = "palegreen3") + xlab ("Employment Variation Rate")
p15

#plot for cons.pric.index
p16 <- ggplot(bank_marketing_data) + geom_histogram(aes(bank_marketing_data$cons.price.idx),
                binwidth = 0.1, fill = "palegreen3") + xlab ("Consumer Price Index")
p16

#plot for cons.conf.index
p17 <- ggplot(bank_marketing_data) + geom_histogram(aes(bank_marketing_data$cons.conf.idx),
                binwidth = 0.5, fill = "palegreen3") + xlab ("Consumer Confidence Index")
p17

#plot for euribor3m
p18 <- ggplot(bank_marketing_data) + geom_histogram(aes(bank_marketing_data$euribor3m),
                binwidth = 0.5, fill = "palegreen3") + xlab ("Euribor 3 months")
p18

#plot for nr.employed
p19 <- ggplot(bank_marketing_data) + geom_histogram(aes(bank_marketing_data$nr.employed),
                binwidth = 10, fill = "palegreen3") + xlab ("Number of Employees")
p19

#combining the plots
forth_row_1 <- plot_grid(p19, p18, nrow = 1)
third_row_1 <- plot_grid(p17, p16, nrow = 1)
second_row_1 <- plot_grid(p15, p14, nrow = 1)
first_row_1 <- plot_grid(p13, p12, nrow = 1)
combine_plot_3 <- plot_grid(first_row_1, second_row_1, third_row_1, forth_row_1, ncol = 1)
combine_plot_3

###########################################################################################
#data exploration

#bivariate analysis

#Target variable Vs independent categorical variables
bank_train_corr <- cor(bank_marketing_data())
corrplot(BM_train_corr, method = "pie", type = "lower", tl.cex = 0.9)

b1 <- chisq.test(bank_marketing_data$job, bank_marketing_data$y)
plot_b1 <- corrplot(b1$residuals, is.corr = FALSE, title = "Job Vs y", mar=c(0,0,1,0))

b2 <- chisq.test(bank_marketing_data$marital, bank_marketing_data$y)
plot_b2 <- corrplot(b2$residuals, is.corr = FALSE, title = "Marital Vs y", mar=c(0,0,1,0))

b3 <- chisq.test(bank_marketing_data$education, bank_marketing_data$y)
plot_b3 <- corrplot(b3$residuals, is.corr = FALSE, title = "Education Vs y", mar=c(0,0,1,0))

b4 <- chisq.test(bank_marketing_data$default, bank_marketing_data$y)
plot_b4 <- corrplot(b4$residuals, is.corr = FALSE, title = "Default Vs y", mar=c(0,0,1,0))

b5 <- chisq.test(bank_marketing_data$housing, bank_marketing_data$y)
plot_b5 <- corrplot(b5$residuals, is.corr = FALSE, title = "Housing Loan Vs y", mar=c(0,0,1,0))

b6 <- chisq.test(bank_marketing_data$loan, bank_marketing_data$y)
plot_b6 <- corrplot(b6$residuals, is.corr = FALSE, title = "Personal Loan Vs y", mar=c(0,0,1,0))

b7 <- chisq.test(bank_marketing_data$contact, bank_marketing_data$y)
plot_b7 <- corrplot(b7$residuals, is.corr = FALSE, title = "Contact Vs y", mar=c(0,0,1,0))

b8 <- chisq.test(bank_marketing_data$month, bank_marketing_data$y)
plot_b8 <- corrplot(b8$residuals, is.corr = FALSE, title = "Month Vs y", mar=c(0,0,1,0))

b9 <- chisq.test(bank_marketing_data$day_of_week, bank_marketing_data$y)
plot_b9 <- corrplot(b9$residuals, is.corr = FALSE, "day_of_week Vs y", mar=c(0,0,1,0))

b10 <- chisq.test(bank_marketing_data$poutcome, bank_marketing_data$y)
plot_b10 <- corrplot(b10$residuals, is.corr = FALSE, title = "poutcome Vs y", mar=c(0,0,1,0))

#Target variable Vs independent numerical variables
b11 <- ggplot(bank_marketing_data, aes(factor(y), age)) + geom_boxplot(aes(fill = factor(y)))
b11

b12 <- ggplot(bank_marketing_data, aes(factor(y), campaign)) + geom_boxplot(aes(fill = factor(y)))
b12

b13 <- ggplot(bank_marketing_data, aes(factor(y), cons.conf.idx)) + geom_boxplot(aes(fill = factor(y)))
b13

b14 <- ggplot(bank_marketing_data, aes(factor(y), cons.price.idx)) + geom_boxplot(aes(fill = factor(y)))
b14

b15 <- ggplot(bank_marketing_data, aes(factor(y), emp.var.rate)) + geom_boxplot(aes(fill = factor(y)))
b15

b16 <- ggplot(bank_marketing_data, aes(factor(y), euribor3m)) + geom_boxplot(aes(fill = factor(y)))
b16

b17 <- ggplot(bank_marketing_data, aes(factor(y), nr.employed)) + geom_boxplot(aes(fill = factor(y)))
b17

b18 <- ggplot(bank_marketing_data, aes(factor(y), previous)) + geom_boxplot(aes(fill = factor(y)))
b18

#combining the above plots

row_4 <- plot_grid(b18, b17, nrow = 1)
row_3 <- plot_grid(b16, b15, nrow = 1)
row_2 <- plot_grid(b14, b13, nrow = 1)
row_1 <- plot_grid(b12, b11, nrow = 1)
combined_plot_4 <- plot_grid(row_1, row_2, row_3, row_4, ncol = 1) 
combined_plot_4

#######################################################################################################

#data preparation

#missing value treatment

#replacing the blanks with NA
is.na(bank_marketing_data) <- bank_marketing_data == ''

#visualizing the missing values
mv_plot <- aggr(bank_marketing_data, col=c('steelblue','khaki2'), numbers=TRUE, prop=FALSE,
                  sortVars=TRUE, labels=names(bank_marketing_data), cex.axis=0.7, gap=1,
                  varheight = FALSE,combined = FALSE,cex.numbers =0.5, 
                  ylab=c("Histogram of missing data","Pattern"))

#imputation by mice
#converting the variables into factors
bank_marketing_data <- bank_marketing_data %>%
  mutate(
    job = as.factor(job),
    marital = as.factor(marital),
    education = as.factor(education),
    housing = as.factor(housing)
  )

init = mice(bank_marketing_data, maxit=0) 
meth = init$method
predM = init$predictorMatrix

#specifying the suitable methods for each variable
meth[c("loan")]="logreg" 
meth[c("job", "marital", "education")]="polyreg"

#running multiple imputation
imputed_data = mice(bank_marketing_data, method=meth, predictorMatrix=predM, m=5)
imputed_data <- complete(imputed_data)
colSums(is.na(imputed_data))

#replacing the na's in default and loan as unknown
imputed_data$default[is.na(imputed_data$default)] <- "unknown"
imputed_data$loan[is.na(imputed_data$loan)] <- "unknown"
colSums(is.na(imputed_data))

################################################################################

#feature engineering

#combining both train and test set for observation
test_bank_data[, y := NA]
bank_data_combined <- rbind(imputed_data, test_bank_data, fill = TRUE)
tail(bank_data_combined)
head(bank_data_combined)
colSums(is.na(bank_data_combined))

#clustering campaign into fours bins 
bank_data_combined[,campaign_clusters := ifelse(campaign == 1, "1st", 
                                                ifelse(campaign == 2, "2nd",
                                                      ifelse(campaign == 3 & campaign >= 3, "3rd", "4th")))]

#binning previous into binary variable
bank_data_combined[, previous_binary := ifelse(previous == 0, "never_contacted", "contacted_before")]

#grouping emp_var_rate
bank_data_combined[,emp_var_rate_grp := ifelse(emp.var.rate <= -1.8, "1st", 
                                   ifelse(emp.var.rate >-1.8 & emp.var.rate <= -0.1, "2nd", "3rd"))]
                                          
#bucket binning of cons_pric_ind
bank_data_combined[,cons_pric_ind_bin := ifelse(cons.price.idx < 93.056333333, "1st", 
                                               ifelse(cons.price.idx >= 93.056333333 & cons.price.idx < 93.9110666667, "2nd", "3rd"))]


#quantile binning of cons_conf_ind
bank_data_combined[,cons.conf.idx_bins := ifelse(cons.conf.idx < -46.19925, "1st",
                                            ifelse(cons.conf.idx >= -46.19925 & cons.conf.idx < -41.99763, "2nd",
                                                   ifelse(cons.conf.idx >= -41.99763 & cons.conf.idx < -39.99959, "3rd",
                                                          ifelse(cons.conf.idx >= -39.99959 & cons.conf.idx < -36.39786,  "4th", "5th"))))]
                                                

#quantile binning of euribor3m
bank_data_combined[,euribor3m_bins := ifelse(euribor3m < 1.2991788, "1st",
                                                 ifelse(euribor3m >= 1.2991788 & euribor3m < 4.1910304, "2nd",
                                                        ifelse(euribor3m >= 4.1910304 & euribor3m < 4.864149, "3rd",
                                                               ifelse(euribor3m >= 4.864149 & euribor3m < 4.9620732,  "4th", "5th"))))]

#quantile binning of nr.employed
bank_data_combined[,nr.employed_bin := ifelse(nr.employed < 5099.10335, "1st", 
                                                ifelse(nr.employed >= 5099.10335 & nr.employed < 5191.0171, "2nd", "3rd"))]

colnames(bank_data_combined)


########################################################################################################################################

#feature selection

#identifying highly correlated features among numerical variables using caret r package

#to ensure results are repeatable
set.seed(149)
#calculating the correlation matrix among numerical variables
colnames(bank_data_combined)
correlation_matrix <- cor(bank_data_combined[,c(1, 11, 12, 14:18)])
correlation_matrix
corrplot(correlation_matrix, type = "lower")

#identifying highly correlated features among categorical variables using GoodmanKruskal r package
vars <- c("job", "marital", "education", "default", "housing", "loan", "contact", "month",
          "day_of_week", "poutcome", "campaign_clusters", "previous_binary",
          "emp_var_rate_grp", "cons_pric_ind_bin", "cons.conf.idx_bins",
          "euribor3m_bins", "nr.employed_bin")
data_wit_catvars <- subset(bank_data_combined, select = vars)
cat_corr_matrix <- GKtauDataframe(data_wit_catvars)
plot(cat_corr_matrix)

#removing euribor3m_bins and euribor3m from the data due to their high correlation
bank_data_combined[, c("euribor3m", "euribor3m_bins")] <- NULL
View(bank_data_combined)

#####################################################################################################################################

#balancing the data

#splitting combined data back to train and test
train_data <- bank_data_combined[1:nrow(bank_marketing_data)]
test_data <- bank_data_combined[(nrow(train_data) + 1) : nrow(bank_data_combined)]

#further splitting of train data into validation set
train_data_split <- sample(2, nrow(train_data), replace =TRUE, prob = c(0.75, 0.25))
new_train_data <- train_data[train_data_split == 1,]
valid_data <- train_data[train_data_split == 2,]

#original proportion of the target class in the train data
prop.table(table(new_train_data$y))# yes - 0.1121559, no - 0.8878441;

#down sampling the train data
set.seed(178)
down_train_data <- downSample(x = new_train_data[, -18],
                              y = new_train_data$y)

#checking the proportion the target class after down sampling
prop.table(table(down_train_data$Class)) #yes 0.5, no-0.5;

#upsampling the train data
up_train_data <- upSample(x = new_train_data[, -18],
                          y = new_train_data$y)

#checking the proportion of the target class after up sampling
prop.table(table(up_train_data$Class)) #yes - 0.5, no - 0.5;

#smote training the train data
smote_train_data <- SMOTE(y ~ ., new_train_data)

#checking the proportion of target class after smoting
prop.table(table(smote_train_data$y)) #yes - 0.5714 , no - 0.4286;

#choosing the upsampled data

#######################################################################################

#model building

#logistic regression
glm_model <- glm(Class ~ ., family = binomial(link = "logit"), data = up_train_data)
summary(glm_model)

#running ANOVA chisq test to check the overall effect of variables on the target variable
anova(glm_model, test = 'Chisq')

#prediction on unseen data using the trained glm_model
glm_pred <- predict(glm_model, valid_data, type = "response")
#setting the probability threshol to 0.5 for now
glm_pred <- ifelse(glm_pred > 0.5, 1, 0)

#using AUC-ROC score to determine model fit
pred_glm <- prediction(glm_pred, valid_data$y)
perf_glm <- performance(pred_glm, measure = "tpr", x.measure = "fpr")
plot(perf_glm)
auc(valid_data$y, glm_pred)#0.7521
#the plot shows the model is predicting more negative values correctly

#interpreting the threshold value to be 0.6 and checking model performance
glm_response <- predict(glm_model, valid_data, type = "response")
glm_response <- ifelse(glm_response >0.6, 1, 0)

#determining the model fit
pred_glm <- prediction(glm_response, valid_data$y)
perf_glm <- performance(pred_glm, measure = "tpr", x.measure = "fpr")
plot(perf_glm)
auc(valid_data$y, glm_response)#0.7531

#obtaining the other measures

#user_defined function for fmeasure
measure_fscore <- function(predict, actual_labels){
  precision <- sum(predict & actual_labels) / sum(predict)
  recall <- sum(predict & actual_labels) / sum(actual_labels)
  fmeasure <- 2 * precision * recall / (precision + recall)
  
  cat('f-measure:  ')
  cat(fmeasure)
  
}

valid_data$y = ifelse(valid_data$y == "no", 0, 1)
measure_fscore(glm_response, valid_data$y)#0.2263791

#evaluating the true negative rate
perf_glm1 <- performance(pred_glm, measure = "spec", x.measure = "cutoff")
perf_glm1@y.values[[1]][2]#0.9242641



#####################################################################################

#model building 

#random forest

#creating model using default parameters
control <- trainControl(method="repeatedcv", number=5, repeats=1)
seed <- 7
metric <- "auc"
set.seed(seed)
mtry <- sqrt(ncol(up_train_data))
tunegrid <- expand.grid(.mtry=mtry)
rf_default <- train(Class~., data=up_train_data, method="rf", metric=metric, tuneGrid=tunegrid, trControl=control)
print(rf_default)
#accuracy - 0.7956838

##prediction on unseen data using the trained rf_default model
rf_response <- predict(rf_default, valid_data, type = "prob")
rf_response <- rf_response[,2]
#setting the probability threshol to 0.5 for now
#rf_response <- ifelse(rf_default > 0.5, 1, 0)

#using AUC-ROC score to determine model fit
pred_rf <- prediction(rf_response, valid_data$y)
perf_rf <- performance(pred_rf, measure = "tpr", x.measure = "fpr")
plot(perf_rf)
auc(valid_data$y, rf_response)#0.7964

#obtaining fscore
valid_data$y = ifelse(valid_data$y == "no", 0, 1)
measure_fscore(rf_response, valid_data$y)#0.6703518

#evaluating the true negative rate
perf_rf1 <- performance(pred_rf, measure = "spec", x.measure = "cutoff")
perf_rf1@y.values[[1]][2]#0.9994488

plot(varImp(rf_default))

###################################################################################

#model building

#xgboost

#encoding the categorical variables using one hot encoding
#one hot encoding of remaining categorical variables
train_ohe = dummyVars("~.", data = up_train_data[,], fullRank = T)
train_ohe_df = data.table(predict(train_ohe, up_train_data[,]))

valid_ohe = dummyVars("~.", data = valid_data[,], fullRank = T)
valid_ohe_df = data.table(predict(valid_ohe, valid_data[,]))

#creating parameter list
param_list = list(
  objective = "binary:logistic",
  eta=0.1,
  gamma = 1,
  max_depth=6,
  subsample=0.8,
  colsample_bytree=0.5
)

colnames(train_ohe_df)
colnames(valid_ohe_df)

#converting the data frame into Dmatrix
dtrain = xgb.DMatrix(data = as.matrix(train_ohe_df[,-ncol(train_ohe_df)]), label= train_ohe_df$Class.yes)
dvalid = xgb.DMatrix(data = as.matrix(valid_ohe_df))

#calculationg the nround for the model
xgbcv <- xgb.cv( params = param_list, data = dtrain, nrounds = 100, nfold = 3, 
                 showsd = T, stratified = T, print_every_n = 10, 
                 early_stop_round = 20, maximize = F)
#best iteration - [51]

#finding cv error
min(xgbcv$evaluation_log)

#building the model
xgb_model <- xgb.train (params = param_list, data = dtrain,
                       nrounds = 51,maximize = F , eval_metric = "error")

summary(xgb_model)

#prediction on unseen data using the trained model
xgb_response <- predict(xgb_model, dvalid)
View(xgb_response)

#using AUC-ROC score to determine model fit
pred_xgb <- prediction(xgb_response, valid_data$y)
perf_xgb <- performance(pred_xgb, measure = "tpr", x.measure = "fpr")
plot(perf_xgb)
auc(valid_data$y, xgb_response)#0.5766

#obtaining fscore
valid_data$y = ifelse(valid_data$y == "no", 0, 1)
measure_fscore(xgb_response, valid_data$y)#1.155165

#evaluating the true negative rate
perf_xgb <- performance(pred_xgb, measure = "spec", x.measure = "cutoff")
perf_xgb@y.values[[1]][2]#0.9994488

#viewing variable importance plot
mat <- xgb.importance (feature_names = colnames(up_train_data[,-ncol(up_train_data)]),model = xgb_model)
xgb.plot.importance (importance_matrix = mat[1:20]) 

#########################################################################################################

#model building

#support vector machines
#building model: radial kernel, default parameters
svm_model <- svm(Class~ ., data=up_train_data, method="C-classification", kernel="radial")

#prediction on unseen data using the trained model
svm_response <- predict(svm_model, valid_data, probability = TRUE)
View(svm_response)

#using AUC-ROC score to determine model fit
pred_svm <- prediction(svm_response, valid_data$y)
perf_svm <- performance(pred_svm, measure = "tpr", x.measure = "fpr")
plot(perf_svm)
auc(valid_data$y, svm_response)#0.7834

#obtaining fscore
valid_data$y = ifelse(valid_data$y == "no", 0, 1)
measure_fscore(svm_response, valid_data$y)#0.6512

#evaluating the true negative rate
perf_svm1 <- performance(pred_svm, measure = "spec", x.measure = "cutoff")
perf_svm1@y.values[[1]][2]#0.9992268

################################################################################

#prediction
#random forest has performed well than other algorithms
#predicting the test data using random forest

test_pred <- predict(rf_default, test_data, type = "prob")
write.csv(test_pred, "prediction_result.csv")
