libname hw4 'C:\440\hw4';

/* Question 1*/
proc print data=hw4.inventory;
run;
proc print data=hw4.purchase;
run;

proc sort data=hw4.inventory out=inv;
	by model;
run;
proc sort data=hw4.purchase out=pur;
	by model;
run;

/* a & b */
data purchase_price;
	merge inv(in=a) pur(in=b);
	by model;
	if b=1;
	totalcost=price*quantity;
run;

proc print data=purchase_price noobs;
run;

/* c & d */
data hw4.not_purchased;
	merge inv(in=a) pur(in=b);
	by model;
	if b=0;
	keep model price;
run;

proc print data=hw4.not_purchased noobs;
run;

/* e */
data hw4.purchased_price
	 hw4.not_purchased (keep=model price);
	merge inv(in=a) pur(in=b);
	by model;
	if b=1 then output hw4.purchased_price;
	if b=0 then output hw4.not_purchased;
run;

proc print data=hw4.purchased_price noobs;
run;
proc print data=hw4.not_purchased noobs;
run;





/* Question 2*/
/* a & b */
proc contents data=hw4._all_;
run;

/* c & d */
data fmli07;
	set hw4.fmli071(in=FQ1) hw4.fmli072(in=FQ2) hw4.fmli073(in=FQ3) hw4.fmli074(in=FQ4);
	if FQ1=1 then QTR=1;
	if FQ2=1 then QTR=2;
	if FQ3=1 then QTR=3;
	if FQ4=1 then QTR=4;
run;
proc contents data=fmli07;
run;

/* e & f */
data memi07;
	set hw4.memi071(in=FQ1) hw4.memi072(in=FQ2) hw4.memi073(in=FQ3) hw4.memi074(in=FQ4);
	if FQ1=1 then QTR=1;
	if FQ2=1 then QTR=2;
	if FQ3=1 then QTR=3;
	if FQ4=1 then QTR=4;
run;
proc contents data=memi07;
run;

/* g & h */
proc sort data=fmli07;
	by CU_ID QTR;
run;
proc sort data=memi07;
	by CU_ID QTR;
run;

data hw4.ce_07;
	merge fmli07 memi07;
	by CU_ID QTR;
run;
proc contents data=hw4.ce_07;
run;

/* i & j */
data four;
	merge hw4.fmli071(in=FQ1) hw4.fmli072(in=FQ2) hw4.fmli073(in=FQ3) hw4.fmli074(in=FQ4);
	by CU_ID;
	if FQ1=1 & FQ2=1 & FQ3=1 & FQ4=1;
	keep CU_ID;
run;

proc contents data=four;
run;





/* Question 3*/
/* a */
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

/* b */
data all;
	set hw4.skaters 
		hw4.goalies (in=ing rename=(MIN=TOI));
	if ing=1 then Pos='G';
run;

/* c */
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

/* d & e */
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

proc contents data=NHLhof;
	ods select Attributes;
run;
proc contents data=otherhof;
	ods select Attributes;
run;

/* f */
proc print data=NHLhof;
   var Player First Last GP SV SV_PCT;
   where SV > 15000;
run;

/* g */
proc print data=NHLhof;
   var Player First Last GP G SH;
   where SH > 30;
run;
