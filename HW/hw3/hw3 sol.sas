/*******************************
***   Homework 3 Solutions   ***
*******************************/

option nodate pageno=1 center ls=96 ;
ods rtf file='C:\440\hw3\hw3 solution Fa15.rtf';
libname hw3 'C:\440\hw3';

title 'Homework 3 Report';

/* Exercise 1 */
/*a*/
data work.shoes_tracker;
   set hw3.shoes_tracker;
   Supplier_Country=upcase(Supplier_Country);
   Product_Name=propcase(Product_Name);

   /* Cleaning by Product_ID */
   if Product_ID=22020030007 then Product_ID=220200300079;
   else if Product_ID=2202003001290 then Product_ID=220200300129;
   else if Product_ID=220200300005 then Product_Category='Shoes';
   else if Product_ID=220200300116 then Supplier_Name='3Top Sports';
   else if Product_ID=220200300154 then Supplier_Name='Greenline Sports Ltd';
   else if Product_ID=220200300015 then do 
      Supplier_Name='3Top Sports'; 
      Product_Name="Men's Running Shoes Piedmont"; 
      end;
   else if Product_ID=220200300082 then Supplier_Country='US';
   else if Product_ID=220200300002 then Supplier_ID=2963;

   /* Another option to fix the reference variables,...
   if _N_=4 then Product_ID=220200300079;  
   else if _N_=8 then Product_ID=220200300129;  */

   /* Yet another option to fix the reference variables,...
   if Product_ID < 10**12 then Product_ID = 10*Product_ID + 9;  
   else if Product_ID >= 10**13 then Product_ID = int(Product_ID/10);  */


   /* Cleaning by issue -
      If you know that certain issues also need the same correction,
      e.g. 'UT' should always be switched to 'US', then you might use 
      this method, but it's usually not preferred. 
      Also, if you know each observation has only one issue, then you
      can include ELSE in front of each IF after the first IF. But each
      observation only having one issue is a big assumption. This is 
      also not preferred. */
   /*
   if Supplier_Country='UT' then Supplier_Country='US';
   if Product_Category=' ' then Product_Category='Shoes';
   if Supplier_ID=. then Supplier_ID=2963;
   if Supplier_Name='3op Sports' then Supplier_Name='3Top Sports';
   if Supplier_ID=14682 and Supplier_Name='3Top Sports'
      then Supplier_Name='Greenline Sports Ltd';
   if Product_ID = 22020030007 then Product_ID = 220200300079;
   else if Product_ID = 2202003001290 then Product_ID = 220200300129;
   */

run;

/*b*/
title2 'Part 1b';
/* For the purposes of HW3 and its report, most students will probably
   just use PROC PRINT to dump everything out, but that's not a good
   strategy for most data sets. */

/* Tables will vary from student to student, but
   here are some better methods to consider. */


/* This PROC FREQ results no Missing Levels column so that means 
   there are no missing values anywhere in those variables. The values of
   the Levels column also match what we expect from a clean data set.  */
proc freq data=work.shoes_tracker nlevels;
   tables _all_ / noprint;
run;

/* This PROC PRINT results no output because 0 observations fulfill these
   invalid data issues. (So that's a good thing.) */
proc print data=work.shoes_tracker;
   where Product_Category=' ' or
         Supplier_Country not in ('GB','US') or
		 Supplier_Name not in ('3Top Sports' 'Greenline Sports Ltd') or
		 Supplier_ID not in (2963 14682) or
         propcase(Product_Name) ne Product_Name;
run;

/* This PROC FREQ verifies the uniqueness of the Supplier Name 
   and ID pairs. It could also be done with a PROC PRINT and WHERE
   statement. */
proc freq data=work.shoes_tracker;
   tables Supplier_Name*Supplier_ID / nocum nopercent norow nocol missing; 
   tables Supplier_Country;
run;

/* This PROC MEANS verifies that all Product_ID values are only 
   12 digits long. */
proc means data=work.shoes_tracker min max range fw=12;
   var Product_ID;
   class Supplier_Name;
run;  



/* Exercise 2 */
/*a*/
data rushing;
   infile 'badrush.txt' dlm='09'x dsd;
   input Season Player :$30. @;
   /* Most players are not Matt Forte so this should come first. */
   if Player ^= 'Matt Forte' then
      input Team :$3. Games
            Att :comma5. Yds :comma5. 
            Avg YPG Lg TD FD;
   /* The only "ELSE" is Matt Forte. */
   else do;
      Team = 'Chi';
      input Games
            Att :comma5. Yds :comma5. 
            Avg YPG Lg TD FD;
   end;
   format Att Yds comma5.0
          Avg YPG 6.1;
   label Att='Attempts'
         Yds='Total Yards'
		 Avg='Yards per Attempt'
		 YPG='Yards per Game'
		 Lg='Longest Rush'
		 TD='Touchdowns'
		 FD='First Downs';
run;

/*b*/
title2 'Part 2b';
proc contents data=rushing;
run;

/*c*/
/* Copy and Paste the Log */

/*d*/
title2 'Part 2d';

/* First run a general procedure to check number of levels and for any missing values. */
proc freq data=rushing nlevels;
   table _all_ / noprint;
run;

title3 '1-Finding incorrect values in Season.';
proc freq data=rushing;
   table Season;
run;

title3 '2-Checking the ranges of numeric variables.';
proc means data=rushing n nmiss min max;
   var Games Lg Att TD FD;
run;
ods select ExtremeObs;
proc univariate data=rushing;
   var Games Lg Att;
run;

proc print data=rushing(firstobs=504 obs=504);
run;

title3 '3-Checking the Avg and YPG values.';
proc print data=rushing;
   var Season Player Yds Att Avg;
   where round(Yds/Att, .01) ^= Avg;
run;
proc print data=rushing;
   var Season Player Yds Games YPG;
   where round(Yds/Games, .1) ^= YPG;
run;

title3 '4-Checking the Lg values.';
proc print data=rushing;
   var Season Player Yds Lg Avg YPG;
   where Lg < 0 and Yds >= 0;
run;


/*e*/
title2 'Part 2e';
data rush;
   set rushing;
   /* From the invalid data errors in the Log (3c) 
      o as 0 */
   if Season=2012 and Player='Daryl Richardson' then TD=0;
   else if Season=2011 and Player='Mike Kafka' then Yds=0;
   else if Season=2010 and Player='Moran Norris' then Avg=0;

   /* Individual fixes */
   if Season = 1912 then Season = 2012;
   else if Season = 20010 then Season = 2010;
   else if Season = 20111 then Season = 2011; 

   if Player=' ' then Player='LeSean McCoy';

   if Games=0.16 then Games=16; /* or... IF _N_=990 */

   if Lg=910 then Lg=91;        /* or... IF _N_=957 */
   else if Lg=2800 then Lg=28;  /* or... IF _N_=715 */
   else if Season=2012 and Player='Raymond Ventrone' then Lg = 35;

   if Season=2013 and Player='Riley Cooper' then Att=1;

   /* Wholesale fixes */
   Avg = round(Yds/Att, .01);
   YPG = round(Yds/Games, .1);
run;

/*f*/
title2 'Part 2f';
proc freq data=rush nlevels;
   table _all_ / noprint;
run;

proc means data=rush n nmiss min max;
   var Games Lg Att TD FD;
run;

proc print data=rush;
   where round(Yds/Att, .01) ^= Avg   or
         round(Yds/Games, .1) ^= YPG  or
		 Lg < 0 and Yds >= 0;
run;




title;
ods rtf close;
