*********************************************************************
**     Program Name: /home/jrhull/diss/ch3/c3prog/c3_00_03.sas
**     Programmer: james r. hull
**     Start Date: 2007 09 09
**     Purpose:
**        1.) Create control variables from 2000 data, Chapter 3
**     Input Data:
**        1.) '/nangrong/data_sas/2000/current/hh00.04'
**        2.) '/nangrong/data_sas/2000/current/indiv00.03'
**        3.) '/nangrong/data_sas/2000/current/comm00.02'
**        4.) '/trainee/jrhull/diss/ch3/c3data/c3_00_02.xpt'
**        5.) '/nangrong/data_sas/2000/current/plots00.02'
**        6.) '/trainee/jrhull/diss/ch3/c3data/c3_00_01.xpt'
**     Output Data:
**        1.) '/trainee/jrhull/diss/ch3/c3data/c3_00_03.xpt'
**
*********************************************************************;

*--------------*
*   Options    *
*--------------*;

options nocenter linesize=80 pagesize=60;

title1 'Creating Control Variables: 2000 migration data';

*------------------*
*  Data Libraries  *
*------------------*;

libname in00_1 xport '/nangrong/data_sas/2000/current/hh00.04';       /* Sorted by HHID00 */
libname in00_2 xport '/nangrong/data_sas/2000/current/indiv00.03';    /* S.B. HHID00 CEP00 */
libname in00_3 xport '/nangrong/data_sas/2000/current/comm00.02';     /* S.B. VILL00 */
libname in00_4 xport '/trainee/jrhull/diss/ch3/c3data/c3_00_02.xpt';               /* S.B. HHID00 */
libname in00_5 xport '/nangrong/data_sas/2000/current/plots00.02';    /* S.B. HHID00 PLANG00 */
libname in00_6 xport '/trainee/jrhull/diss/ch3/c3data/c3_00_01.xpt';               /* S.B. HHID00 */

libname out00_1 xport '/trainee/jrhull/diss/ch3/c3data/c3_00_03.xpt';              /* S.B. HHID00 */

*---------------------------------------------*
*  Assemble individual-level origin variables *
*---------------------------------------------*;

data work00_1 (keep=HHID00 CEP00 X1 AGE X4 X25 X28);
     set in00_2.indiv00 (keep=HHID00 CEP00 X1 X3 X4 X25 X28 CODE2);

     *** Recode specially coded ages to numeric equivalents ***;

        if X3=99 then AGE=0;
           else if X3=. then AGE=0; *** Code 1 missing case to 0 for composite measures ***;
           else AGE=X3;

    *** Remove duplicate code 2 cases - leave destination HH data ***;

    if CODE2 ^in (1,5);

run;

data work00_2 (keep=HHID00 AGETOTAL NUMMEMS NUMMALES NUMFEMS
                    NUMDEPCH NUMDEPEL NUMDEPS M_13_55 F_13_55 CODETWO);   /* S.B. HHID00 */
     set work00_1;
     by HHID00;

     keep HHID00 AGETOTAL NUMMEMS NUMMALES NUMFEMS NUMDEPCH
          NUMDEPEL NUMDEPS M_13_55 F_13_55 CODETWO;

     retain AGETOTAL NUMMEMS NUMMALES NUMFEMS NUMDEPCH NUMDEPEL
            NUMDEPS M_13_55 F_13_55 CODETWO;

     if first.HHID00 then do;
                            AGETOTAL=0;
                            NUMMEMS=0;
                            NUMMALES=0;
                            NUMFEMS=0;
                            NUMDEPCH=0;
                            NUMDEPEL=0;
                            NUMDEPS=0;
                            M_13_55=0;
                            F_13_55=0;
                            CODETWO=0;
                          end;

     if X1=2 then CODETWO=CODETWO+1;

     if X1 ^in (0,2,3,9) then do;

                            if ((13 <= AGE <=55) and (X4=1))
                               then M_13_55=M_13_55+1; /*Males 13-55*/
                            if ((13 <= AGE <=55) and (X4=2))
                               then F_13_55=F_13_55+1; /*Females 13-55*/

                            if (AGE < 13) then NUMDEPCH=NUMDEPCH+1;
                            if (AGE > 55) then NUMDEPEL=NUMDEPEL+1;

                            NUMDEPS=NUMDEPCH+NUMDEPEL;

                            AGETOTAL=AGETOTAL+AGE;

                            NUMMEMS=NUMMEMS+1;

                            if X4=1 then NUMMALES=NUMMALES+1;
                               else if X4=2 then NUMFEMS=NUMFEMS+1;

                         end;

     if last.HHID00 then output;

