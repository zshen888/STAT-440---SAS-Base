/*******************************
***   Homework 5 Solutions   ***
*******************************/

ods rtf file='C:\440\hw5\hw5 solution Fa15.rtf';
title 'Homework 5 Report';
option nodate pageno=1 center ls=96 ;

libname hw5 'C:\440\hw5';


/* Exercise 1 */
title2 'Exercise 1 - Employee Data';

/*a*/
title3 'Part 1a';
proc freq data=hw5.employee_roster5 noprint;
   table Employee_ID / out=IDfreq;
run;
proc print data=IDfreq noobs;
   var Employee_ID Count;
   where Count>1;
run;

/*b*/
/* There are certainly multiple ways to dig for the correct 
   Employee_ID's. This is just one. */

* First, sort by Employee_ID. ;
proc sort data=hw5.employee_roster5 out=empsort;
   by Employee_ID;
run;

* Then, look at observations around those with duplicate values. ;
proc print data=empsort;
   var Employee_ID Employee_Country Company Department Section Org_Group;
   where Employee_ID between 120104 and 120108 /* those around 120106 */
      or Employee_ID between 120720 and 120724 /* those around 120722 */
      or Employee_ID between 121139 and 121143 /* those around 121141 */ ;
run;
* Looking at the output it seems that the out-of-order observations are
	Obs   6 for 120106
	Obs 171 for 120722
	Obs 415 for 121141
	Obs 416 for 121141 ;

* Next, look at the observation numbers for those that match the 
  other variables for the out-of-order observations. ;
proc print data=empsort;
   title4 'Obs 6 for 120106';
   var Employee_ID ;
   where Employee_Country='AU' &
         Company='Orion Australia' &
         Department='Sales' & 
         Section='Sales' ;
run;
* Obs 6 should be 120136 ;

proc print data=empsort;
   title4 'Obs 171 for 120722';
   var Employee_ID ;
   where Employee_Country='US' &
         Company='Purchasing' &
         Department='Purchasing' & 
         Section='Outdoors' ;
run;
* Obs 171 should be 120733 ;

proc print data=empsort;
   title4 'Obs 415 for 121141';
   var Employee_ID ;
   where Employee_Country='AU' &
         Company='Orion Australia' &
         Department='Administration' & 
         Section='Security' ;
run;
* Obs 415 should be 120114 ;

proc print data=empsort;
   title4 'Obs 416 for 121141';
   var Employee_ID ;
   where Employee_Country='AU' &
         Company='Orion Australia' &
         Department='Sales' & 
         Section='Sales' &
         Org_Group='Outdoors';
run;
* Obs 416 should be 120141 ;

data hw5.employee_roster;
   set empsort;
   select (_N_);
      when (6)   Employee_ID=120136;
      when (171) Employee_ID=120733;
      when (415) Employee_ID=120114;
      when (416) Employee_ID=120141;
	  otherwise;
   end;
run;

/*c*/
title3 'Part 1c';
proc freq data=hw5.employee_roster noprint;
   table Employee_ID / out=IDfreq;
run;
proc print data=IDfreq noobs;
   var Employee_ID Count;
   where Count>1;
run;

/*d*/
proc format;
   value $gender_fmt 'M'='Male'
                     'F'='Female'
					 other='Not Given';
run;

/*e*/
title3 'Part 1e';
proc freq data=hw5.employee_roster;
   table Department*Employee_Gender / norow nocol;
   format Employee_Gender $gender_fmt.;
run;



/* Exercise 2 */
title2 'Exercise 2 - Baseball Data';
/*a*/
proc sort data=hw5.batting out=batting;
   by PlayerID;
run;
proc sort data=hw5.master out=master;
   by PlayerID;
run;
data mostruns(keep=nameFirst nameLast YearID TeamID R)
     power(keep=nameFirst nameLast bats YearID HR RBI)
     bestavg(keep=nameFirst nameLast BirthDate YearID PA AVG);
   merge batting(keep=PlayerID YearID TeamID
                      R HR RBI G H AB BB HBP SH SF)
         master(keep=PlayerID nameFirst nameLast bats BirthDate);
   by PlayerID;
   if R >= 100 then output mostruns;
   if HR > 0 then output power;
   PA = AB + BB + HBP + SH + SF; /* or we'll accept... PA = sum(AB, BB, HBP, SH, SF); */
   if PA/G >= 3.1 then do;
      AVG = H/AB;
	  output bestavg;
   end;
run;


/*b*/
title3 'Part 2b';
proc means data=power nonobs mean median max maxdec=1;
   class Bats;
   var HR;
run;
proc means data=power nonobs mean median max maxdec=1;
   class Bats;
   var RBI;
run;


/*c*/
proc format;
   value decade 1870-1879 = '1870s'
                1880-1889 = '1880s'
				1890-1899 = '1890s'
				1900-1909 = '1900s'
				1910-1919 = '1910s'
				1920-1929 = '1920s'
				1930-1939 = '1930s'
				1940-1949 = '1940s'
				1950-1959 = '1950s'
				1960-1969 = '1960s'
				1970-1979 = '1970s'
				1980-1989 = '1980s'
				1990-1999 = '1990s'
				2000-2009 = '2000s'	;
run;

title3 'Part 2c';
proc means data=bestavg nonobs min q1 median q3 max maxdec=3;
   class YearID;
   var AVG;
   where 1871<=YearID<=2009;
   format YearID decade.;
run;


/* Exercise 3 */

title2 'Exercise 3 - Survey Data';
/* a */

proc sort data=hw5.demographic out=demographic;
   by ID;
run;
proc sort data=hw5.survey1 out=survey1;
   by Subj;
run;
data work.demo1;
   merge demographic survey1(rename=(Subj=ID));
   by ID;
run;

/* b */
title2 'Part 3b';
proc print data=work.demo1;
run;


/* c */
/* Solution where the numeric identifier is converted
   to a character value. */
proc sort data=hw5.demographic out=demographic;
   by ID;
run;
data survey2;
   set hw5.survey2(rename=(ID=NumID));
   ID = put(NumID,z3.);
   drop NumID;
run;
proc sort data=survey2;
   by ID;
run;
data work.demo2;
   merge demographic survey2;
   by ID;
run;


/* Solution where the character identifier is converted
   to a numeric value. */
data demographic;
   set hw5.demographic(rename=(ID=CharID));
   ID = input(CharID,3.);
   drop CharID;
   format ID z3.;
run;
proc sort data=demographic;
   by ID;
run;
proc sort data=hw5.survey2 out=survey2;
   by ID;
run;
data work.demo2;
   merge demographic survey2;
   by ID;
run;


/* d */
title2 'Part 3d';
proc print data=work.demo2;
run;



ods rtf close;
title;
