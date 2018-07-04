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

test_data <- read.csv("test_data.csv")
View(test_data)
test_data$X <- NULL

test_pred <- predict(rf_default, test_data, type = "prob")
write.csv(test_pred, "prediction_result.csv")
