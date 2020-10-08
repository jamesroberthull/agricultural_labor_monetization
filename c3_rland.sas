*********************************************************************
**     Program Name: /home/jrhull/diss/ch3/c3prog/c3_rland.sas
**     Programmer: james r. hull
**     Start Date: 2007 09 09
**     Purpose:
**        1.) Chapter3: Generate comparisons between different land var's
**     Input Data:
**        1.) '/nangrong/data/_sas/1984/current/hh84.01'
**        2.) '/nangrong/data_sas/1994/current/hh94.03'
**        3.) '/nangrong/data_sas/1994/current/plots94.01'
**        4.) '/nangrong/data_sas/2000/current/hh00.04'
**        5.) '/nangrong/data_sas/2000/current/plots00.02'
**     Output Data:
**        1.) '/trainee/jrhull/diss/ch3/c3data/c3_rland.xpt'
**        2.) '/trainee/jrhull/diss/ch3/c3data/c3_rlan2.xpt'
**        3.) '/trainee/jrhull/diss/ch3/c3data/c3_94_rl.xpt'
**        4.) '/trainee/jrhull/diss/ch3/c3data/c3_00_rl.xpt'
**
*********************************************************************;

*--------------*
*   Options    *
*--------------*;

options nocenter linesize=80 pagesize=60;

title1 '1984-1994-2000 Rice Land Variables Comparison';

*------------------*
*  Data Libraries  *
*------------------*;

libname in84_1 xport '/nangrong/data_sas/1984/current/hh84.01';
libname in94_1 xport '/nangrong/data_sas/1994/current/hh94.03';
libname in94_2 xport '/nangrong/data_sas/1994/current/plots94.01';
libname in00_1 xport '/nangrong/data_sas/2000/current/hh00.04';
libname in00_2 xport '/nangrong/data_sas/2000/current/plots00.02';

libname out_1 xport '/trainee/jrhull/diss/ch3/c3data/c3_rland.xpt';
libname out_2 xport '/trainee/jrhull/diss/ch3/c3data/c3_rlan2.xpt';
libname out94_1 xport '/trainee/jrhull/diss/ch3/c3data/c3_94_rl.xpt';
libname out00_1 xport '/trainee/jrhull/diss/ch3/c3data/c3_00_rl.xpt';


*************************************************************************
*** Gather up all variables to do with land ownership, use, and crops ***
*************************************************************************;

data work84_01;
     set in84_1.hh84 (keep=VILL84 HOUSE84 HH84_33 HH84_34 HH84_35 HH84_36);
run;

data work94_01;
     set in94_1.hh94 (keep=HHID94 HHTYPE94 VILL84 HOUSE84 Q6_14 Q6_15 Q6_27 Q6_36);
run;

data work94_02;
     set in94_2.plots94 (keep=HHID94 Q6_15P: Q6_15A: Q6_15B: Q6_15C: Q6_15E Q6_15F: Q6_15G:
                              Q6_15H: Q6_15I: Q6_15J: Q6_15K: Q6_15L: Q6_15M:);
run;

data work00_01;
     set in00_1.hh00 (keep=HHID00 HHTYPE00 HHID94 VILL84 HOUSE84 X6_11 X6_12 X6_12_1 X6_13);
run;


data work00_02;
     set in00_2.plots00 (keep=HHID00 PLANG00 X6_14: X6_15: X6_16 X6_18_: X6_20_:);
run;

/* What I want:      1984                     1994             2000              */
/*                   HHID84 #rai used/owned   HHID84 #raiu/o   HHID84 #rai u/o   */
/*                                                                               */
/* Compare across years and tabulate results as two percentage shifts: 84-94 94-00 */


*** 1984 HH Identifier linked to aggregate measures of both LAND owned and used ***;

data work84_03 (keep=VILL84 HOUSE84 RAI_O_84 RAI_U_84);
     set work84_01;

     if HH84_33=998 then RAI_O_84=0;
         else if HH84_33=999 then RAI_O_84=.;
         else RAI_O_84=HH84_33;

     if HH84_34=998 then RAI_U_84=0;
         else if HH84_34=999 then RAI_U_84=.;
         else RAI_U_84=HH84_34;

run;

/* proc freq data=work84_03;
     table RAI_U_84 RAI_O_84/missing;
run; */


*** 1984 HH Identifier linked to 1994 aggreagate measures of LAND OWNED ***;

