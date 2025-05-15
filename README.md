# 🧠 Income Prediction using Logistic Regression & Probit Models

This project uses logistic regression and generalized linear models to predict whether an individual's salary exceeds $50,000 based on socio-economic variables. The dataset is derived from a subset of the 1994 U.S. Census data.

## 📁 Files
- `STAT448_Group2_FinalProjectReport.pdf`: Full report with EDA, modeling, and conclusions
- `STAT448_Group2_FinalProjectCode.sas`: Full SAS code file

## 🔍 Project Summary

We analyzed 11 predictors including age, education, working hours, occupation, marital status, and more to classify income levels (≤$50K or >$50K). Categorical variables were regrouped for better model interpretability.

## 🧪 Methods Used
- Descriptive statistics & data cleaning
- Chi-square and Wilcoxon tests for association
- Logistic regression with stepwise selection
- Generalized linear model (GLM) with probit link
- Model comparison using ROC, AUC, misclassification error

## 📊 Key Findings
- Significant predictors: **Occupation**, **Relationship**, **Sex**, **Age**, **Education (Ednum)**, **Hours per week**
- Logistic regression had a misclassification error of ~17.85%, and the probit model slightly improved this to ~17.41%
- AUC improved from 88.76% to 89.41% using the probit link

## 🧠 Interpretation Highlights
- **Tech-support** workers were more likely to earn >$50K, while **farming-fishing** workers less likely
- **Wife** relationship category correlated with higher income; **not-in-family** and **own-child** with lower
- **Males**, older individuals, and those with higher education or more work hours were more likely to earn >$50K

## 📌 Tools Used
- SAS (`proc logistic`, `proc genmod`)
- R (for preprocessing and plots, if applicable)
- PDF report documentation

## 👥 Authors
- Kashyap Ava
- Sunny Chen

---

*Part of UIUC STAT 448 Final Project*
