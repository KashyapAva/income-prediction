*\ Final project STAT448 Fall 2024 *\;
*\ Markelle Kelly, Rachel Longjohn, Kolby Nottingham,
The UCI Machine Learning Repository, https://archive.ics.uci.edu:
https://archive.ics.uci.edu/dataset/2/adult;
ods rtf file='/home/u63996014/STAT448_F24/Final Project/ProjectResults.rtf';

data Salary_S1;
	infile '/home/u63996014/STAT448_F24/Final Project/Salary_S1_CC.csv' dlm="," missover firstobs=2;
	length WC $16 Education $12 MS $21 Occupation $17 Relationship $13 Race $18 NCountry $18;
	input Age WC $ fnlwgt Education $ Ednum MS $ Occupation $ Relationship $ Race $ Sex $ Capgain Caploss hpw NCountry $ Salary $;
	keep Age WC Education Ednum MS Occupation Relationship Race Sex hpw NCountry Salary;
run;

proc print data=Salary_S1;
run;

/* Part 1*/

/* The continuos variables are Age, Ednum and Hpw
   The categorical variables are WC Education MS occupation
                                 Relationship Race NCountry Salary
*/

/* Data Preprocessing */

/*The without pay observation can be removed*/
data Salary_S1_1;
  set Salary_S1;
  if WC ^= "Without-pay";
run;

/*Removed the NCountry with South as it ambiguous */
data Salary_S1_2;
  set Salary_S1_1;
  if Ncountry ^= "South";
run;

/* Regrouping Education into Education_new */
data Salary_S1_3;
  set Salary_S1_2;
  length Education_new $ 10;
  if Education in ('Preschool','1st-4th', '5th-6th', '7th-8th', '9th', '10th', '11th', '12th')
      then Education_new = 'School';
   else if Education in ('Assoc-acdm', 'Assoc-voc') then Education_new = 'Associate';
   else Education_new = Education;
run;

/* Regrouping MS into MS_new */
data Salary_S1_4;
  set Salary_S1_3;
  length MS_new $ 10;
  if MS in ('Married-AF-spouse','Married-civ-spouse', 'Married-spouse-absent')
      then MS_new = 'Married';
   else MS_new = MS;
run;

/* Regrouping Race into Race_new */
/* Combine the eskimo and islander into one category */
data Salary_S1_5;
  set Salary_S1_4;
  length Race_new $ 10;
  if Race in ('Amer-Indian-Eskimo','Asian-Pac-Islander')
      then Race_new = 'Eskimo-Islander';
   else Race_new = Race;
run;

/* Regrouping NCountry into NCountry_new */
/* Re-group them may be based on continents*/
data Salary_S1_6;
  set Salary_S1_5;
  length NCountry_new $ 10;
  if NCountry in ('United-States')
      then NCountry_new = 'US';
  else NCountry_new = 'Non-US';
run;

/* 913 observations remain */

/* Descriptive statistics for continuos variables */

proc means data = Salary_S1_6 n mean median std min max;
  var Age;
run;

proc means data = Salary_S1_6 n mean median std min max;
  var Ednum;
run;

proc means data = Salary_S1_6 n mean median std min max;
  var Hpw;
run;

/* Descriptive statistics for continuous variables */

proc univariate data = Salary_S1_6;
  var Age Ednum Hpw;
run;

proc univariate data = Salary_S1_6 normal;
  var Age Ednum Hpw;
  histogram Age Ednum Hpw / normal;
  probplot Age Ednum Hpw;
  ods select Histogram ProbPlot GoodnessOfFit TestsForNormality;
run;

/* None of the continuous variables are normally distributed*/
/* The potential associations are through Chisq and fischers test*/

proc npar1way data = Salary_S1_6 wilcoxon;
  class Salary;
  var Age;
  ods exclude KruskalWallisTest;
run;

proc npar1way data = Salary_S1_6 wilcoxon;
  class Salary;
  var Ednum;
  ods exclude KruskalWallisTest;
run;

proc npar1way data = Salary_S1_6 wilcoxon;
  class Salary;
  var Hpw;
  ods exclude KruskalWallisTest;
run;


/* Descriptive statistics for categorical variables */

proc freq data=Salary_S1_6;
   tables WC Education_new MS_new Occupation Relationship 
          Race_new Sex NCountry_new;
run;

/* may be better to tabulate them with salary to possiby remove some obs*/

proc freq data = Salary_S1_6;
  tables WC * Salary / nopercent norow nocol expected chisq;
run;

proc freq data = Salary_S1_6;
  tables Education_new * Salary / nopercent norow nocol expected chisq;
run;

proc freq data = Salary_S1_6;
  tables MS_new * Salary / nopercent norow nocol expected chisq;
run;

proc freq data = Salary_S1_6;
  tables Occupation * Salary / nopercent norow nocol expected chisq;
run;

proc freq data = Salary_S1_6;
  tables Relationship * Salary / nopercent norow nocol expected chisq;