data work94_03a (keep=HHID94 RAI_O_94 MISCOUNT PLANGNUM);                      /* S.B. HHID94 */
     set work94_02 (keep=HHID94 Q6_15C);

     by HHID94;

     keep HHID94 RAI_O_94 MISCOUNT PLANGNUM;


     retain RAI_O_94 MISCOUNT PLANGNUM;

     if first.HHID94 then do;
                            RAI_O_94=0;
                            MISCOUNT=0;
                            PLANGNUM=0;
                          end;

      PLANGNUM=PLANGNUM+1;

      if Q6_15C in (99999,.) then do;       ***Automatically converts to RAI***;
                                     RAI_O_94=RAI_O_94+0;
                                     MISCOUNT=MISCOUNT+1;
                                  end;
         else if Q6_15C=99995 then RAI_O_94=RAI_O_94+250;
         else RAI_O_94=RAI_O_94+(Q6_15C*0.0025);

     if last.HHID94 then output;

run;

/* proc freq data=work94_03a;
     table RAI_O_94/missing;
run; */

data work94_03 (keep=HHID94 RAI_O_94);
     set work94_03a;

     if MISCOUNT=PLANGNUM then RAI_O_94=.;
run;

data work94_04 (keep=HHID94 HHTYPE94 VILL84 HOUSE84 RAI_O_94);
     merge work94_03 (in=a)
           work94_01 (in=b);
     by HHID94;

     if b=1 then output work94_04;
run;

/* proc freq data=work94_04;
     table RAI_O_94/missing;
run; */

/*Count number of HH with any land */

/* proc sort data=work94_02 out=work94_test nodupkey;
     by HHID94;
run;

proc freq data=work94_test;
      tables HHID94;
run; */

*** Create Categorical Variables for just full 1994 dataset ***;

data work94_05;
     set work94_04;

     RO94_0=0;
     RO94_1=0;
     RO94_2=0;
     RO94_3=0;

     RO94_A=.;

    if RAI_O_94=0 then RO94_0=1;
        else if (RAI_O_94>0 & RAI_O_94 <15) then RO94_1=1;
        else if (RAI_O_94>=15 & RAI_O_94 <45) then RO94_2=1;
        else if RAI_O_94>=45 then RO94_3=1;
        else if RAI_O_94 = . then do;
                                     RO94_0=.;
                                     RO94_1=.;
                                     RO94_2=.;
                                     RO94_3=.;
                                  end;

     if RO94_0=1 then RO94_A=1;
     if RO94_1=1 then RO94_A=1;
     if RO94_2=1 then RO94_A=2;
     if RO94_3=1 then RO94_A=3;

run;


data out94_1.c3_94_rl;
        set work94_05 (drop=VILL84 HOUSE84);
run;


*** 1984 HH Identifier linked to 2000 aggreagate measures of LAND USED ***;

data work00_03;
     set work00_02 (keep=HHID00 PLANG00 X6_20_1 X6_14NGA X6_14RAI X6_14WA X6_15NGA
                         X6_15RAI X6_15WA);

     by HHID00;

     keep HHID00 RAI_U_00;

     retain RAI_U_00;

     if first.HHID00 then do;
                            RAI_U_00=0;
                          end;

     if X6_14RAI ^in (9999,.) then RAI_U_00=RAI_U_00+X6_14RAI;
             else if X6_15RAI ^in (9999,.) then RAI_U_00=RAI_U_00+X6_15RAI;
        else if X6_14NGA ^in (99,.) then RAI_U_00=RAI_U_00+(0.25*X6_14NGA);
             else if X6_15NGA ^in (9999,.) then RAI_U_00=RAI_U_00+(0.25*X6_15NGA);
        else if X6_14WA ^in (9999,.) then RAI_U_00=RAI_U_00+(0.0025*X6_14WA);
             else if X6_15WA ^in (9999,.) then RAI_U_00=RAI_U_00+(0.0025*X6_15WA);
             else RAI_U_00=.;

     if last.HHID00 then output;

run;

data work00_04 (keep=HHID00 HHTYPE00 HHID94 VILL84 HOUSE84 RAI_U_00);
     merge work00_03 (in=a)
           work00_01 (in=b);
     by HHID00;

     if (b=1 and a=0) and (X6_11 ne 99) then RAI_U_00=0;
          else IF a=0 then RAI_U_00=.;

     if b=1 then output work00_04;
run;


*** Creating Categorical Variables just for full 2000 dataset ***;

