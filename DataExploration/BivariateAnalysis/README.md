# Data Exploration
## Bivariate Analysis
### Target Variable Vs Independent Categorical Variables

![corr1](https://user-images.githubusercontent.com/39884389/42263471-bbc7af5a-7f8b-11e8-97db-7dbdc1e6040d.jpg)

#### Observations
- Retired people, students, university degree holders and single people are more likely to subscribe to a term deposit.
- People who do not have a credit in default are slightly likely to subscribe.
- blue-collar and married people are not likely to subscribe.
- The missing values in default and education do have great impact on the subscription.

![corr2](https://user-images.githubusercontent.com/39884389/42263829-c42c357a-7f8c-11e8-9a55-e448587a39b0.jpg)

#### Observations
- Customers possessing a housing loan are neutral to the subscription.
- Customers possessing personal loan don't tend to subscribe.
- Communication made through cellphones has given the most subscription.
- March and October contacted months have given high subscriptions.

### Target Variable Vs Independent Numeric Variables

![y vs numerics](https://user-images.githubusercontent.com/39884389/42264210-9fd389de-7f8d-11e8-84b0-88b40acb4850.jpeg)

#### Observations
- It is seen that the box plots except for age and campaign, show obvious differences between the classes of subscription.
- The median of "yes" is higher with respect to con.conf.inx and previous.
- age, campaign and previous suffer from outliers. This is most likely to be call-drops for clients who failed to pick their phones while
being contacted during the campaign. Since not responding to calls is an important factor to be considered, these outliers are 
not removed.
- The median of non-subscribing is higher with respect to cons.pric.inx, euribor3m, emp.var.rate and nr.employees.