run;

proc freq data = Salary_S1_6;
  tables Race_new * Salary / nopercent norow nocol expected chisq;
run;

proc freq data = Salary_S1_6;
  tables Sex * Salary / nopercent norow nocol expected chisq;
run;

proc freq data = Salary_S1_6;
  tables NCountry_new * Salary / nopercent norow nocol expected chisq;
run;

/*Race_new and NCountry_new are not significant predictors*/

/* Investigate if the regrouping caused the insignificance */

proc freq data = Salary_S1_6;
  tables Race * Salary / nopercent norow nocol expected chisq;
run;

proc freq data = Salary_S1_6;
  tables NCountry * Salary / nopercent norow nocol expected chisq;
run;

/* Regrouping Race into Race_new_1 */
/* Combine the eskimo and islander into one category */
data Salary_S1_7;
  set Salary_S1_6;
  length Race_new_1 $ 10;
  if Race in ('Amer-Indian-Eskimo','Asian-Pac-Islander', 'Other')
      then Race_new_1 = 'Other_new';
   else Race_new_1 = Race;
run;

proc freq data = Salary_S1_7;
  tables Race_new_1 * Salary / nopercent norow nocol expected chisq;
run;


/* Checking correlation between the conitnuous predictors */

proc corr data = Salary_S1_6 pearson spearman;
  var Age Ednum Hpw;
run;


/* The target variable is categorical so GLM procedures do not work */

/* Lets try logistic regression */

proc logistic data = Salary_S1_6;
   class WC Education_new MS_new Occupation Relationship 
         Sex/ param = reference ref = first;
   model Salary = WC Education_new MS_new Occupation 
                   Relationship Sex Age Ednum Hpw
                  / selection = stepwise sle = 0.05 sls = 0.05;
run;


/* Selected model predictors:
   Occupation, Relationship, Sex, Age, EdNum, hpw */
  
/* Output is binary and not in successes/ trials format */
/* Use Hosmer Lemeshow Goodness of Fit test */

proc logistic data = Salary_S1_6;
   class Occupation Relationship 
         Sex/ param = reference ref = first;
   model Salary = Occupation Relationship Sex Age Ednum Hpw / lackfit;
run;

/* p-value is 0.09 which implies the model fits the data well */

/* use the final model to see model performance by 
inspecting individual probabilities */

proc logistic data = Salary_S1_6;
   class Occupation Relationship 
         Sex/ param = reference ref = first;
   model Salary = Occupation Relationship Sex Age Ednum Hpw/ selection = backward;
   output predprobs = individual out = Salary_out1;
run;

proc print data = Salary_out1; 
run;

* compare levels observed with levels predicted;
proc freq data = Salary_out1;
    tables Salary * _into_/nopercent norow nocol;
run;

/* Misclassification error of 163/ 913 = 0.1785 */

/* ROC for the final model */

proc logistic data = Salary_S1_6 plots = roc;
   class Occupation Relationship 
         Sex/ param = reference ref = first;
   model Salary = Occupation Relationship Sex Age Ednum Hpw;
run;


/* Selected model predictors:
   Occupation, Relationship, Sex, Age, EdNum, hpw */
  
/* Lets check if the categorical variables second order interactions are significant */
   
proc logistic data = Salary_S1_6;
   class Occupation Relationship 
         Sex/ param = reference ref = first;
   model Salary = Occupation Relationship Sex Occupation*Relationship 
                  Relationship*Sex Occupation*Sex 
                  Occupation*Relationship*Sex Age Ednum Hpw
                  / selection = backward;
   *ods select ClassLevelInfo OddsRatios ParameterEstimates 
              GlobalTests ModelInfo FitStatistics;
run;

/* Warning that quasicomplete seperation in step 6, MLE may not exist. 
   Warning: Validaity of model fit is questionable 
   Result: Interactions were removed */
  
/* This can motivate us to use genmod */

/* Using genmod with selected predictors as 
   the full model had certian issues with hessian being non semi definite*/

proc genmod data = Salary_S1_6;
   class Occupation Relationship Sex/ param = reference ref = first;
   model Salary = Occupation Relationship Sex Age Ednum Hpw
                  / dist = binomial link = logit type1 type3;
run;

/* Type 1 and Type 3 suggest that all predictors are required*/

/* Model Diagnostics */

proc genmod data = Salary_S1_6;
   class Occupation Relationship Sex/ param = reference ref = first;
   model Salary = Occupation Relationship Sex Age Ednum Hpw
                  / dist = binomial link = logit type1 type3;
   output out = binres pred = presp_n stdreschi = presids
			stdresdev=dresids;	
   ods select ModelInfo ModelFit ParameterEstimates Type1 ModelANOVA;
run;

* plot standardized Pearson and deviance residuals vs. predicted values for both models;
proc sgscatter data=binres;
	compare y= (presids dresids) x=presp_n;
	where presp_n<100;