data work00_05;
     set work00_04;

     RU00_0=0;
     RU00_1=0;
     RU00_2=0;
     RU00_3=0;

     RU00_A=.;

    if RAI_U_00=0 then RU00_0=1;
        else if (RAI_U_00>0 & RAI_U_00 <15) then RU00_1=1;
        else if (RAI_U_00>=15 & RAI_U_00 <45) then RU00_2=1;
        else if RAI_U_00>=45 then RU00_3=1;
        else if RAI_U_00 = . then do;
                                     RU00_0=.;
                                     RU00_1=.;
                                     RU00_2=.;
                                     RU00_3=.;
                                  end;

     if RU00_0=1 then RU00_A=1;
     if RU00_1=1 then RU00_A=1;
     if RU00_2=1 then RU00_A=2;
     if RU00_3=1 then RU00_A=3;

run;

data out00_1.c3_00_rl;
        set work00_05 (drop=VILL84 HOUSE84);
run;

/* proc freq data=work00_04;
     table RAI_U_00/missing;
run; */


*********************************************************************************;
*** MERGING 1984, 1994, and 2000 by VILL84 and HOUSE84 ***;


proc sort data=work00_04 out=work00_04s;       ***1994 & 2000 ***;
     by HHID94;
run;

data workc_01 no1994data no2000data;
     merge work00_04s (in=a)
           work94_04 (in=b);
     by HHID94;

     if a=1 and b=1 then output workc_01;
     if a=1 and b=0 then output no1994data;
     if a=0 and b=1 then output no2000data;

run;

proc sort data=workc_01 out=workc_01s;       *** 84/94 & 2000 ***;
     by VILL84 HOUSE84;
run;

data workc_02 no9400data no1984data;
     merge work84_03 (in=a)
           workc_01s (in=b);
     by VILL84 HOUSE84;

     if a=1 and b=1 then output workc_02;
     if a=1 and b=0 then output no9400data;
     if a=0 and b=1 then output no1984data;

run;


/* Generate Difference variables and plot for 3-year comparision */

data workc_03;
     set workc_02;
     if (RAI_O_94 ne . & RAI_O_84 ne .) then DIFF8494=RAI_O_94-RAI_O_84;
        else DIFF8494=.;
     if (RAI_U_00 ne . & RAI_O_94 ne .) then DIFF9400=RAI_U_00-RAI_O_94;
        else DIFF9400=.;
     if (RAI_U_00 ne . & RAI_U_84 ne .) then DIFF8400=RAI_U_00-RAI_U_84;
        else DIFF8400=.;
run;

/* proc means data=workc_03;
     vars DIFF8494 DIFF9400 DIFF8400;
run; */


/* Code Categorical Variables for 3-year comparison */

data workc_04;
     set workc_02;

     RO84_0=0;
     RO84_1=0;
     RO84_2=0;
     RO84_3=0;

     RU84_0=0;
     RU84_1=0;
     RU84_2=0;
     RU84_3=0;

     RO94_0=0;
     RO94_1=0;
     RO94_2=0;
     RO94_3=0;

     RU00_0=0;
     RU00_1=0;
     RU00_2=0;
     RU00_3=0;

     RO84_A=.;
     RU84_A=.;
     RO94_A=.;
     RU00_A=.;


     if RAI_O_84=0 then RO84_0=1;
        else if (RAI_O_84>0 & RAI_O_84 <15) then RO84_1=1;
        else if (RAI_O_84>=15 & RAI_O_84 <45) then RO84_2=1;
        else if RAI_O_84>=45 then RO84_3=1;
        else if RAI_O_84 = . then do;
                                     RO84_0=.;
                                     RO84_1=.;
                                     RO84_2=.;
                                     RO84_3=.;
                                  end;

     if RAI_U_84=0 then RU84_0=1;
        else if (RAI_U_84>0 & RAI_U_84 <15) then RU84_1=1;
        else if (RAI_U_84>=15 & RAI_U_84 <45) then RU84_2=1;
        else if RAI_U_84>=45 then RU84_3=1;
        else if RAI_U_84 = . then do;
                                     RU84_0=.;
                                     RU84_1=.;
                                     RU84_2=.;
                                     RU84_3=.;
                                  end;

    if RAI_O_94=0 then RO94_0=1;
        else if (RAI_O_94>0 & RAI_O_94 <15) then RO94_1=1;
        else if (RAI_O_94>=15 & RAI_O_94 <45) then RO94_2=1;
        else if RAI_O_94>=45 then RO94_3=1;
        else if RAI_O_94 = . then do;
                                     RO94_0=.;
                                     RO94_1=.;
                                     RO94_2=.;
                                     RO94_3=.;
                                  end;

    if RAI_U_00=0 then RU00_0=1;
        else if (RAI_U_00>0 & RAI_U_00 <15) then RU00_1=1;
        else if (RAI_U_00>=15 & RAI_U_00 <45) then RU00_2=1;
        else if RAI_U_00>=45 then RU00_3=1;
        else if RAI_U_00 = . then do;
                                     RU00_0=.;
                                     RU00_1=.;
                                     RU00_2=.;
                                     RU00_3=.;
                                  end;


     if RO84_0=1 then RO84_A=1;
     if RO84_1=1 then RO84_A=1;
     if RO84_2=1 then RO84_A=2;
     if RO84_3=1 then RO84_A=3;

     if RU84_0=1 then RU84_A=1;
     if RU84_1=1 then RU84_A=1;
     if RU84_2=1 then RU84_A=2;
     if RU84_3=1 then RU84_A=3;

     if RO94_0=1 then RO94_A=1;
     if RO94_1=1 then RO94_A=1;
     if RO94_2=1 then RO94_A=2;
     if RO94_3=1 then RO94_A=3;

     if RU00_0=1 then RU00_A=1;
     if RU00_1=1 then RU00_A=1;
     if RU00_2=1 then RU00_A=2;
     if RU00_3=1 then RU00_A=3;

     RCAT_ALL=RO84_A||RU84_A||RO94_A||RU00_A;

