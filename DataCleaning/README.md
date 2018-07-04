# Data Cleaning
## Treating Missing Values

Since the data is collected from phone call interviews, many clients have refused to provide their personal information due to the 
privacy issue. The existence of missing data may blur the real pattern hidden in the data thus making it more difficult to extract 
information. 

### Visualizing the missing values

![mvplot](https://user-images.githubusercontent.com/39884389/42265622-ad79a92a-7f91-11e8-8017-bfc44e4c3a71.jpeg)

In the training dataset, **there are 19.5% missing values in default, 4% missing values in education, and so on**.
Moreover **the values are missing at random**. So creating multiple imputations as compared to a single imputation 
will take care of uncertainty in missing values.

As seen from univariate analysis, **due to imbalance in classes of default and loan variables**, their **missing values** are treated as 
separate category as **"unknown"**.

The rest other missing values are imputed based on MICE(Multivariate Imputation via Chained Equations).

MICE assumes that the missing data are Missing at Random (MAR), which means that the probability that a value is missing depends only on
observed value and can be predicted using them. It imputes data on a variable by variable basis by specifying an imputation model per 
variable.

The model of imputation implemented for the variables using MICE are:
- logreg(Logistic Regression) - for housing as it contains only binary classes - "yes" and "no".
- polyreg(Bayesian polytomous regression) - for job, marital and education as they have >2 levels.

