libname hw1 'C:\440\hw1';
/* Exercise 1 */
proc contents data=sashelp.pricedata;
run;

data pricing;
   set sashelp.pricedata;
   where Sale > 500 and Price-Cost < 20;
   keep Date Sale Price Discount Cost ProductName;
   format Date date9. 
          Price Cost dollar7.2
          Discount percent6.0;
   label Sale="Units Sold";
run;

proc contents data=pricing;
run;

proc print data=pricing label;
run;



/* Exercise 2 */
/* a */
title2 'Part 2a';
proc contents data=hw1.birthweight;
run;

/*b*/
data hw1.smokers;
   set hw1.birthweight;
   keep weight boy visit smoke cigsper m_wtgain;
   where smoke=1;
   label weight="Infant’s Birth Weight"
         boy="Indicator of Boy"
         visit="Prenatal Visit"
         smoke="Indicator of Smoking Mother"
         cigsper="Cigarettes Smoked per Day"
         m_wtgain="Mother’s Weight Gain";
run;

/* c */
proc contents data=hw1.smokers;
run;

/* d */
data check;
   set hw1.birthweight;
   where smoke=1 and cigsper=0 or
         smoke=0 and cigsper>0;
run;

/*e*/
proc print data=check;
   var weight smoke cigsper m_wtgain;
run;



/* Exercise 3 */
/*a*/
proc contents data=sashelp.heart;
run;

/*b*/
proc print data=sashelp.heart;
   var Sex Weight Height AgeAtDeath;
   where 25 <= Weight / Height**2 * 703 <= 30 and
         . < AgeAtDeath < 60;
run;

/*c*/
proc print data=sashelp.heart(obs=15);
   var DeathCause Sex AgeAtStart AgeAtDeath;
   where DeathCause='Cancer' and
         (Sex='Female' and AgeAtDeath>=95 or
          Sex='Male' and AgeAtDeath>=85);
run;

/* d & e */
data highrisk;
   set sashelp.heart;
   where AgeCHDdiag is not missing and
         ((Chol_Status='High') +
          (BP_Status='High') +
          (Weight_Status='Overweight') +
          (Smoking_Status contains 'Heavy') >= 2);
run;

proc contents data=highrisk;
run;