run;


*** miscellaneous manipulations on formerly indiv-level data ***;

data work00_3;
     set work00_2;

     if NUMMEMS=0 then NUMMEMS=.;    /* There are two HHS who had no living members in 00 */

     *** Calculated HH Demography Variable ***;

    if NUMMEMS ne 0 then do;
                            MEANAGE=AGETOTAL/NUMMEMS;
                         end;
     else MEANAGE=.;
run;


*--------------------------------------------*
*  Assemble household-level origin variables *
*--------------------------------------------*;

data work00_4 (drop=X6_10A: X6_10B: X6_3A: X6_9T: X6_9I:
                    X6_4: X6_76: X6_81 X6_82 X6_87: WAGE: DAYS: PLANTHH PLANTOTH
                    X6_2 X6_1: WINDOW:);                                            *** S.B. HHID00 ***;
     set in00_1.hh00 (keep=VILL00 HHID00 X6_3A1 X6_3A2
                             X6_3A3 X6_3A4 X6_10A1 X6_10A2 X6_10A3 X6_10B1
                             X6_10B2 X6_10B3 X6_87A1 X6_87A2 X6_87A3
                             CASSAVA HHTYPE00 X6_4: X6_76: X6_81 X6_82 X6_9T: X6_9I:
                             X6_2 X6_1: WINDOW:);

     *** HH Production Variables ***;

     if X6_3A1=0 then SILK=0;
        else if X6_3A1=9 then SILK=.;
        else SILK=1;

     if X6_3A2=0 then SILKWORM=0;
       else if X6_3A2=9 then SILKWORM=.;
       else SILKWORM=1;

     if X6_3A3=0 then CLOTH=0;
       else if X6_3A3=9 then CLOTH=.;
       else CLOTH=1;

     if X6_3A4=0 then CHARCOAL=0;
       else if X6_3A3=9 then CHARCOAL=.;
       else CHARCOAL=1;

     if X6_10A1 in (1,2) then COWS=X6_10B1;
        else if X6_10A1=9 then COWS=.;
        else if X6_10A1=3 then COWS=0;

     if X6_10A2 in (1,2) then BUFFALO=X6_10B2;
        else if X6_10A2=9 then BUFFALO=.;
        else if X6_10A2=3 then BUFFALO=0;

     if X6_10A3 in (1,2) then PIGS=X6_10B3;
        else if X6_10A3=9 then PIGS=.;
        else if X6_10A3=3 then PIGS=0;

     if (COWS>1 OR PIGS>1 OR BUFFALO>1) then STOCK=1;
        else STOCK=0;

     if CASSAVA in (.,2) then CASSAVA=0;
        else if CASSAVA=9 then CASSAVA=1;

     if SILK=1 or SILKWORM=1 or CLOTH=1 then COTTAGE=1;
        else COTTAGE=0;

     *** HH Assets Variables ***;

     LTV=X6_4A1;
       if X6_4A1 eq 99 then LTV=.;
     STV=X6_4A2;
       if X6_4A2 eq 99 then STV=.;
     VIDEO=X6_4A3;
       if X6_4A3 eq 99 then VIDEO=.;
     HTELE=X6_4A4;
       if X6_4A4 eq 99 then HTELE=.;
     TELE=X6_4A5;
       if X6_4A5 eq 99 then TELE=.;
     COMPU=X6_4A6;
       if X6_4A6 eq 99 then COMPU=.;
     MIWAVE=X6_4A8;
       if X6_4A8 eq 99 then MIWAVE=.;
     WASH=X6_4A9;
       if X6_4A9 eq 99 then WASH=.;
     AC=X6_4A10;
       if X6_4A10 eq 99 then AC=.;
     RONED=X6_4A11;
       if X6_4A11 eq 99 then RONED=.;
     RTWOD=X6_4A12;
       if X6_4A12 eq 99 then RTWOD=.;
     ITAN=X6_4A13;
       if X6_4A13 eq 99 then ITAN=.;
     LMC=X6_4A15;
       if X6_4A15 eq 99 then LMC=.;
     SMC=X6_4A16;
       if X6_4A16 eq 99 then SMC=.;
     CAR=X6_4A17;
       if X6_4A17 eq 99 then CAR=.;
     TRUCK=X6_4A18;
       if X6_4A18 eq 99 then TRUCK=.;
     PICKU=X6_4A19;
       if X6_4A19 eq 99 then PICKU=.;
     SEWM=X6_4A20;
       if X6_4A20 eq 99 then SEWM=.;
     TRACTOR=x6_76T2;
       if X6_76T2 eq 9 or X6_76T2 eq . or X6_76T2 eq 2 then TRACTOR=0;
     TRACTORS=x6_76b2;
       if X6_76B2 eq 9 or X6_76B2 eq . or X6_76B2 eq 2 then TRACTORS=0;

    *** Create a variable indicating ownership of any equipment ***;

       if ((X6_76T2=1) or (X6_76B2=1) or (X6_76R2=1)) then EQUIP00=1;
           else EQUIP00=0;

    CASSET=LTV*8.513+STV*6.280+VIDEO*7.522+HTELE*3.255+COMPU*19.9+MIWAVE*7.5+WASH*7.2+AC*28.25+RONED*5;
    PASSET=ITAN*80+TRACTOR*783.75+TRACTORS*42.607+SEWM*6.4;
    PCASSET=LMC*39.857+SMC*35.750+CAR*841+PICKU*394+TRUCK*644;

    ASSET_T=CASSET+PASSET+PCASSET;


    *** HH Rice Yield ***;

    if X6_87A1=999 then RICE_JAS=999;
        else if X6_87A1=. then RICE_JAS=0;
        else RICE_JAS=X6_87A1*(100/15);          /* This converts from grasops to tang */

     if X6_87A2=999 then RICE_STK=999;
        else if X6_87A2=. then RICE_STK=0;
        else RICE_STK=X6_87A2*(100/15);          /* This converts from grasops to tang */

     if X6_87A3=999 then RICE_OTH=999;
        else if X6_87A3=. then RICE_OTH=0;
        else RICE_OTH=X6_87A3*(100/15);          /* This converts from grasops to tang */

     if RICE_JAS=999 & RICE_STK=999 & RICE_OTH=999 then RICE_YLD=.;
        else if RICE_JAS=999 & RICE_STK ne 999 & RICE_OTH ne 999 then RICE_YLD=RICE_STK+RICE_OTH;
        else if RICE_JAS=999 & RICE_STK=999 & RICE_OTH ne 999 then RICE_YLD=RICE_OTH;
        else if RICE_JAS=999 & RICE_STK ne 999 & RICE_OTH=999 then RICE_YLD=RICE_STK;
        else if RICE_JAS ne 999 & RICE_STK=999 & RICE_OTH ne 999 then RICE_YLD=RICE_JAS+RICE_OTH;
        else if RICE_JAS ne 999 & RICE_STK ne 999 & RICE_OTH=999 then RICE_YLD=RICE_JAS+RICE_STK;
        else if RICE_JAS ne 999 & RICE_STK=999 & RICE_OTH=999 then RICE_YLD=RICE_JAS;
             else RICE_YLD=RICE_JAS+RICE_STK+RICE_OTH;

     *** COUNT OF NUMBER OF RICE PLANTING HELPERS ***;

     if X6_81 = 99 then PLANTHH=.;
        else if X6_81=. then PLANTHH=0;
        else PLANTHH=X6_81;

     if X6_82 = 99 then PLANTOTH=.;
        else if X6_82=. then PLANTOTH=0;
        else PLANTOTH=X6_82;


     if PLANTHH ne . and PLANTOTH ne . then PLANTNUM=PLANTHH+PLANTOTH;


     *** COUNT OF TOTAL WAGES EARNED BY HH MEMBERS IN LOCAL LABOR MARKET ***;

     if (X6_9I1 ne 999 & X6_9T1 ne 99) then do;
                                               if X6_9I1=. then WAGE1=0;
                                                  else WAGE1=X6_9I1;
                                               if X6_9T1=. then DAYS1=0;
                                                  else DAYS1=X6_9T1;
                                               WAGELAB1=WAGE1*DAYS1;
                                            end;
        else WAGELAB1=.;

     if (X6_9I2 ne 999 & X6_9T2 ne 99) then do;
                                               if X6_9I2=. then WAGE2=0;
                                                  else WAGE2=X6_9I2;
                                               if X6_9T2=. then DAYS2=0;
                                                  else DAYS2=X6_9T2;
                                               WAGELAB2=WAGE2*DAYS2;
                                            end;
        else WAGELAB2=.;

     if (X6_9I3 ne 999 & X6_9T3 ne 99) then do;
                                               if X6_9I3=. then WAGE3=0;
                                                  else WAGE3=X6_9I3;
                                               if X6_9T3=. then DAYS3=0;
                                                  else DAYS3=X6_9T3;
                                               WAGELAB3=WAGE3*DAYS3;
                                            end;
        else WAGELAB3=.;

     if (X6_9I4 ne 999 & X6_9T4 ne 99) then do;
                                               if X6_9I4=. then WAGE4=0;
                                                  else WAGE4=X6_9I4;
                                               if X6_9T4=. then DAYS4=0;
                                                  else DAYS4=X6_9T4;
                                               WAGELAB4=WAGE4*DAYS4;
                                            end;
        else WAGELAB4=.;

     if (X6_9I5 ne 999 & X6_9T5 ne 99) then do;
                                               if X6_9I5=. then WAGE5=0;
                                                  else WAGE5=X6_9I5;
                                               if X6_9T5=. then DAYS5=0;
                                                  else DAYS5=X6_9T5;
                                               WAGELAB5=WAGE5*DAYS5;
                                            end;
        else WAGELAB5=.;


     if ((WAGELAB1 ne .) and (WAGELAB2 ne .) and (WAGELAB3 ne .)
        and (WAGELAB4 ne .) and (WAGELAB5 ne .)) then
        WORKWAGE=WAGELAB1+WAGELAB2+WAGELAB3+WAGELAB4+WAGELAB5;


     *** General HH development indicators ***;

     if x6_2=9 then PIPE_WAT=.;
        else if X6_2=2 then PIPE_WAT=0;
        else PIPE_WAT=1;

     FUEL_OLD=0;
     FUEL_NEW=0;
     FUEL_NO=0;

     if (x6_1_1=1 or x6_1_2=1) then FUEL_OLD=1;
        else if (X6_1_3=1 or X6_1_4=1 or X6_1_5=1) then FUEL_NEW=1;
        else if (X6_1_1=. & X6_1_2=. & X6_1_3=. & X6_1_4=. & X6_1_5=.) then FUEL_NO=1;
        else do;
               FUEL_OLD=0;
               FUEL_NEW=0;
               FUEL_NO=0;
             end;

     if WINDOW1=1 then WIND_0_1=0;
        else if WINDOW7 in (1,9,.) then WIND_0_1=.;
        else if WINDOW2=1 or WINDOW3=1 or WINDOW4=1 or
                WINDOW5=1 or WINDOW6=1 then WIND_0_1=1;

