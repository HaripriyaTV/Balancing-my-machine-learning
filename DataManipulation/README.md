# Data Manipulation
**_Feature Engineering - Feature Selection - Resampling the data_**

## Feature Engineering
The following new features which might help improving the model performance are created based on each numeric variable's different 
distribution except age, as observed from the data exploration analyses.

| Continuous Variable | Variable Notes | Categorization Notes | Categorized Variable |
| ------------------- | -------------- | -------------------- | -------------------- |
| campaign | > 97% of data in lowest 10 levels for both response levels | Ordinal into {1,2,3,>3) | campaign_clusters |
| previous | >68% of data in lowest level for both response levels | Binary into {‘contacted before’ and ‘never contacted’} | previous_binary |
| emp.var.rate | Per bar chart, natural grouping seems to be {<=- 1.8, (-1.8 to -0.1], > -0.1} for both response levels | Ordinal into {<=-1.8, (-1.8 to -0.1], > -0.1} | emp_var_rate_grp |
| cons.price.idx | Data is highly multi-modal. Bucket binning is used since data has even spread through the range of the histogram | Ordinally Bucketed into three bins | cons_price_idx_bin |
| cons.conf.idx | Data is highly multi-modal. Quantile binning is used since data has does not have even spread through histogram | Ordinally binned into 5 categories based on Quantile | cons_conf_idx_bins |
| euribor3m | Data is highly multi-modal. Quantile binning is used since data has does not have even spread through histogram | Ordinally Quantile binned into 5 categories | euribor3m_bins |
| nr.employed | Data is highly multi-modal. Quantile binning is used since data has does not have even spread through histogram | Ordinally Quantile binned into 3 categories | nr_employed_bin |

## Feature Selection
In the train dataset, the **correlation among features was checked** in order to determine the most relevant features and reduce redundancy in 
the data for further analysis.

The **collinearity among numerical variables is tested using Pearson Correlation Coefficient**. The plot of the correlation matrix of the numeric 
features is given below.

![numeric corr plt](https://user-images.githubusercontent.com/39884389/42271018-ee9b5562-7f9f-11e8-9659-ed0abc49bbbd.jpeg)

euribor3m is the variable that is highly collinear with other variables. So **euribor3m is removed**.

The **association among categorical variables is tested using GoodmanKruskal R package**. The plot of association of the categorical variables
can be found below.

![cat corr](https://user-images.githubusercontent.com/39884389/42271377-cb192906-7fa0-11e8-87cf-b1a02541550d.jpeg)

It can be seen that **poutcome and previous_binary are highly associated** as both of them convey details from the previous campaign. But 
**removing any of them can cause a loss of important information from the previous campaign**. So they are not removed.

But euribor3m_bins seem to have an **association measure of 0.79** with nr.employed_bin. So **euribor3m_bins is removed**.

Besides, **pout variable** is removed from the data as it is not contained in the test set.

Also, **duration variable is removed**. The reason is, duration is not known before a call is performed. Also, after the end of the call y is obviously known. 
So it should be discarded as the intention is to have a realistic predictive model.

## Resampling the data

The presence of imbalanced data may distort the algorithm and its predicting performance. The responses in the training data are 90% 
“no” and 10% “yes”, which is significantly an imbalanced dataset. The solution to deal with this problem can be divided into two parts.

**_1. Changing the way of measuring algorithm’s performance_** -  the **test accuracy rate can not be simply used** here because the model
will tend to fit the majority class better to improve the overall accuracy. However, the model is preferred to be more successful in 
identifying people who will subscribe a term deposit than the overall power of prediction. Therefore, **ROC (Receiver Operating
Characteristic) curve, AUC (Area Under Curve ) and F1 measure** are used for **performance measurement**.

**_2. Changing the dataset using resampling method_** - The resampling methods used here are **oversampling**
(sample with replacement from the group with less data until the number equals to the larger group), **undersampling**
(sample with replacement from the group with more data until the number equals to the lesser group) and **SMOTE** 
(Synthetic Minority Oversampling Technique). Since, **oversampling resulted in the ratio 0.5 : 0.5 of the response classes**, 
the data resampled through oversampling is considered for further modelling.

 
 
