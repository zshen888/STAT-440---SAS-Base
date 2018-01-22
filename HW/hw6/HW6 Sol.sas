/*******************************
***   Homework 6 Solutions   ***
*******************************/

ods rtf file='C:\440\hw6\hw6 solution Fa15.rtf';
title 'Homework 6 Report';
option nodate pageno=1 center ls=96 ;

libname hw6 'C:\440\hw6';


/* Exercise 1 */
title2 'Exercise 1';

/*a*/
data passing failing;
   infile 'C:\440\hw6\examscores5.dat';
   array PassScore{5} _temporary_ (77, 79, 82, 76, 80);
   array Score{5};
   input ID Score1-Score5;
   NumberPassed = 0;
   do i = 1 to 5;
      NumberPassed + (Score{i} >= PassScore{i});
   end;
   if NumberPassed >= 4 then output passing;
   else output failing;
   drop i;
   label NumberPassed='Number of Exams Passed';
run;

/*b*/
title2 'Part 1b';
title4 'Students who Passed Fewer than Four Exams';
proc print data=failing noobs label;
   var ID NumberPassed;
run;



/* Exercise 2 */
title2 'Exercise 2';
proc sql;

/*a*/
title4 'Part 2a';
select PlayerID, YearID, H
   from hw6.batting
   where H > 240
   order by H desc;

/*b*/
title4 'Part 2b';
select PlayerID, min(YearID) "First Year", sum(H) "Total Hits" as TotalH
   from hw6.batting
   group by PlayerID
   having sum(H) > 3300
   order by calculated TotalH desc;

/*c*/
title4 'Part 2c';
select YearID "Year", max(HR) "Most HR's", PlayerID
   from hw6.batting
   group by YearID
   having HR=max(HR);

/*d*/
title4 'Part 2d';
select PlayerID, YearID "Year", H "Most Hits"
   from hw6.batting
   where H=(select max(H) from hw6.batting);
   /* The subquery finds a single number: the maximum number of hits
      in a single season. */

/* Alternate solution
select PlayerID, YearID "Year", H "Most Hits"
   from hw6.batting
   having H=max(H);  */

quit;



/* Exercise 3 */

title2 'Exercise 3';
proc sql;

/*a*/
create table purchase_price as
select *,
       Quantity*Price as TotalCost format=dollar10.2
   from hw6.inventory as i inner join hw6.purchase as p
   on i.Model = p.Model
;

/* Alternate solution using WHERE */
/*
select *,
       Quantity*Price as TotalCost format=dollar10.2
   from hw6.inventory as i, hw6.purchase as p
   where i.Model = p.Model
;
*/

/* Alternate solution to make the output look exactly like HW4 */
/*
select coalesce(i.Model, p.Model) as Model, 
       Price, CustNumber, Quantity,
       Quantity*Price as TotalCost format=dollar10.2
   from hw6.inventory as i, hw6.purchase as p
   where i.Model = p.Model
   order by i.Model
;
*/

/* Here's the HW4 solution for comparison. */
/*
proc sort data=hw6.purchase out=purchase;
   by Model;
run;
proc sort data=hw6.inventory out=inventory;
   by Model;
run;

data purchase_price;
   merge inventory purchase(in=inP);
   by Model;
   if inP;   * OR... if inP=1;
   TotalCost = Quantity*Price;
   format TotalCost dollar8.2;
run;

proc print data=purchase_price noobs;
run;
*/

/*b*/
title4 'Part 3b';
select * from purchase_price;
quit;

/*c*/
proc sql;
create table hw6.not_purchased as
select i.Model, Price
   from hw6.inventory as i left join hw6.purchase as p
   on i.Model = p.Model
   where p.Model = ' '
;

/* Here's the HW4 solution for comparison. */
/*
data hw6.not_purchased;
   merge inventory(in=inI) purchase(in=inP);
   by Model;
   if not inP;   * OR... if inI and not inP;
   keep Model Price;
run;

proc print data=hw6.not_purchased noobs;
run;
*/

/*d*/
title4 'Part 3d';
select * from hw6.not_purchased;

quit;


ods rtf close;
title;