run;

***--------------------------------------***
*** Create HH land & rice area variables ***                    /* SAMPLE: HHs with LAND */
***--------------------------------------***;

data work00_5;
     set in00_5.plots00 (keep=HHID00 PLANG00 X6_14NGA X6_14RAI X6_14WA X6_15NGA
                               X6_15RAI X6_15WA x6_20_1);

           by HHID00;

           keep HHID00 RAI_RICE RAI_U_00;

           retain RAI_RICE RAI_U_00;

           if first.HHID00 then do;
                                  RAI_RICE=0;
                                  RAI_U_00=0;
                                end;


           if X6_14RAI ^in (9999,.) then RAI_U_00=RAI_U_00+X6_14RAI;
                         else if X6_15RAI ^in (9999,.) then RAI_U_00=RAI_U_00+X6_15RAI;
                    else if X6_14NGA ^in (99,.) then RAI_U_00=RAI_U_00+(0.25*X6_14NGA);
                         else if X6_15NGA ^in (9999,.) then RAI_U_00=RAI_U_00+(0.25*X6_15NGA);
                    else if X6_14WA ^in (9999,.) then RAI_U_00=RAI_U_00+(0.0025*X6_14WA);
                         else if X6_15WA ^in (9999,.) then RAI_U_00=RAI_U_00+(0.0025*X6_15WA);
                         else RAI_U_00=.;


           if X6_20_1=1 then do;
                               if X6_14RAI ^in (9999,.) then RAI_RICE=RAI_RICE+X6_14RAI;
                                  else if X6_15RAI ^in (9999,.) then RAI_RICE=RAI_RICE+X6_15RAI;
                               else if X6_14NGA ^in (99,.) then RAI_RICE=RAI_RICE+(0.25*X6_14NGA);
                                  else if X6_15NGA ^in (9999,.) then RAI_RICE=RAI_RICE+(0.25*X6_15NGA);
                               else if X6_14WA ^in (9999,.) then RAI_RICE=RAI_RICE+(0.0025*X6_14WA);
                                  else if X6_15WA ^in (9999,.) then RAI_RICE=RAI_RICE+(0.0025*X6_15WA);
                               else RAI_RICE=.;
                             end;

           if last.HHID00 then output;

      run;


