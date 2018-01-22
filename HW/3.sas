libname hw3 'C:\440\hw3';

/* Exercise 1 */
/* a */
data shoes_tracker;
   set hw3.shoes_tracker;
   Supplier_Country=upcase(Supplier_Country);
   Product_Name=propcase(Product_Name);

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
run;

proc print data=hw3.shoes_tracker;
run;
proc print data=shoes_tracker;
run;

/* b */
proc freq data=shoes_tracker nlevels;
   tables _all_ / noprint;
run;

proc print data=shoes_tracker;
   where Product_Category=' ' or
         Supplier_Country NOT in ('GB','US') or
		 Supplier_Name NOT in ('3Top Sports' 'Greenline Sports Ltd') or
		 Supplier_ID NOT in (2963 14682) or
         propcase(Product_Name) NE Product_Name;
run;

proc freq data=shoes_tracker;
   tables Supplier_Name*Supplier_ID / nocum nopercent norow nocol missing; 
   tables Supplier_Country;
run;

proc means data=shoes_tracker min max range fw=12;
   var Product_ID;
   class Supplier_Name;
run;  



/* Exercise 2 */
/* a & b */
data rushing;
   infile 'C:\440\hw3\badrush.txt' dlm='09'x dsd;

   input Season Player :$30. @;
   		if Player NE 'Matt Forte' then
      		input Team:$3. Games Att:comma5. Yds:comma5. Avg YPG Lg TD FD;
   		else do;
      		Team = 'Chi';
      		input Games Att:comma5. Yds:comma5. Avg YPG Lg TD FD;
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

proc contents data=rushing;
run;

/* c */
/* Copy and Paste the Log */

/* d */
proc freq data=rushing nlevels;
   table _all_ / noprint;
run;

proc freq data=rushing;
   table Season;
run;

proc means data=rushing n nmiss min max;
   var Games Lg Att TD FD;
run;

proc univariate data=rushing;
   var Games Lg Att;
   ods select ExtremeObs;
run;

proc print data=rushing(firstobs=504 obs=504);
run;

proc print data=rushing;
   var Season Player Yds Att Avg;
   where round(Yds/Att, .01) ^= Avg;
run;
proc print data=rushing;
   var Season Player Yds Games YPG;
   where round(Yds/Games, .1) ^= YPG;
run;

proc print data=rushing;
   var Season Player Yds Lg Avg YPG;
   where Lg < 0 and Yds >= 0;
run;


/*e*/
title2 'Part 2e';
data rush;
   set rushing;
   if Season=2012 and Player='Daryl Richardson' then TD=0;
   else if Season=2011 and Player='Mike Kafka' then Yds=0;
   else if Season=2010 and Player='Moran Norris' then Avg=0;

   if Season = 1912 then Season = 2012;
   else if Season = 20010 then Season = 2010;
   else if Season = 20111 then Season = 2011; 

   if Player=' ' then Player='LeSean McCoy';

   if Games=0.16 then Games=16; 

   if Lg=910 then Lg=91;
   else if Lg=2800 then Lg=28;
   else if Season=2012 and Player='Raymond Ventrone' then Lg = 35;

   if Season=2013 and Player='Riley Cooper' then Att=1;

   Avg = round(Yds/Att, .01);
   YPG = round(Yds/Games, .1);
run;

/* f */
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