run;

proc genmod data = Salary_S1_6 plots=(stdreschi stdresdev);
   class Occupation Relationship Sex/ param = reference ref = first;
   model Salary = Occupation Relationship Sex Age Ednum Hpw
                  / dist = binomial type1 type3;
	ods select ModelInfo DiagnosticPlot;	
run;

/* Genmod does not directly give GoF, ROC and misclassifications */


proc genmod data = Salary_S1_6;
   class Occupation Relationship Sex/ param = reference ref = first;
   model Salary = Occupation Relationship Sex Age Ednum Hpw
                  / dist = binomial link = logit;
   output out = preds pred = pred_prob;
run;

/* Goodness of fit */
proc logistic data = preds;
   class Occupation Relationship Sex/ param = reference ref = first;
   model Salary = Occupation Relationship Sex Age Ednum Hpw/ lackfit;
run;

/* p-value is 0.09 which implies the model fits the data well */


/* Classification table */
data preds_1;
  set preds;
  if pred_prob >= 0.5 then pred_class = "<=50K";
  else pred_class = ">=50K";
run;

proc freq data = preds_1;
    tables Salary * pred_class/nopercent norow nocol;
run;

/* Misclassification error of 163/ 913 = 0.1785 */

proc logistic data = preds;
  model Salary = pred_prob;
  roc 'GLM Model' pred_prob;
run;


/* Using genmod with probit link and the full model*/

proc genmod data = Salary_S1_6;
   class WC Education_new MS_new Occupation Relationship 
         Sex/ param = reference ref = first;
   model Salary = WC Education_new MS_new Occupation 
                   Relationship Sex Age Ednum Hpw
                  / link = probit dist = binomial;
   output out = preds_p pred = pred_prob_p;
run;


/* Goodness of fit */
proc logistic data = preds_p;
   class WC Education_new MS_new Occupation Relationship 
         Sex/ param = reference ref = first;
   model Salary = WC Education_new MS_new Occupation 
                   Relationship Sex Age Ednum Hpw
                  /lackfit;
run;

/* p-value is 0.078 which implies the model fits the data well */


/* Classification table */
data preds_2;
  set preds_p;
  if pred_prob_p >= 0.5 then pred_class = "<=50K";
  else pred_class = ">=50K";
run;

proc freq data = preds_2;
    tables Salary * pred_class/nopercent norow nocol;
run;

/* Misclassification error of 159/ 913 = 0.174 */

proc logistic data = preds_p;
  model Salary = pred_prob_p;
  roc 'GLM Probit Model' pred_prob_p;
run;

/* ROC has slightly improved */

/* GLM probit with the selected predictors */

proc genmod data = Salary_S1_6;
   class Occupation Relationship 
         Sex/ param = reference ref = first;
   model Salary = Occupation Relationship Sex Age Ednum Hpw
                  / link = probit dist = binomial;
   output out = preds_p1 pred = pred_prob_p1;
run;


/* Goodness of fit */
proc logistic data = preds_p1;
   class Occupation Relationship 
         Sex/ param = reference ref = first;
   model Salary = Occupation 
                   Relationship Sex Age Ednum Hpw
                  /lackfit;
run;

/* p-value is 0.096 which implies the model fits the data well */


/* Classification table */
data preds_3;
  set preds_p1;
  if pred_prob_p1 >= 0.5 then pred_class = "<=50K";
  else pred_class = ">=50K";
run;

proc freq data = preds_3;
    tables Salary * pred_class/nopercent norow nocol;
run;

/* Misclassification error of 164/ 913 = 0.179 */

proc logistic data = preds_p1;
  model Salary = pred_prob_p1;
  roc 'GLM Probit Model' pred_prob_p1;
run;

/* ROC remained the same from the original logistic*/


/* The categorical variables might have to encoded into continuous for DA and SVM */


/* Trying out decision trees and random forests */


/* Decision trees */
proc hpsplit data = Salary_S1_6 cvmodelfit seed = 448 maxbranch = 3 maxdepth = 10;
   class Salary WC Education_new MS_new Occupation Relationship Sex;
   grow entropy; 
   model Salary = WC Education_new MS_new Occupation 
                   Relationship Sex Age Ednum Hpw ;
   prune costcomplexity;
run;

/* (2,10) - 177  (3, 10) - 170 (4, 10) - 181 */
/* (3, 12) - 170, 0.85 */
/* ROC - 0.83, Misclassifications = 0.196  */

/* Random Forest */
proc hpforest data = Salary_S1_6 maxtrees = 167 seed = 448 
              trainfraction = 0.8;
   target Salary / level = binary;
   input WC Education_new MS_new Occupation Relationship Sex / level = ordinal;
   input Age Ednum Hpw / level = interval;
run;

/* 167 trees might be enough */

/* I cant get the roc and other results and the misclassification error seems to be high*/

/* Final modeling involves logistic, genmod and decision tree */
  



ods rtf close;
 