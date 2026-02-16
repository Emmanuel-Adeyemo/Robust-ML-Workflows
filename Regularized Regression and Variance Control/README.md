**Regularized Regression and Variance Control**

This project documents the systematic improvement of a regression model. The workflow transitions from 
a baseline linear model to a regularized Polynomial Ridge Regression model, utilizing target transformations and the One-Standard-Error (1-SE) rule to ensure maximum generalization.

***Project Overview:***    
The goal was to predict a target variable while strictly managing the bias-variance tradeoff
inherent in high-dimensional feature spaces. The final implementation utilizes Lasso (L1) Regularization combined
with the One-Standard-Error (1-SE) rule for alpha selection.
    
***Project Evolution & Methodology***    

****1. Baseline Diagnostics and Transformation****

a. Initial Performance: The starting model achieved a CV $R2$ of 0.47.
    
b. Error Analysis: Residual Plot shows non-constant variance - heteroscedasticity, a violation of linear regression
    assumptions.
        
c. Addressing Model Assumptions: To stabilize variance, a Yeo-Johnson transformation was applied to the target variable y. The post-transformation CV $R2$ was 0.45, providing a more statistically sound 
foundation for further complexity.

d. Feature Engineering: Expanded the initial 15 features to 139 using Polynomial features, allowing the model to 
capture complex, non-linear signals.
Initial Impact: This surge initially resulted in poorer metrics (Test $R2$ = -0.82) compared to the baseline. This is probably a feature of severe overfitting (Train $R2$ = 0.68) and high multicollinearity, as confirmed during EDA.

****2. Regularization Strategy:****    
   
To prevent overfitting, Lasso, Ridge, and Elastic Net were compared.

a. The 1-SE Rule: Instead of selecting the alpha that produced the absolute highest $R2$, the model selected
a simpler model (larger alpha) whose performance is within one standard error of the best result, allowing for
better generalization. 

 b. Winning Model: Lasso (L1) achieved a CV $R2$ of 0.50 and was selected as the final estimator, effectively zeroing out 91 redundant features and retaining only 71 most impactful predictors.


 ****3. Model Validation and Performance Stability:**** 
 
a. Bootstrap Analysis: A bootstrap simulation was performed to establish a 95% confidence interval for $R^2$ 
(0.30 and 0.57).

b. Consistency: The Out of Bag (OOB) score of 0.52 closely aligns with the cross-validation score of 0.50,
confirming generalization.

c. Lasso vs Baseline Model Performance of Test Data: The lasso model resulted in an $R2$ of 0.56 on the test (held-out) data while the baseline model was only able to achieve an $R2$ of 0.39 even though it has a CV $R2$ of 0.47. The regularized model closed the generalization gap, performing better in the test data than in the cross-validation and providing an absolute increase of 0.17 $R2$ on test data.


****4. Key Takeaways****

a. Feature Selection: Only 71 out of 139 features were necessary for peak performance.

b. Non-linearity: The top influential features were a mix of main effects and interaction terms, confirming
that a standard linear approach was insufficient for this dataset.

c. Reliability: Using the 1-SE sacrificed a small amount of training accuracy to achieve a stable test result.


d. Next Steps: Exploring non-linear estimators like tree-based methods and ensembles, given that poly 
terms were necessary to improve $R2$.
