/*******************************
***   Homework 4 Solutions   ***
*******************************/

ods rtf file='C:\440\hw4\hw4 solution Fa15.rtf';
title 'Homework 4 Report';
option nodate pageno=1 center ls=96 ;

libname hw4 'C:\440\hw4';


/* Exercise 1 */
/*a*/
proc sort data=hw4.purchase out=purchase;
   by Model;
run;
proc sort data=hw4.inventory out=inventory;
   by Model;
run;

data purchase_price;
   merge inventory purchase(in=inP);
   by Model;
   if inP;   * OR... if inP=1;
   TotalCost = Quantity*Price;
   format TotalCost dollar8.2;
run;

/*b*/
title2 'Part 1b';
proc print data=purchase_price noobs;
run;

/*c*/
data hw4.not_purchased;
   merge inventory(in=inI) purchase(in=inP);
   by Model;
   if not inP;   * OR... if inI and not inP;
   keep Model Price;
run;

/*d*/
title2 'Part 1d';
proc print data=hw4.not_purchased noobs;
run;


/*e*/
data purchase_price hw4.not_purchased(keep=Model Price);
   merge inventory(in=inI) purchase(in=inP);
   by Model;
   if inP then do;
         TotalCost = Quantity*Price;
         format TotalCost dollar8.2;
         output purchase_price;
	  end;
   else if not inP then output hw4.not_purchased;
   /* OR (for this set of datasets) you could use either of the following... */
   * else if inI and not inP then output hw4.not_purchased;
   * else output hw4.not_purchased;
run;



/* Exercise 2 */

/* a,b */
/* Using _all_ will produce output for every dataset in the hw4
   library, even those from Exercises 1 and 3. */
title2 'Part 2a,b';
proc contents data=hw4._all_ ;
run;


/* c */
/* Concatenate family data from 4 quarters */
data work.fmli07;
   set hw4.fmli071(in=InQ1) hw4.fmli072(in=InQ2) 
       hw4.fmli073(in=InQ3) hw4.fmli074(in=InQ4);
   if InQ1 then QTR=1;
   else if InQ2 then QTR=2;
   else if InQ3 then QTR=3;
   else if InQ4 then QTR=4;
run;
/* d */
title2 'Part 2d';
proc contents data=work.fmli07;
run;

/* e */
/* Concatenate member data from 4 quarters */
data memi07;
   set hw4.memi071(in=InQ1) hw4.memi072(in=InQ2)
       hw4.memi073(in=InQ3) hw4.memi074(in=InQ4);
   if InQ1 then QTR=1;
   else if InQ2 then QTR=2;
   else if InQ3 then QTR=3;
   else if InQ4 then QTR=4;
run;
/* f */
title2 'Part 2f';
proc contents data=work.memi07;
run;

/* g */
/* If you trust the INT_NUM variable, you could use it in place
   of QTR in the following steps. */
proc sort data=work.fmli07;
   by CU_ID QTR;
run;
proc sort data=work.memi07;
   by CU_ID QTR;
run;
data hw4.ce07;
   merge work.fmli07 work.memi07;
   by CU_ID QTR;
run;
/* h */
title2 'Part 2h';
proc contents data=hw4.ce07;
run;

/* i */
data work.all_four;
   merge hw4.fmli071(in=InQ1) hw4.fmli072(in=InQ2) hw4.fmli073(in=InQ3) hw4.fmli074(in=InQ4);
   by CU_ID;
   if InQ1 & InQ2 & InQ3 & InQ4;  /* or... if InQ1 * InQ2 * InQ3 * InQ4; */
   keep CU_ID;
run;
/* Alternate solution 
proc freq data=fmli07 noprint;
   table CU_ID / out=temp(where=(count=4));
run;
*/

/* j */
title2 'Part 2j';
proc contents data=work.all_four;
run;


/* Challenge Question */
/* Yes, it can be done. If you trust the INT_NUM variable, you can use it. */
data work.ce07_inone;
   merge hw4.fmli071(in=InFQ1) hw4.fmli072(in=InFQ2)
         hw4.fmli073(in=InFQ3) hw4.fmli074(in=InFQ4)
         hw4.memi071(in=InMQ1) hw4.memi072(in=InMQ2)
         hw4.memi073(in=InMQ3) hw4.memi074(in=InMQ4);
   by CU_ID INT_NUM; 
   if InFQ1 or InMQ1 then QTR=1;
   else if InFQ2 or InMQ2 then QTR=2;
   else if InFQ3 or InMQ3 then QTR=3;
   else if InFQ4 or InMQ4 then QTR=4;
run;
proc contents data=work.ce07_inone;
run;



/* Exercise 3 */
/*a*/
data goalies;
   infile 'C:\440\hw4\hockey goalies 24FEB15.dat' dsd;
   input Player :$40.
         First Last GP GS W L TOL GA SA SV SV_PCT GAA SO MIN
		 v16-v20 G A PTS PIM;
   format SV_PCT percent5.2;
   label Player='NHL Player'
         First='First year of NHL career'
         Last='Last year of NHL career'
         GP='Games Played'
		 GS='Games Started'
		 W='Wins'
		 L='Losses'
		 TOL='Ties/OT/Shootout Loss'
		 GA='Goals Against'
		 SA='Shots Against'
		 SV='Saves'
		 SV_PCT='Save Percentage'
		 GAA='Goals Against Average'
		 SO='Shutouts'
		 MIN='Minutes'
         G='Goals'
         A='Assists'
         PTS='Points'
         PIM='Penalties in Minutes';
run;

/*b*/
data all;
   set hw4.skaters goalies(in=inG rename=(MIN=TOI));
   if inG then Pos='G';
run;

/*c*/
data hof;
   infile 'C:\440\hw4\hockey HOF.csv' dsd;
   input Player :$40.
         Year First Last GP1 G A PTS PM PIM
         GP2 W L TOL SV_PCT GAA;
   label Player='NHL Player'
         Year='Year inducted to HOF'
         First='First year of NHL career'
         Last='Last year of NHL career'
         GP1='Games Played as Skater'
         G='Goals'
         A='Assists'
         PTS='Points'
         PM='Plus/Minus'
         PIM='Penalties in Minutes'
         GP2='Games Played as Goalie'
		 W='Wins'
		 L='Losses'
		 TOL='Ties/OT/Shootout Loss'
		 SV_PCT='Save Percentage'
		 GAA='Goals Against Average';
run;

/* d */
proc sort data=all;
   by Player;
run;
proc sort data=hof;
   by Player;
run;
data NHLhof otherhof;
   merge all(in=inALL) hof(in=inHOF);
   by Player;
   if inALL and inHOF then output NHLhof;
   else if not inALL and inHOF then output otherhof;
run;

/* e */
title2 'Part 3e'; 
ods select Attributes;
proc contents data=NHLhof;
run;
ods select Attributes;
proc contents data=otherhof;
run;

/* f */
title2 'Part 3f'; 
proc print data=NHLhof;
   var Player First Last GP SV SV_PCT;
   where SV > 15000;
run;

/* g */
title2 'Part 3g'; 
proc print data=NHLhof;
   var Player First Last GP G SH;
   where SH > 30;
run;


ods rtf close;
title;