*** miscellaneous manipulations on rice land data ***;

data work00_6;
     set work00_5;

     RICEPROP=.;

     if ((RAI_U_00 ne .) and (RAI_RICE ne .) and (RAI_U_00 ne 0)) then RICEPROP=RAI_RICE/RAI_U_00;

run;

 *** Create categorical land-use variables ***;

 data work00_7;
     set work00_6;

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



*--------------------------------------------*
*  Assemble village-level origin variables   *
*--------------------------------------------*;

*** Preliminary steps unique to 2000 data because of village boundaries definition ***;

data work00_3a noidvars nodata;                             /* S.B. HHID00 */
     merge work00_3 (in=a)
           in00_1.hh00 (keep= HHID00 VILL00 VILL94 in=b);
     by HHID00;
     if a=1 and b=1 then output work00_3a;
     if a=1 and b=0 then output noidvars;
     if a=0 and b=1 then output nodata;
run;

proc sort data=work00_3a out=work00_3b;                     /* S.B. VILL94 */
     by VILL94;
run;

data work00_7a notinhh00;                                  /* S.B. HHID00 */
     merge work00_7 (in=a)
           in00_1.hh00 (in=b keep=HHID00 VILL00 VILL94);

     by HHID00;

     if a=0 and b=1 then do;
                            RAI_U_00=0;
                            RAI_RICE=0;
                            RU00_0=0;
                            RU00_1=0;
                            RU00_2=0;
                            RU00_3=0;
                            RU00_A=0;
                            RICEPROP=0;
                         end;

     if b=1 then output work00_7a;

     if a=1 and b=0 then output notinhh00;
