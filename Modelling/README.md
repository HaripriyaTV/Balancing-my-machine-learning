# Model Building

The train dataset was segmented into two separate datasets – a training dataset and a validation dataset using a 75:25 ratio. 
The split between training and validation datasets was done randomly. The training set was used to fit the following predictive models.

- Logistic Regression
- Support Vector Machine (SVM)
- Random Forest
- XGBoost

These models were designed to predict the subscription variable y. Having built the above models, the validation dataset was then used
to estimate the prediction error associated with each model. The evaluation metric chosen was **Area Under the Curve (AUC) and F1 measure**.
The AUC and F1 measure values form the basis for selecting the preferred model.

The AUC and F1 measure values obtained for each of the model is,

| Model | AUC | F1 measure |
| ----- | --- | ---------- |
| Logistic Regression | 0.7531 | 0.2263 |
| SVM | 0.7834 | 0.6512 |
| Random Forest | 0.7964 | 0.6703 |
| XGBoost | 0.5766 | 1.1551 |

The F1 measure of XGBoost seems to give the greatest balance between precision and recall than other models. But its AUC value is the least.
This can lead to an increase of false positives.

But random forest have a high AUC value and its F1 measure is comparitively high than the first two models. 

Hence Random Forest is chosen for predicting the subscription variable y upon test data set.
