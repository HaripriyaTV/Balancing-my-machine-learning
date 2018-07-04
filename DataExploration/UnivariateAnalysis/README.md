# Data Exploration
## Univariate Analysis
### Insights from the analysis
#### Target Variable

Since the target variable is categorical(binary), it is visualized using box plot.

![target](https://user-images.githubusercontent.com/39884389/42260298-818af478-7f81-11e8-9ab6-5413c1a77e33.jpeg)

#### Observations
- The target class is **highly imbalanced**. 
- The subscription(y) has 39,922 instances of “no” as response, and 5,289 instances responded as “yes”. 
- Thus only 11.7% of the total number of customer contacted during the marketing campaign has responded positively to the promotion. 
- This imbalance will grossly affect the experimental results. Hence there is a need to balance-up the instances in the response class. 

#### Independent Categorical Variables

![combined plot 1](https://user-images.githubusercontent.com/39884389/42260672-ef65a15e-7f82-11e8-98cd-ea83e2793041.jpeg)

#### Observations

- The category of **admin, university degree holders, married marital status** and **who don't have credit in default** are **contacted 
the most**.
- **1.6%, 9.46%, 0.45%** of the total observations of job, education and marital status respectively **are unknown**. Later, they are 
**imputed using Multivariate Chained Equations(MICE)** method, as these values are missing at random.
- The total amount of "yes" response in default variable is very small (only 3 clients). Also 4.73% of total observations is unknown.
Due to the high imbalance in the response classes of default, **the missing observations** are not imputed through any means. Rather, they
are **considered as another level in the default category**.

![combined plot 2](https://user-images.githubusercontent.com/39884389/42261576-4acef948-7f86-11e8-8944-0cd67cbc1dc1.jpeg)

#### Observations

- The clients are mostly **contacted to their cell phones.** 
- The clients are **contacted** almost equally **on all working days of the week**.
- People **who don't hold any personal loan are approached the most**. This has caused an imbalance in the classes of loan variable. The 4.73%
of the total observation that is unknown, is considered to be another level in the loan category.
- The largest category, "nonexistent", of poutcome suggests that **highest number of contacts are new** and are not contacted during the previous 
campaign.
- The missing observation in housing variable is later imputed through MICE.
- Customers are **contacted the most in May and least in December**.

#### Independent Continuous Variables

![combined plot 3](https://user-images.githubusercontent.com/39884389/42262200-2bf3f5d0-7f88-11e8-9471-e218b53f0ee0.jpeg)

#### Observations

- The plot of the variable **age** tells that its **distribution is right skewed** and the measure of its skewness is 0.7846397. Doing 
a **log transformation on Age reduces its skewness** to 0.1258296. Thus the transformed variable Age can be applied on the regression model.
- The campaign plot suggests that **most of the clients are contacted atmost once**.
- The previous variable plot tells that **most of the customers were not contacted during previous campaign**.
- The **highly negative values of consumer confidence index** plot shows that, the consumer confidence index is highly at a low level.
This **can lead the customers to save more** and spend less. Due to this **there is a chance of more customers subscribing to the fixed deposit**.
- There are different distributions observed for the variables **emp.var.rate, cons.conf.ind, cons.pric.ind, nr.employees and euribor3m**. Hence these 
variables **can be binned**.
