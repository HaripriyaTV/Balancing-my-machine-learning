#data manipulation

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
