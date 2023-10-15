# Telecom Churn case study

### Business problem overview
In the telecom industry, customers are able to choose from multiple service providers and actively switch from one operator to another. In this highly competitive market, the telecommunications industry experiences an average of 15-25% annual churn rate. Given the fact that it costs 5-10 times more to acquire a new customer than to retain an existing one, customer retention has now become even more important than customer acquisition.

For many incumbent operators, retaining high profitable customers is the number one business goal. To reduce customer churn, telecom companies need to predict which customers are at high risk of churn.


### Understanding the business objective and the data

The dataset contains customer-level information for a span of four consecutive months - June, July, August and September. The months are encoded as 6, 7, 8 and 9, respectively.

The business objective is to predict the churn in the last (i.e. the ninth) month using the data (features) from the first three months. To do this task well, understanding the typical customer behaviour during churn will be helpful.

### Objective

1. Model to predict whether a high-value customer will churn or not, in near future (i.e. churn phase). By knowing this, the company can take action steps such as providing special plans, discounts on recharge etc.

2. Model for identifying important features that are strong predictors of churn. These variables may also indicate why customers choose to switch to other networks. After identifying important predictors, display them in the best way to convey the importance of features.

3. Finally, recommend strategies to manage customer churn based on observations.

### Project walkthrough
1. Data quality check
Handle missing values and data type, remove unnecessary variables
2. Identify churners among high value customers
Identify high value customers (recharge amount > 70th percentile) and tag churners based on the lack of usage in the 4th month
3. EDA
Identify outliers, trend in usage over time, correlation between features
4. Derive additional features for identifying churners
Change in net usage, change in usage percentage
Non-linear transform data to reduce extreme values/outliers
5. Data processing for modelling
Split the data, apply feature scaling
Perform PCA and identify the number of PCs for model building
6. Model for predicting churners
- Handling data imbalance with SMOTE, ADASYN
- Try out various models: Logistic regression, Random forest, AdaBoost, XGBoost.
- Hyperparameter tuning and adjusting optimal threshold using precision/recall curve
7. Model for identifying important features
Build and tuning models for identifying important features
8. Business recommendation
Present findings: Signs of churners, reasons for churning and strategies for managing churning
