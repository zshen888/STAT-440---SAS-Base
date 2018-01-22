libname hw2 'C:\440\hw2';

/* Exercise 1 */
/* a & b */
data hw2.AUaids;
   infile 'C:\440\hw2\AUaids.dat';
   input Obs State $ Sex $ DiagDate DeathDate Status $ Cat $ DiagAge;
   format DiagDate DeathDate mmddyy10.;
   label State="State of Origin"
		 DiagDate="Diagnosis Date"
		 DeathDate="Death Date"
		 Cat="Transmission Category"
		 DiagAge="Age at Diagnosis";
run;

proc print data=hw2.AUaids(obs=10) label noobs;
run;

/* c & d */
data hw2.under30;
   infile 'C:\440\hw2\AUaids.dat';
   input Obs State $ Sex $ DiagDate DeathDate Status $ Cat $ DiagAge;
   if Sex='M' and DiagAge<30 and Cat="blood";
   format DiagDate DeathDate mmddyy10.;
   label State="State of Origin"
		 DiagDate="Diagnosis Date"
		 DeathDate="Death Date"
		 Cat="Transmission Category"
		 DiagAge="Age at Diagnosis";
run;

proc print data=hw2.under30 label noobs;
run;



/* Exercise 2 */
/* a & b */
data allpatients;
   length ID $ 5 LName $ 9 FName $ 11 Plan $ 1 Blood $ 3 Allergy $ 1 AlgyType $ 2;
   infile 'C:\440\hw2\allergy.dat' dlm=',';
   input ID $ LName $ FName $ Plan $ Blood $ Allergy $ @; /* @@ also works here */

   if Allergy='N' then input Dependents @@;
   else if Allergy='Y' then input Algytype $ Dependents @@;
   /* Double trailing @@ prevents new record from being loaded. */

   label ID='ID Number'
         LName='Last Name'
         FName='First Name'
		 Plan='Plan Type'
		 Blood='Blood Type'
         Allergy='Allergy Code'
         AlgyType='Allergy Type'
         Dependents='Number of Dependents';
run;

proc print data=allpatients label;
   var FName LName Blood Allergy AlgyType Dependents;
run;


/* c & d */
data no_allergies;
   length ID $ 5 LName $ 9 FName $ 11 Plan $ 1 Blood $ 3 Allergy $ 1 AlgyType $ 2;
   infile 'C:\440\hw2\allergy.dat' dlm=',';
   input ID $ LName $ FName $ Plan $ Blood $ Allergy $ @;

   if Allergy='Y' then input Algytype $ Dependents @@; 
   /* Those with Allergy still have to be fully read in because
	  this is list input. */

	if Allergy='N';
	input Dependents @@;

   label ID='ID Number'
         LName='Last Name'
         FName='First Name'
		 Plan='Plan Type'
		 Blood='Blood Type'
         Allergy='Allergy Code'
         AlgyType='Allergy Type'
         Dependents='Number of Dependents';
run;

proc print data=no_allergies label;
   var FName LName Blood Allergy AlgyType Dependents;
run;



/* Exercise 3 */
/* a & b */
data C:\440\hw2\calories1;
   infile 'calories1.txt';
   input @1  Food $34. 
     	 @36 Per_gram 5. 
     	 @42 Per_item 4. 
     	 @48 Class $1.;
   label Per_gram="Difference in calories per gram"
         Per_item="Difference in calories per item"
		 Class="Locale Classification";
run;

proc contents data=calories1;
run;

/* c */
proc print data=calories1;
   where Per_gram < 0 and Per_item < 0;
run;

/* d & e & f */
data calories2;
   infile 'calories2.txt' dlm='09'x dsd;
   input Food :$34. Per_gram Per_item Class :$1.;
   label Per_gram="Difference in calories per gram"
         Per_item="Difference in calories per item"
		 Class="Locale Classification";
run;

proc contents data=calories2;
run;

proc print data=calories2;
   where Class='L';
run;
