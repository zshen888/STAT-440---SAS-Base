/*******************************
***   Homework 1 Solutions   ***
*******************************/

/* These global options will be explained later in the semester and
   are just being used to enhance the solutions Report. */
option nodate pageno=1 center ls=96 ;
ods pdf file='C:\440\hw1\hw1 solution Fa15.pdf';
libname hw1 'C:\440\hw1';

title 'Homework 1 Report';

/* Exercise 1 */
/*a*/
title2 'Part 1a';
proc contents data=sashelp.pricedata;
run;

/*b*/
data pricing;
   set sashelp.pricedata;
   where Sale > 500 and Price-Cost < 20;
   keep Date Sale Price Discount Cost ProductName;
   format Date date9. 
          Price Cost dollar7.2
          Discount percent6.0;
   label Sale="Units Sold";
run;

/*c*/
title2 'Part 1c';
proc contents data=pricing;
run;

/*d*/
title2 'Part 1d';
proc print data=pricing label;
run;



/* Exercise 2 */
/*a*/
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

/*c*/
title2 'Part 2c';
proc contents data=hw1.smokers;
run;

/*d*/
data check;
   set hw1.birthweight;
   where smoke=1 and cigsper=0 or
         smoke=0 and cigsper>0;
run;

/*e*/
title2 'Part 2e';
proc print data=check;
   var weight smoke cigsper m_wtgain;
run;



/* Exercise 3 */
/*a*/
title2 'Part 3a';
proc contents data=sashelp.heart;
run;

/*b*/
title2 'Part 3b';
proc print data=sashelp.heart;
   var Sex Weight Height AgeAtDeath;
   where 25 <= Weight / Height**2 * 703 <= 30 and
         . < AgeAtDeath < 60;
run;
ods pdf text=" "
        text="Sorry for this printout being rather page-consuming with 105 observations."
		text='I meant to type "before age 50" not "60" in the homework.';

/*c*/
title2 'Part 3c';
proc print data=sashelp.heart(obs=15);
   var DeathCause Sex AgeAtStart AgeAtDeath;
   where DeathCause='Cancer' and
         (Sex='Female' and AgeAtDeath>=95 or
          Sex='Male' and AgeAtDeath>=85);
run;
ods pdf text=" "
        text="There are 15 observations that fit the condition.";

/*d*/
data highrisk;
   set sashelp.heart;
   where AgeCHDdiag is not missing and
         ((Chol_Status='High') +
          (BP_Status='High') +
          (Weight_Status='Overweight') +
          (Smoking_Status contains 'Heavy') >= 2);
run;

/* Alternate solution... but less efficient */
/*
data highrisk;
   set sashelp.heart;
   where AgeCHDdiag is not missing and
      (Chol_Status='High' and BP_Status='High' or 
       Chol_Status='High' and Weight_Status='Overweight' or
	   Chol_Status='High' and Smoking_Status in ('Heavy (16-25)' 'Very Heavy (> 25)') or
	   BP_Status='High' and Weight_Status='Overweight' or
	   BP_Status='High' and Smoking_Status in ('Heavy (16-25)' 'Very Heavy (> 25)') or
       Weight_Status='Overweight' and Smoking_Status in ('Heavy (16-25)' 'Very Heavy (> 25)') );
run;
*/

/*e*/
title2 'Part 3e';
proc contents data=highrisk;
run;


title;
ods pdf close;
