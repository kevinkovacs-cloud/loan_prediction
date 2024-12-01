# Mortgage Approval Modeling
Class: Data Fundamentals

This repository contains all the materials and analysis for a class on Data Fundamentals. It explores the development of predictive models for mortgage approvals using the hipoteca.xls dataset. Key methodologies include:

Data preprocessing and exploration.
Logistic regression (with variable selection and performance evaluation).
Alternative classification models like Naive Bayes and SVM.
Model evaluation using metrics such as AUC, ROC curves, and classification tables.
The repository includes:

Detailed Jupyter notebooks for step-by-step analysis.
Documentation on methodology and results.

- Problem:
The dataset hipoteca.xls contains information on 2,380 individuals who applied for a mortgage. The target variable is “deny”, an indicator of whether the applicant’s mortgage request was approved (deny = 0) or denied (deny = 1). The dataset provides information on the following variables:

- pirat: Ratio of the individual’s expenses to income.
- hirat: Ratio of the household’s expenses to income.
- lvrat: Loan-to-value ratio of the mortgaged asset.
- Unemp: Unemployment rate in the applicant’s industry.
- mhist: Mortgage credit score (1 to 4; lower scores indicate better credit).
- Phist: Indicator: Does the applicant have a bad public credit history?
- Insurance: Indicator: Was the applicant denied insurance?
- Single: Indicator: Is the applicant single?
- Selfemp: Indicator: Is the applicant self-employed?
- Tasks:
Analyze the available variables to determine their suitability for inclusion in the model.

Develop logistic regression models to explain and predict mortgage approvals using the provided information. Follow these steps:

- Randomly split the data into training (70%) and validation (30%) sets. Specify the number of cases in each split.
- Consider and compare several models using the training set:
- A model with all available variables.
- A model including only variables significant at the 5% level.
- A model selected using a stepwise selection method.
For the model selected in the previous step, answer the following:
- a) Is the model significant overall?
- b) Are all variables significant within the model?
- c) Conduct a goodness-of-fit test. What conclusions can be drawn?
- d) Choose one coefficient from the model and interpret it in terms of odds.
- e) Report pseudo R² values.
- f) Compute the AUC and plot the ROC curve using the test set.
- g) Create a classification table with a 0.5 threshold. What percentage of cases are correctly classified?
- h) Can classification performance be improved by adjusting the threshold? Propose an alternative threshold.
- i) Using the threshold from the previous point, evaluate case #100. Was it classified correctly? With what probability?

- Train a Naive Bayes model.

- Train a SVM model.

- Finally, evaluate the models considered in steps 4, 5, and 6. Which model performs best at predicting the positive class?