run;

proc sort data=work00_7a out=work00_7b;                   /* S.B. VILL94 */
     by VILL94;
run;


*** Aggregated village-level variables ***;

data work00_8 (keep=VILL94 VILL1355 VILL_WAM VILL_WAF);             /* S.B. VILL94 */
     set work00_3b;

     by VILL94;

     keep VILL1355 VILL94 VILL_WAM VILL_WAF;

     retain VILL1355 VILL_WAM VILL_WAF;

     if first.VILL94 then do;
                            VILL_WAM=0;
                            VILL_WAF=0;
                            VILL1355=0;
                          end;


     VILL_WAM=VILL_WAM+NUMMALES; /*Males 13-55*/

     VILL_WAF=VILL_WAF+NUMFEMS; /*Females 13-55*/

     VILL1355=VILL1355+NUMMALES+NUMFEMS;

     if last.VILL94 then output;

run;

 data work00_9;
      set work00_7b;

      by VILL94;

      keep VILL94 VILL_RAI VILL_RIC;

      retain VILL_RAI VILL_RIC;

      if first.VILL94 then do;
                              VILL_RAI=0;
                              VILL_RIC=0;
                           end;

      if RAI_RICE ne . then VILL_RIC=VILL_RIC+RAI_RICE;

      if RAI_U_00 ne . then VILL_RAI=VILL_RAI+RAI_U_00;

      if last.VILL94 then output;

 run;


 *** True Village-level variables ***;

data work00_10;
     set in00_3.comm00 (keep=VILL00 VILL94 X45MALE X45FEM X95 X62);

     if X45MALE=. then V_HELPM=0;
        else V_HELPM=X45MALE;
     if X45FEM=. then V_HELPF=0;
        else V_HELPF=X45FEM;

     if x62=2 then V_TOODRY=1;
        else V_TOODRY=0;

     if X95=2 then V_PHONE=0;
       else if X95=1 then V_PHONE=1;

run;

proc sort data=work00_10 out=work00_10a;
     by VILL94;
run;

data work00_10b;
     set work00_10a;

     by VILL94;

     keep VILL94 VILL00 V94HELPM V94HELPF V94DRY V94PHONE;

     retain V94HELPM V94HELPF V94DRY V94PHONE;

     if first.VILL94 then do;
                           V94HELPM=0;
                           V94HELPF=0;
                           V94DRY=0;
                           V94PHONE=0;
                         end;

     if V_TOODRY=1 then V94DRY=1;

     if V_PHONE=1 then V94PHONE=1;

     if V_HELPM=1 then V94HELPM=1;

     if V_HELPF=1 then V94HELPF=1;

     if last.VILL94 then output;

run;