run;

proc freq data=workc_04;
     tables RO84_A RU84_A RO94_A RU00_A;
run;

proc means data=workc_04;
     vars RAI_O_84 RAI_U_84 RAI_O_94 RAI_U_00;
run;


/* Generate Difference variables and plot for 2-year comparision */

data workc2_01;
     set workc_01;
     if (RAI_U_00 ne . & RAI_O_94 ne .) then DIFF9400=RAI_U_00-RAI_O_94;
        else DIFF9400=.;
run;

/* proc means data=workc2_01;
     vars DIFF9400;
run; */


/* Code Categorical Variables for 2-year comparison */

data workc2_02;
     set workc2_01;

     RO94_0=0;
     RO94_1=0;
     RO94_2=0;
     RO94_3=0;

     RU00_0=0;
     RU00_1=0;
     RU00_2=0;
     RU00_3=0;

     RO94_A=.;
     RU00_A=.;

    if RAI_O_94=0 then RO94_0=1;
        else if (RAI_O_94>0 & RAI_O_94 <15) then RO94_1=1;
        else if (RAI_O_94>=15 & RAI_O_94 <45) then RO94_2=1;
        else if RAI_O_94>=45 then RO94_3=1;
        else if RAI_O_94 = . then do;
                                     RO94_0=.;
                                     RO94_1=.;
                                     RO94_2=.;
                                     RO94_3=.;
                                  end;

    if RAI_U_00=0 then RU00_0=1;
        else if (RAI_U_00>0 & RAI_U_00 <15) then RU00_1=1;
        else if (RAI_U_00>=15 & RAI_U_00 <45) then RU00_2=1;
        else if RAI_U_00>=45 then RU00_3=1;
        else if RAI_U_00 = . then do;
                                     RU00_0=.;
                                     RU00_1=.;
                                     RU00_2=.;
                                     RU00_3=.;
                                  end;


     if RO94_0=1 then RO94_A=1;
     if RO94_1=1 then RO94_A=1;
     if RO94_2=1 then RO94_A=2;
     if RO94_3=1 then RO94_A=3;

     if RU00_0=1 then RU00_A=1;
     if RU00_1=1 then RU00_A=1;
     if RU00_2=1 then RU00_A=2;
     if RU00_3=1 then RU00_A=3;

     RCAT_ALL=RO94_A||RU00_A;

run;

proc freq data=workc2_02;
     tables RO94_A RU00_A RCAT_ALL;
run;

proc means data=workc2_02;
     vars RAI_O_94 RAI_U_00;
run;



data out_1.c3_rland;
     set workc_04;
run;

data out_2.c3_rlan2;
     set workc2_02;
run;


/* data work00_4c;                                       S.B. HHID00
     set work00_4b;

     if HH_RAI=. then HH_RAI=0;   Treat missing as 0 for village calc's
run;

*** sort HH-level data by VILL94 before collapsing to village-level ***;

proc sort data=work00_4c out=work00_4d;                 S.B. VILL94
     by VILL94;
run;

data work00_4e;                                         S.B. VILL94
     set work00_4d;

     by VILL94;

     keep VILL94 VILL_RAI;

     retain VILL_RAI;

     if first.VILL94 then do;
                            VILL_RAI=0;
                          end;

     if HH_RAI ne 999999 then VILL_RAI=VILL_RAI+HH_RAI;
        else VILL_RAI=VILL_RAI;

     if last.VILL94 then output; */