***----------------------------------------------------***
*** merge variables from all levels and existing files ***
***----------------------------------------------------***;

 *** Strategy: Merge DEP VARS onto;


*** merge HH-level variables ***;

data work00_hh;
     merge work00_7a (in=a)
           work00_4 (in=b)
           work00_3a (in=c);

     by HHID00;

     if a=1 and b=1 and c=1 then output work00_hh;

run;

data work00_vil;
     merge work00_8 (in=a)
           work00_9 (in=b)
           work00_10b (in=c);

     by VILL94;

     if a=1 and b=1 and c=1 then output;

run;

proc sort data=work00_hh out=work00_hha;
     by VILL94;
run;

data work00_hh_vil;
     merge work00_hha (in=a)
           work00_vil (in=b);

     by VILL94;

     if a=1 then output;

run;

proc sort data=in00_4.c3_00_02 out=c3_00_02a;
     by HHID00;
run;

proc sort data=work00_hh_vil out=work00_hh_vila;
     by HHID00;
run;


data work00_all;
     merge work00_hh_vila (in=a)
           c3_00_02a (in=b);

    by HHID00;

    if a=1 and b=1 then output;

run;


*** Clean up dataset and label variables ***;

/* data work00_;
     set work00_;

     label AGETOTAL='sum ages of HH members';
     label BUFFALO= '# buffalo raised by HH';
     label CHARCOAL= 'HH makes charcoal: 0-no 1-yes';
     label CLOTH= 'HH makes cloth: 0-no 1-yes';
     label COWS= '# cows raised by HH';
     label COTTAGE= 'HH engages in a cottage industry';
     label F_13_55= '# working age females in HH';
     label HELPDV= 'HH rice harvest strategy measure 1';
     label HELPDV2= 'HH rice harvest strategy measure 2';
     label HH_RAI= '# rai rice paddy used by HH last year';
     label MEANAGE= 'Mean age of HH members';
     label MISSMIG= '# HH migrants of unknown duration';
     label M_13_55= '# working age males in HH';
     label NUMFEMS= '# females in HH';
     label NUMMALES= '# males in HH';
     label NUMMEMS= '# HH members';
     label NUMMIGT= '# HH migrants (left b/f last harvest)';
     label NUMMIGM= '# male HH migrants (b/f last harvest)';
     label NUMMIGF= '# female HH migrants (b/f last harvest)';
     label NUMREMIT= '# HH members remitting money';
     label NUMREMSD= '# HH members receiving money';
     label NUMRRCD2= '# HH mig (left b/f harvest) remit';
     label NUMRSND2= '# HH mig (left b/f harvest) receive';
     label NUMDEPCH= '# HH members under age 13';
     label NUMDEPEL= '# HH members over age 65';
     label NUMDEPS= '#HH members under 13 & over 65';
     label PIGS= '# pigs raised by HH';
     label RECMIG= '# HH migrants (left after last harvest)';
     label SILK= 'HH makes silk: 0-no 1-yes';
     label SILKWORM= 'HH raises silkworm 0-no 1-yes';
     label VILL_RAI= '# rai rice paddy village last yr';
     label VILL_WAF= '# working age females in village';
     label VILL_WAM= '# working age males in village';
     label RICE_YLD= '00: amount of rice yield - tangs (Q87)';
     label V_HELPM= '00: males hired for labor (Q45)';
     label V_HELPF= '00: females hired for labor (Q45)';
     label VILL1355= '# working age adults in village';
     label TOTHELP= 'Total # helpers all sources';
     label TOTHELP2= 'Total # helpers all sources (plus HH)';
     label NUMMIGT2= '# HH mig (b/f harvest) 3-yr window';
     label RECMIG2= '# HH mig (after harvest) 3-yr window';
     label MISSMIG2= '# HH mig (left unknown) 3-yr window';
     label NUMRRCD3= '# HH remit (b/f harvest) 3-yr win';
     label NURRSND3= '# HH receive (b/f harvest) 3-yr win';
     label CODETWO= '# Former HH members living in village';
run;


*** Clean up my mess ***;

proc datasets;
     delete work00_1: work00_2 work00_3 work00_4: work00_5 work00_6: work00_7
            nodata noidvars novillrai nohhidvars novilldems nodepvar nocontrols
            nosurvey nohhrai nohhlevelvars novillevelvars notinhh00;
run; */


*** Output dataset to library ***;

data out00_1.c3_00_03;
     set work00_all;
     if HHTYPE00 in (1,3);   *** Remove NEW HH's from final file ***;
run;
