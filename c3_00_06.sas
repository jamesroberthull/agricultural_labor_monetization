*********************************************************************
**     Program Name: /home/jrhull/diss/ch3/c3prog/c3_00_06.sas
**     Programmer: james r. hull
**     Start Date: 2009 December 5
**     Purpose:
**        1.) Sel Model of Ag Participation and Monetization for CH 3
**     Input Data:
**        1.) /nangrong/data_sas/2000/current/hh00.04
**        2.) /nangrong/data_sas/2000/current/plots00.02
**
**     Output Data:
**        1.) /trainee/jrhull/diss/ch3/c3data/c3_00_01.xpt
**     Notes:
**        1.) This file compiles all previous files and supercedes them
**            IT GENERATES MEASUREMENTS FOR ALL HOUSEHOLDS IN THE DATA
*********************************************************************;

***************
**  Options  **
***************;

options nocenter linesize=80 pagesize=60;

%let f=06;  ** allows greater file portability **;
%let y=00;  ** allows greater file portability **;

**********************
**  Data Libraries  **
**********************;

libname in&y.&f.01 xport '/nangrong/data_sas/2000/current/hh00.04';
libname in&y.&f.02 xport '/nangrong/data_sas/2000/current/plots00.02';
libname in&y.&f.03 xport '/nangrong/data_sas/2000/current/indiv00.03';
libname in&y.&f.04 xport '/nangrong/data_sas/2000/current/comm00.02';

libname in&y.&f.05 xport '/nangrong/data_sas/1994/current/hh94.03';

libname ot&y.&f.01 xport '/trainee/jrhull/diss/ch3/c3data/c3_0001B.xpt';
libname ot&y.&f.02 xport '/trainee/jrhull/diss/ch3/c3data/c3_0002B.xpt';
libname ot&y.&f.03 xport '/trainee/jrhull/diss/ch3/c3data/c3_0003B.xpt';
libname ot&y.&f.04 xport '/trainee/jrhull/diss/ch3/c3data/c3_0005B.xpt';


**c3_00_01********************************************************************************************************;
******************************************************************************************************************;

data work&y.&f.01;                                                 /*RECODES*/
     set in&y.&f.01.hh00;
     keep VILL00 HOUSE00 HHID00 VILL94 HHID94
        VILL84 HOUSE84 HHTYPE00 RICE X6_83
        X6_84 X6_84C: X6_84W: X6_85 X6_85H: X6_85N: X6_85W:
        X6_86 X6_86l: X6_86N: X6_86W:;
     rename X6_83=HELPHH X6_84=HELP23A X6_84C1=HELP23C1
        X6_84C2=HELP23C2 X6_84C3=HELP23C3 X6_84C4=HELP23C4
        X6_84C5=HELP23C5 X6_84C6=HELP23C6 X6_84C7=HELP23C7
        X6_84W1=HELP23F1 X6_84W2=HELP23F2 X6_84W3=HELP23F3
        X6_84W4=HELP23F4 X6_84W5=HELP23F5 X6_84W6=HELP23F6
        X6_84W7=HELP23F7 X6_85=HELPVA X6_85H1=HELPVC1
        X6_85H2=HELPVC2 X6_85H3=HELPVC3 X6_85H4=HELPVC4
        X6_85H5=HELPVC5 X6_85H6=HELPVC6 X6_85H7=HELPVC7
        X6_85H8=HELPVC8 X6_85H9=HELPVC9 X6_85H10=HELPVC10
        X6_85H11=HELPVC11 X6_85H12=HELPVC12 X6_85H13=HELPVC13
        X6_85N1=HELPVE1 X6_85N2=HELPVE2 X6_85N3=HELPVE3
        X6_85N4=HELPVE4 X6_85N5=HELPVE5 X6_85N6=HELPVE6
        X6_85N7=HELPVE7 X6_85N8=HELPVE8 X6_85N9=HELPVE9
        X6_85N10=HELPVE10 X6_85N11=HELPVE11 X6_85N12=HELPVE12
        X6_85N13=HELPVE13 X6_85W1=HELPVF1 X6_85W2=HELPVF2
        X6_85W3=HELPVF3 X6_85W4=HELPVF4 X6_85W5=HELPVF5
        X6_85W6=HELPVF6 X6_85W7=HELPVF7 X6_85W8=HELPVF8
        X6_85W9=HELPVF9 X6_85W10=HELPVF10 X6_85W11=HELPVF11
        X6_85W12=HELPVF12 X6_85W13=HELPVF13 X6_86=HELPOA
        X6_86L1=HELPOC1 X6_86L2=HELPOC2 X6_86L3=HELPOC3
        X6_86L4=HELPOC4 X6_86L5=HELPOC5 X6_86L6=HELPOC6
        X6_86L7=HELPOC7 X6_86L8=HELPOC8 X6_86L9=HELPOC9
        X6_86L10=HELPOC10 X6_86N1=HELPOE1 X6_86N2=HELPOE2
        X6_86N3=HELPOE3 X6_86N4=HELPOE4 X6_86N5=HELPOE5
        X6_86N6=HELPOE6 X6_86N7=HELPOE7 X6_86N8=HELPOE8
        X6_86N9=HELPOE9 X6_86N10=HELPOE10 X6_86W1=HELPOF1
        X6_86W2=HELPOF2 X6_86W3=HELPOF3 X6_86W4=HELPOF4
        X6_86W5=HELPOF5 X6_86W6=HELPOF6 X6_86W7=HELPOF7
        X6_86W8=HELPOF8 X6_86W9=HELPOF9 X6_86W10=HELPOF10;

run;

data work&y.&f.02 (drop= i j k HELP23B1-HELP23B7 HELPVT1-HELPVT13 HELPOT1-HELPOT10);
     set work&y.&f.01;

     array b(1:7) HELP23B1-HELP23B7;
     array c(1:7) HELP23C1-HELP23C7;
     array f(1:7) HELP23F1-HELP23F7;

     array vc(1:13) HELPVC1-HELPVC13;
     array ve(1:13) HELPVE1-HELPVE13;
     array vt(1:13) HELPVT1-HELPVT13;
     array vf(1:13) HELPVF1-HELPVF13;

     array oc(1:10) HELPOC1-HELPOC10;
     array oe(1:10) HELPOE1-HELPOE10;
     array ot(1:10) HELPOT1-HELPOT10;
     array of(1:10) HELPOF1-HELPOF10;

     do i=1 to 7;
        if c(i) ne '  ' then b(i)=1;
           else b(i)=0;
       if c(i)='99' then c(i)='  ';
        if f(i)=9 then f(i)=.;
     end;

     do j=1 to 13;
        if ve(j)=99 then ve(j)=1;
        if vf(j)=9 then vf(j)=.;
        if ve(j)=. then vt(j)=0;
           else vt(j)=ve(j);
     end;

     do k=1 to 10;
        if oe(k)=99 then oe(k)=1;
        if of(k)=9 then of(k)=.;
        if oe(k)=. then ot(k)=0;
           else ot(k)=oe(k);
     end;

     if RICE=2 then RICE=0;
        else if RICE=. then RICE=0;
        else if RICE=9 then RICE=.;

     if HELPHH=99 then HELPHH=.;

     if HELP23A=2 then HELP23A=0;
        else if HELP23A=9 then HELP23A=0;
        else if HELP23A=. then HELP23A=0;

     if HELPVA=2 then HELPVA=0;
        else if HELPVA=9 then HELPVA=0;
        else if HELPVA=. then HELPVA=0;

     if HELPOA=2 then HELPOA=0;
        else if HELPOA=9 then HELPOA=0;
        else if HELPOA=. then HELPOA=0;

     HELP23B = HELP23B1+HELP23B2+HELP23B3+HELP23B4+HELP23B5+HELP23B6+HELP23B7;
     HELPVB = sum(of HELPVT1-HELPVT13);
     HELPOB = sum(of HELPOT1-HELPOT10);

     TOTHELP=HELP23B+HELPVB+HELPOB;

     if HELP23B = 0 then HELP23B = .;
     if HELPVB = 0 then HELPVB =.;
     if HELPOB = 0 then HELPOB = .;

     label HELP23B = 'Total # of code 2 and 3 helpers';
     label HELPVB = 'Total # of helpers from same village';
     label HELPOB = 'Total # of helpers from other villages';

run;

data work&y.&f.03 (drop= i j k);

     set work&y.&f.02;

     array f(1:7) HELP23F1-HELP23F7;
     array vf(1:13) HELPVF1-HELPVF13;
     array of(1:10) HELPOF1-HELPOF10;

     HELPVH_1=0;
     HELPVH_2=0;
     HELPVH_3=0;
     HELPOH_1=0;
     HELPOH_2=0;
     HELPOH_3=0;
     HELP2H_1=0;
     HELP2H_2=0;
     HELP2H_3=0;

     do k=1 to 7;
          if f(k)=1 then HELP2H_1=HELP2H_1+1;
           else if f(k)=2 then HELP2H_2=HELP2H_2+1;
           else if f(k)=3 then HELP2H_3=HELP2H_3+1;
     end;

     do i=1 to 13;
        if vf(i)=1 then HELPVH_1=HELPVH_1+1;
           else if vf(i)=2 then HELPVH_2=HELPVH_2+1;
           else if vf(i)=3 then HELPVH_3=HELPVH_3+1;
     end;

     do j=1 to 10;
        if of(j)=1 then HELPOH_1=HELPOH_1+1;
           else if of(j)=2 then HELPOH_2=HELPOH_2+1;
           else if of(j)=3 then HELPOH_3=HELPOH_3+1;
     end;

     if HELPVH_1>0 then HELPVH=1;
        else if HELPVH_2>0 | HELPVH_3>0 then HELPVH=2;
                              else HELPVH=.;
     if HELPOH_1>0 then HELPOH=1;
        else if HELPOH_2>0 | HELPOH_3>0 then HELPOH=2;
                              else HELPOH=.;

     label HELPVH= 'Used village labor 1=paid 2=unpaid';
     label HELPOH= 'Used non-village labor 1=paid 2=unpaid';

     if RICE=0 then HELPDV=1;
        else if RICE=. then HELPDV=.;
        else if HELP23A=0 & HELPVA=0 & HELPOA=0 then HELPDV=2;
        else if HELP23A=1 & HELPVA=0 & HELPOA=0 then HELPDV=3;
        else if (HELPVH ne 1 & HELPOH ne 1) & (HELPVA=1 or HELPOA=1) then HELPDV=4;
        else if HELPVH=1 & HELPOH ne 1 then HELPDV=5;
        else if HELPOH=1 & HELPVH ne 1 then HELPDV=6;
        else if HELPVH=1 & HELPOH=1 then HELPDV=7;

     if RICE=0 then HELPDV2=1;
        else if RICE=. then HELPDV2=.;
        else if HELP23A=0 & HELPVA=0 & HELPOA=0 then HELPDV2=2;
        else if HELP23A=1 & HELPVA=0 & HELPOA=0 then HELPDV2=3;
        else if (HELPVH ne 1 & HELPOH ne 1) & (HELPVA=1 or HELPOA=1) then HELPDV2=3;
        else if HELPVH=1 & HELPOH ne 1 then HELPDV2=4;
        else if HELPOH=1 & HELPVH ne 1 then HELPDV2=4;
        else if HELPVH=1 & HELPOH=1 then HELPDV2=4;


     if (HELP2H_1>0 | HELPVH_1>0 | HELPOH_1>0)
              & (HELP2H_2=0 & HELPVH_2=0 & HELPOH_2=0)
              & (HELP2H_3=0 & HELPVH_3=0 & HELPOH_3=0) then HELPTYPE=1;
        else if (HELP2H_1=0 & HELPVH_1=0 & HELPOH_1=0)
              & (HELP2H_2>0 | HELPVH_2>0 | HELPOH_2>0)
              & (HELP2H_3=0 & HELPVH_3=0 & HELPOH_3=0) then HELPTYPE=2;
        else if (HELP2H_1=0 & HELPVH_1=0 & HELPOH_1=0)
              & (HELP2H_2=0 & HELPVH_2=0 & HELPOH_2=0)
              & (HELP2H_3>0 | HELPVH_3>0 | HELPOH_3>0) then HELPTYPE=3;
        else if (HELP2H_1>0 | HELPVH_1>0 | HELPOH_1>0)
              & (HELP2H_2>0 | HELPVH_2>0 | HELPOH_2>0)
              & (HELP2H_3=0 & HELPVH_3=0 & HELPOH_3=0) then HELPTYPE=4;
        else if (HELP2H_1=0 & HELPVH_1=0 & HELPOH_1=0)
              & (HELP2H_2>0 | HELPVH_2>0 | HELPOH_2>0)
              & (HELP2H_3>0 | HELPVH_3>0 | HELPOH_3>0) then HELPTYPE=5;
        else if (HELP2H_1>0 | HELPVH_1>0 | HELPOH_1>0)
              & (HELP2H_2=0 & HELPVH_2=0 & HELPOH_2=0)
              & (HELP2H_3>0 | HELPVH_3>0 | HELPOH_3>0) then HELPTYPE=6;
        else if (HELP2H_1>0 | HELPVH_1>0 | HELPOH_1>0)
              & (HELP2H_2>0 | HELPVH_2>0 | HELPOH_2>0)
              & (HELP2H_3>0 | HELPVH_3>0 | HELPOH_3>0) then HELPTYPE=7;
        else HELPTYPE=.;

    if (HELP2H_1>0 | HELPVH_1>0 | HELPOH_1>0) then HELPDV3=1;
       else if RICE=1 then HELPDV3=0;
       else HELPDV3=.;

run;

proc sort data=work&y.&f.03 out=sorted94;
     by VILL94;
run;

data vill_id_fix;
     set in&y.&f.05.hh94;
     keep VILL94 VILL84;
run;

proc sort data=vill_id_fix out=vill_id_fix2 nodupkey;
     by VILL94;
run;

data vill_id_fix3;
     merge sorted94 (in=a drop=VILL84)
           vill_id_fix2 (in=b);
     by VILL94;
run;

proc sort data=vill_id_fix3 out=sorted84;
     by VILL84;
run;

********************************************************************************
*** CREATE AGGREGATE MEASURES OF PERSONS WORKING (NO P-D OR WAGES AVAILABLE) ***
********************************************************************************;

*** At some point, I will label these newly created variables like a good boy ***;
*** For now, I'll just note that P=persons, PD=Person-Days, and T=Total Wages ***;
*** The rest should be self-explanatory, unless I hit my head really hard     ***;
*** PAID, FREE, and EXCH refer to Type of Labor, V, O, and 2 to Labor Source  ***;

data work&y.&f.04 (drop= i j k);
      set sorted84;

      array ve(1:13) HELPVE1-HELPVE13;
      array oe(1:10) HELPOE1-HELPOE10;

      array f(1:7) HELP23F1-HELP23F7;
      array vf(1:13) HELPVF1-HELPVF13;
      array of(1:10) HELPOF1-HELPOF10;

      PAID_P_2=0;
      FREE_P_2=0;
      EXCH_P_2=0;
      PAID_P_V=0;
      FREE_P_V=0;
      EXCH_P_V=0;
      PAID_P_O=0;
      FREE_P_O=0;
      EXCH_P_O=0;

      do i=1 to 7;
         if f(i)=1 then PAID_P_2=PAID_P_2+1;
            else if f(i)=2 then FREE_P_2=FREE_P_2+1;
            else if f(i)=3 then EXCH_P_2=EXCH_P_2+1;
      end;

      do j=1 to 13;
         if vf(j)=1 then PAID_P_V=PAID_P_V+ve(j);
            else if vf(j)=2 then FREE_P_V=FREE_P_V+ve(j);
            else if vf(j)=3 then EXCH_P_V=EXCH_P_V+ve(j);
      end;

      do k=1 to 10;
         if of(k)=1 then PAID_P_O=PAID_P_O+oe(k);
            else if of(k)=2 then FREE_P_O=FREE_P_O+oe(k);
            else if of(k)=3 then EXCH_P_O=EXCH_P_O+oe(k);
      end;

      PAID_P=PAID_P_2+PAID_P_V+PAID_P_O;
      FREE_P=FREE_P_2+FREE_P_V+FREE_P_O;
      EXCH_P=EXCH_P_2+EXCH_P_V+EXCH_P_O;

      ALL_P=PAID_P+FREE_P+EXCH_P;

      if RICE=1 then HELPDV4=ALL_P;
         else HELPDV4=.;
run;

proc sort data=work&y.&f.04 out=ot&y.&f.01.c3_0001B;
     by HHID00;
run;

*c3_00_02*******************************************************************************************;
****************************************************************************************************;


*-------------------------*
*  Merge INDIV00 to HH00  *
*-------------------------*;

***Note: this becomes an individual-level file***;

data work&y.&f.05 (drop=i);
     merge in&y.&f.01.hh00 (keep=HHID00 INTMNTH1-INTMNTH6 INTDAY1-INTDAY6 INTRES1-INTRES6 in=a)
           in&y.&f.03.indiv00 (keep=HHID00 CEP00 X1 X4 X25 X26 X28 X29 CODE2 X7D X7M X7Y in=b);
     by HHID00;

     if (a=1 and b=1) and (X1=3);

*** Create MONTH and DAY ***;

     array iv1 {6} INTRES1-INTRES6;
     array iv2 {6} INTDAY1-INTDAY6;
     array iv3 {6} INTMNTH1-INTMNTH6;

     do i=1 to 6;
        if iv1{i}=1
           then do;
                  DAY=iv2{i};
                  MONTH=iv3{i};
                end;
     end;

     YEAR=2000;

*** Create IDATE, HDATE DDATE ***;

      if MONTH in (99,.) or DAY in (99,.) then IDATE=.;
         else IDATE=MDY(MONTH,DAY,YEAR);

      HDATE=MDY(10,1,1999);

      if IDATE=. or HDATE=. then DDATE=.;
         else DDATE=IDATE-HDATE;

*** Transform DDATE to months ***;

      if DDATE=. then DMONTH=.;
         else DMONTH=round(DDATE/30);

*** Create # Days Away ***;

      if (X7D=99 or X7M=99 or X7Y=99) or (X7M=. and X7Y=.) then DAYSGONE=99999;
         else if (X7D=. and X7Y ne .) then DAYSGONE=(X7Y*365);
         else DAYSGONE=X7D+(X7M*30)+(X7Y*365);

*** Round # days gone to months ***;

      if X7D=99 then MOROUND=9;
         else if X7D=. then MOROUND=.;
         else if X7D<16 then MOROUND=0;
         else if X7D>=16 then MOROUND=1;

*** Create variable # months gone ***;

      if (X7D=99 or X7M=99 or X7Y=99) or (X7M=. and X7Y=.) then MOGONE=999;
         else if (X7D=. and X7Y ne .) then MOGONE=(X7Y*12);
         else MOGONE=MOROUND+X7M+(X7Y*12);

*** Create variable # years gone ***;   /* This was created especially for the cross-tab with X25 & X28 below */

     if MOGONE < 12 then YRGONE=0;
        else if MOGONE > 11 and MOGONE < 24 then YRGONE=1;
        else if MOGONE > 23 and MOGONE < 36 then YRGONE=2;
        else if MOGONE > 35 and MOGONE < 48 then YRGONE=3;
        else if MOGONE > 47 and MOGONE < 60 then YRGONE=4;
        else if MOGONE > 59 and MOGONE < 72 then YRGONE=5;
        else if MOGONE > 71 and MOGONE < 84 then YRGONE=6;
        else if MOGONE > 83 and MOGONE < 96 then YRGONE=7;
        else if MOGONE > 95 and MOGONE < 108 then YRGONE=8;
        else if MOGONE > 107 and MOGONE < 120 then YRGONE=9;
        else if MOGONE > 119 and MOGONE < 132 then YRGONE=10;
        else if MOGONE > 131 and MOGONE < 144 then YRGONE=11;
        else if MOGONE > 143 and MOGONE < 156 then YRGONE=12;
        else if MOGONE > 155 and MOGONE < 168 then YRGONE=13;
        else if MOGONE > 167 and MOGONE < 999 then YRGONE=14;
        else if MOGONE in (999) then YRGONE=99;

*** Compare Months gone to time since 10/1/1999 ***;

      if MOGONE=999 then RICEMIG=9;
         else if (MOGONE > DMONTH and MOGONE < 72) then RICEMIG=1;
         else RICEMIG=0;

*** A second variable usin 3 years as the cut-off, not 6 years ***;

       if MOGONE=999 then RICEMIG2=9;
         else if (MOGONE > DMONTH and MOGONE < 36) then RICEMIG2=1;
         else RICEMIG2=0;

*** Create numeric equivalents (means) of remittances for aggregation ***;

      if X26=1 then REMAMT=500;
         else if X26=2 then REMAMT=2000;
         else if X26=3 then REMAMT=4000;
         else if X26=4 then REMAMT=7500;
         else if X26=5 then REMAMT=15000;
         else if X26=6 then REMAMT=30000;
         else if X26=7 then REMAMT=40000;
         else REMAMT=0;

      if X26 in (.,9) then X26=0;          /* These could be used to look at frequencies - need to be merged to final dataset */

      if X29=1 then SNDAMT=500;
         else if X29=2 then SNDAMT=2000;
         else if X29=3 then SNDAMT=4000;
         else if X29=4 then SNDAMT=7500;
         else if X29=5 then SNDAMT=15000;
         else if X29=6 then SNDAMT=30000;
         else if X29=7 then SNDAMT=40000;
         else SNDAMT=0;

      if X29 in (.,9) then X29=0;          /* These could be used to look at frequencies - need to be merged to final dataset */

run;

data work&y.&f.06;                                                                       /* Produces a HH-level data-file */
     set work&y.&f.05 (keep=HHID00 X4 X25 X28 X26 X29 REMAMT SNDAMT RICEMIG RICEMIG2);

     by HHID00;

     keep HHID00 NUMMIGM NUMMIGF NUMMIGT NUMMIGT2 RECMIG RECMIG2
          MISSMIG MISSMIG2 NUMRRCD2 NUMRRCD3 NUMRSND2 NUMRSND3 NUMREMIT NUMREMSD
          REM_ND2 REM_ND3 SREM_ND2 SREM_ND3 TOTRRCD2 TOTRRCD3 TOTRSND2 TOTRSND3 MIGREM_Y MIGREM_N;

     retain NUMMIGM NUMMIGF NUMMIGT NUMMIGT2 RECMIG RECMIG2
            MISSMIG MISSMIG2 NUMRRCD2 NUMRRCD3 NUMRSND2 NUMRSND3 NUMREMIT NUMREMSD
            REM_ND2 REM_ND3 SREM_ND2 SREM_ND3 TOTRRCD2 TOTRRCD3 TOTRSND2 TOTRSND3 MIGREM_Y MIGREM_N;

     if first.HHID00 then do;
                            NUMMIGT=0;
                            NUMMIGT2=0;
                            RECMIG=0;
                            RECMIG2=0;
                            MISSMIG=0;
                            MISSMIG2=0;
                            NUMMIGM=0;
                            NUMMIGF=0;
                            NUMREMIT=0;
                            NUMREMSD=0;
                            NUMRRCD2=0;
                            NUMRRCD3=0;
                            NUMRSND2=0;
                            NUMRSND3=0;
                            REM_ND2=0;
                            REM_ND3=0;
                            SREM_ND2=0;
                            SREM_ND3=0;
                            TOTRRCD2=0;
                            TOTRRCD3=0;
                            TOTRSND2=0;
                            TOTRSND3=0;
                            MIGREM_Y=0;
                            MIGREM_N=0;
                          end;

     if X25=1 then NUMREMIT=NUMREMIT+1;
     if X28=1 then NUMREMSD=NUMREMSD+1;

     if RICEMIG=1 and X25=1 then NUMRRCD2=NUMRRCD2+1;
        else if RICEMIG=1 and X25=9 then REM_ND2=1;

     if RICEMIG=1 and X28=1 then NUMRSND2=NUMRSND2+1;
        else if RICEMIG=1 and X28=9 then SREM_ND2=1;

     if RICEMIG2=1 and X25=1 then NUMRRCD3=NUMRRCD3+1;
        else if RICEMIG2=1 and X25=9 then REM_ND3=1;

     if RICEMIG2=1 and X28=1 then NUMRSND3=NUMRSND3+1;
        else if RICEMIG2=1 and X28=9 then SREM_ND3=1;

     if RICEMIG=1 and X4=1 then NUMMIGM=NUMMIGM+1;
        else if RICEMIG=1 and X4=2 then NUMMIGF=NUMMIGF+1;

     if RICEMIG=1 then NUMMIGT=NUMMIGT+1;
        else if RICEMIG=0 then RECMIG=RECMIG+1;
        else if RICEMIG=9 then MISSMIG=MISSMIG+1;

     if RICEMIG2=1 then NUMMIGT2=NUMMIGT2+1;
        else if RICEMIG2=0 then RECMIG2=RECMIG2+1;
        else if RICEMIG2=9 then MISSMIG2=MISSMIG2+1;

     if RICEMIG=1 then TOTRRCD2=TOTRRCD2+REMAMT;

     if RICEMIG=1 then TOTRSND2=TOTRSND2+SNDAMT;

     if RICEMIG2=1 then TOTRRCD3=TOTRRCD3+REMAMT;

     if RICEMIG2=1 then TOTRSND3=TOTRSND3+SNDAMT;

     if RICEMIG=1 and X25=1 then MIGREM_Y=MIGREM_Y+1;
        else if RICEMIG=1 then MIGREM_N=MIGREM_N+1;

     if last.HHID00 then output;
run;

data work&y.&f.07 noricefile;                            /* Merging HHs with migrants to all HHs */
     merge work&y.&f.06 (in=a)
           ot&y.&f.01.c3_0001B (in=b);
     by HHID00;
     if a=0 and b=1 then do;
                            NUMMIGM=0;
                            NUMMIGF=0;
                            NUMMIGT=0;
                            NUMMIGT2=0;
                            MISSMIG=0;
                            MISSMIG2=0;
                            RECMIG=0;
                            RECMIG2=0;
                            NUMREMIT=0;
                            NUMREMSD=0;
                            NUMRRCD2=0;
                            NUMRRCD3=0;
                            NUMRSND2=0;
                            NUMRSND3=0;
                            REM_ND2=0;
                            REM_ND3=0;
                            SREM_ND2=0;
                            SREM_ND3=0;
                            TOTRRCD2=0;
                            TOTRRCD3=0;
                            TOTRSND2=0;
                            TOTRSND3=0;
                            MIGREM_Y=0;
                            MIGREM_N=0;
                         end;

     /* if MISSMIG > 0 then NUMMIG=.;    */  /*This line forces a stricter treatment of missing data */
     if b=1 then output work&y.&f.07;
     if a=1 and b=0 then output noricefile;

run;

data ot&y.&f.02.c3_0002B;
     set work&y.&f.07;
run;


***c3_00_03*****************************************************************************************;
****************************************************************************************************;

*---------------------------------------------*
*  Assemble individual-level origin variables *
*---------------------------------------------*;

data work&y.&f.08 (keep=HHID00 CEP00 X1 AGE X4 X25 X28);
     set in&y.&f.03.indiv00 (keep=HHID00 CEP00 X1 X3 X4 X25 X28 CODE2);

     *** Recode specially coded ages to numeric equivalents ***;

        if X3=99 then AGE=0;
           else if X3=. then AGE=0; *** Code 1 missing case to 0 for composite measures ***;
           else AGE=X3;

    *** Remove duplicate code 2 cases - leave destination HH data ***;

    if CODE2 ^in (1,5);

run;

data work&y.&f.09 (keep=HHID00 AGETOTAL NUMMEMS NUMMALES NUMFEMS
                    NUMDEPCH NUMDEPEL NUMDEPS M_13_55 F_13_55 CODETWO);   /* S.B. HHID00 */
     set work&y.&f.08;
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

data work&y.&f.10;
     set work&y.&f.09;

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

data work&y.&f.11 (drop=X6_10A: X6_10B: X6_3A: X6_9T: X6_9I:
                    X6_4: X6_76: X6_81 X6_82 X6_87: WAGE: DAYS: PLANTHH PLANTOTH
                    X6_2 X6_1: WINDOW:);                                            *** S.B. HHID00 ***;
     set in&y.&f.01.hh00 (keep=VILL00 HHID00 X6_3A1 X6_3A2
                             X6_3A3 X6_3A4 X6_10A1 X6_10A2 X6_10A3 X6_10B1
                             X6_10B2 X6_10B3 X6_87A1 X6_87A2 X6_87A3 X6_87B1 X6_87B2 X6_87B3
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
        else if X6_10A1 in (0,9) then COWS=.;
        else if X6_10A1=3 then COWS=0;

     if X6_10A2 in (1,2) then BUFFALO=X6_10B2;
        else if X6_10A2 in (0,9) then BUFFALO=.;
        else if X6_10A2=3 then BUFFALO=0;

     if X6_10A3 in (1,2) then PIGS=X6_10B3;
        else if X6_10A3 in (0,9) then PIGS=.;
        else if X6_10A3=3 then PIGS=0;

     if COWS=9999 then COWS=.;
     if BUFFALO=9999 then BUFFALO=.;
     if PIGS=9999 then PIGS=.;

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

    if X6_87A1=999 then RICE_JAS=9999;
        else if X6_87A1=. then RICE_JAS=0;
        else RICE_JAS=X6_87A1*(100/15);          /* This converts from grasops to tang */

     if X6_87A2=999 then RICE_STK=9999;
        else if X6_87A2=. then RICE_STK=0;
        else RICE_STK=X6_87A2*(100/15);          /* This converts from grasops to tang */

     if X6_87A3=999 then RICE_OTH=9999;
        else if X6_87A3=. then RICE_OTH=0;
        else RICE_OTH=X6_87A3*(100/15);          /* This converts from grasops to tang */

     if RICE_JAS=9999 & RICE_STK=9999 & RICE_OTH=9999 then RICE_YLD=.;
        else if RICE_JAS=9999 & RICE_STK ne 9999 & RICE_OTH ne 9999 then RICE_YLD=RICE_STK+RICE_OTH;
        else if RICE_JAS=9999 & RICE_STK=9999 & RICE_OTH ne 9999 then RICE_YLD=RICE_OTH;
        else if RICE_JAS=9999 & RICE_STK ne 9999 & RICE_OTH=9999 then RICE_YLD=RICE_STK;
        else if RICE_JAS ne 9999 & RICE_STK=9999 & RICE_OTH ne 9999 then RICE_YLD=RICE_JAS+RICE_OTH;
        else if RICE_JAS ne 9999 & RICE_STK ne 9999 & RICE_OTH=9999 then RICE_YLD=RICE_JAS+RICE_STK;
        else if RICE_JAS ne 9999 & RICE_STK=9999 & RICE_OTH=9999 then RICE_YLD=RICE_JAS;
             else RICE_YLD=RICE_JAS+RICE_STK+RICE_OTH;

     if RICE_JAS=9999 then RICE_JAS=.;
     if RICE_STK=9999 then RICE_STK=.;
     if RICE_OTH=9999 then RICE_OTH=.;

     *** ADDITIONAL HH RICE YIELD VARS ***;

     if X6_87A1=999 then R_JAS_KG=.;
     if X6_87A1=. then R_JAS_KG=0;
        else if X6_87B1 ne . then R_JAS_KG=X6_87A1*X6_87B1;          /* This converts from grasops to kg */
        else R_JAS_KG=0;

     if X6_87A2=999 then R_STK_KG=.;
     if X6_87A2=. then R_STK_KG=0;
        else if X6_87B2 ne . then R_STK_KG=X6_87A2*X6_87B2;          /* This converts from grasops to kg */
        else R_STK_KG=0;

     if X6_87A3=999 then R_OTH_KG=.;
     if X6_87A3=. then R_OTH_KG=0;
        else if X6_87B3 ne . then R_OTH_KG=X6_87A3*X6_87B3;          /* This converts from grasops to kg */
         else R_OTH_KG=0;

     R_ALL_KG=R_JAS_KG+R_STK_KG+R_OTH_KG;


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

data work&y.&f.12;
     set in&y.&f.02.plots00 (keep=HHID00 PLANG00 X6_14NGA X6_14RAI X6_14WA X6_15NGA
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

data work&y.&f.13;
     set work&y.&f.12;

     RICEPROP=.;

     if ((RAI_U_00 ne .) and (RAI_RICE ne .) and (RAI_U_00 ne 0)) then RICEPROP=RAI_RICE/RAI_U_00;

run;

 *** Create categorical land-use variables ***;

 data work&y.&f.14;
     set work&y.&f.13;

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

data work&y.&f.15 noidvars nodata;                             /* S.B. HHID00 */
     merge work&y.&f.10 (in=a)
           in&y.&f.01.hh00 (keep= HHID00 VILL00 VILL94 in=b);
     by HHID00;
     if a=1 and b=1 then output work&y.&f.15;
     if a=1 and b=0 then output noidvars;
     if a=0 and b=1 then output nodata;
run;

proc sort data=work&y.&f.15 out=work&y.&f.16;                     /* S.B. VILL94 */
     by VILL94;
run;

data work&y.&f.17 notinhh00;                                  /* S.B. HHID00 */
     merge work&y.&f.14 (in=a)
           in&y.&f.01.hh00 (in=b keep=HHID00 VILL00 VILL94);

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

     if b=1 then output work&y.&f.17;

     if a=1 and b=0 then output notinhh00;
run;

proc sort data=work&y.&f.17 out=work&y.&f.18;                   /* S.B. VILL94 */
     by VILL94;
run;


*** Aggregated village-level variables ***;

data work&y.&f.19 (keep=VILL94 VILL1355 VILL_WAM VILL_WAF);             /* S.B. VILL94 */
     set work&y.&f.16;

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

 data work&y.&f.20;
      set work&y.&f.18;

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

data work&y.&f.21;
     set in&y.&f.04.comm00 (keep=VILL00 VILL94 X45MALE X45FEM X95 X62);

     if X45MALE=. then V_HELPM=0;
        else V_HELPM=X45MALE;
     if X45FEM=. then V_HELPF=0;
        else V_HELPF=X45FEM;

     if x62=2 then V_TOODRY=1;
        else V_TOODRY=0;

     if X95=2 then V_PHONE=0;
       else if X95=1 then V_PHONE=1;

     if V_HELPM=1 | V_HELPF=1 then V_HELP=1;
        else V_HELP=0;

run;

proc sort data=work&y.&f.21 out=work&y.&f.22;
     by VILL94;
run;

data work&y.&f.23;
     set work&y.&f.22;

     by VILL94;

     keep VILL94 VILL00 V94HELPM V94HELPF V94HELP V94DRY V94PHONE;

     retain V94HELPM V94HELPF V94HELP V94DRY V94PHONE;

     if first.VILL94 then do;
                           V94HELPM=0;
                           V94HELPF=0;
                           V94HELP=0;
                           V94DRY=0;
                           V94PHONE=0;
                         end;

     if V_TOODRY=1 then V94DRY=1;

     if V_PHONE=1 then V94PHONE=1;

     if V_HELPM=1 then V94HELPM=1;

     if V_HELPF=1 then V94HELPF=1;

     if V_HELP=1 then V94HELP=1;

     if last.VILL94 then output;

run;

***----------------------------------------------------***
*** merge variables from all levels and existing files ***
***----------------------------------------------------***;

 *** Strategy: Merge DEP VARS onto;

*** merge HH-level variables ***;

data work00_hh;
     merge work&y.&f.17 (in=a)
           work&y.&f.11 (in=b)
           work&y.&f.15 (in=c);

     by HHID00;

     if a=1 and b=1 and c=1 then output work00_hh;

run;

data work00_vil;
     merge work&y.&f.19 (in=a)
           work&y.&f.20 (in=b)
           work&y.&f.23 (in=c);

     by VILL94;

     if a=1 and b=1 and c=1 then output;

run;

****************************************************************
** Added to create just village-level data file for chapter 2 **
****************************************************************;

libname ot&y.&f.05 xport '/trainee/jrhull/diss/ch2/c2data/c3_00VLB.xpt';

data ot&y.&f.05.c3_&y.VLB;
     set work&y._vil;
run;

****************************************************************;

proc sort data=work00_hh out=work00_hha;
     by VILL94;
run;

data work00_hh_vil;
     merge work00_hha (in=a)
           work00_vil (in=b);

     by VILL94;

     if a=1 then output;

run;

proc sort data=ot&y.&f.02.c3_0002B out=c3_00_02a;
     by HHID00;
run;

proc sort data=work00_hh_vil out=work00_hh_vila;
     by HHID00;
run;


data work&y._all;
     merge work00_hh_vila (in=a)
           c3_00_02a (in=b);

    by HHID00;

    if a=1 and b=1 then output;

run;

data work&y.&f.24;
     set work&y._all (drop=HELP23A: HELP23C: HELP23F:
                           HELPVA: HELPVC: HELPVE: HELPVF:
                           HELPOA: HELPOC: HELPOE: HELPOF:
                      );

   /*  if HHTYPE00 in (1,3);   *** Keep NEW HH's in final file ***;  */



run;

*** Output dataset to library ***;

data ot&y.&f.03.c3_0003B;
     set work&y.&f.24;
run;


*c2_00_03************************************************************************************************;
*********************************************************************************************************;

********************************************************
**  Bring in Datasets and Create Additional Variables **
********************************************************;

data work&y.&f.51_1;
     set in&y.&f.01.hh00 (keep=HHID00 X6_84C: X6_84W:);
     keep HHID00 X6_86L X6_86N X6_86W LOCATION;

     length X6_86L $ 10;

     array a(1:7) X6_84C1-X6_84C7;
     array b(1:7) X6_84W1-X6_84W7;

     do i=1 to 7;
          X6_86L=a(i);
          X6_86N=1;
          X6_86W=b(i);
          LOCATION=9;
          if a(i) ne " " then output;  * Keep only those cases with data *;
     end;
run;

data work&y.&f.52_1;
     set in&y.&f.01.hh00 (keep=HHID00 X6_85H: X6_85N: X6_85W:);
     keep HHID00 X6_86L X6_86N X6_86W LOCATION;

     length X6_86L $ 10;

     array a(1:13) X6_85H1-X6_85H13;
     array b(1:13) X6_85N1-X6_85N13;
     array c(1:13) X6_85W1-X6_85W13;

     do i=1 to 13;
          X6_86L=a(i);
          X6_86N=b(i);
          X6_86W=c(i);
          if a(i)="9999999999" then LOCATION=8;
             else if substr(a(i),8,3)=999 then LOCATION=1;
             else LOCATION=0;
          if a(i) ne " " then output;  * Keep only those cases with data *;
     end;

run;

data work&y.&f.53_1;
     set in&y.&f.01.hh00 (keep=HHID00 X6_86L: X6_86N: X6_86W:);
     keep HHID00 X6_86L X6_86N X6_86W LOCATION;

     length X6_86L $ 10;

     array a(1:10) X6_86L1-X6_86L10;
     array b(1:10) X6_86N1-X6_86N10;
     array c(1:10) X6_86W1-X6_86W10;

     do i=1 to 10;
          X6_86L=a(i);
          X6_86N=b(i);
          X6_86W=c(i);
          if a(i)="9999999" then LOCATION=8;
             else if substr(a(i),1,1)=5 then LOCATION=6;
             else if substr(a(i),1,1)=4 then LOCATION=5;
             else if substr(a(i),1,2)=39 then LOCATION=3;
             else LOCATION=4;
          if a(i) ne " " then output;  * Keep only those cases with data *;
     end;
run;

 *********************************************************
 ** Take Care of Missing Data Issues - Recodes at least **
 *********************************************************;

data work&y.&f.51_2;
     set work&y.&f.51_1;

     if X6_86W=9 then X6_86W=.;
run;

data work&y.&f.52_2;
     set work&y.&f.52_1;

     if X6_86W=9 then X6_86W=.;
     if X6_86N=99 then X6_86N=1; * Assume at least 1 person worked *;
run;

data work&y.&f.53_2;
     set work&y.&f.53_1;

     if X6_86W=9 then X6_86W=.;
     if X6_86N=99 then X6_86N=1; * Assume at least 1 person worked *;
run;


**************************
** Merge files together **
**************************;

data work&y.&f.53;
     set work&y.&f.51_2
         work&y.&f.52_2
         work&y.&f.53_2;
run;

***************************************************************************
** Add V84 identifiers to 2000 data file as per Rick's suggestion on web **
***************************************************************************;

proc sort data=work&y.&f.53 out=work&y.&f.54;
     by HHID00 X6_86L LOCATION;
run;

data work&y.&f.51vill;
     set in&y.&f.03.indiv00;
     keep HHID00 V84;
run;

proc sort data=work&y.&f.51vill out=work&y.&f.52vill nodupkey;
     by HHID00 v84;
run;

data work&y.&f.53vill;
     merge work&y.&f.54 (in=a)
           work&y.&f.52vill (in=b);
           if a=1 and b=1 then output;
     by HHID00;
run;

proc sort data=work&y.&f.53vill out=work&y.&f.55;
     by V84;
run;

******************************************************************************
** This step removes all cases about which there is no information about    **
** how their laborers were compensated. This is my fix for the time being.  **
** Note: in doing so, I lose 7 cases (a case here is a helper group)        **
******************************************************************************;

data work&y.&f.56;
     set work&y.&f.55;

     if X6_86W ne . then output;

     /* if LOCATION ^= 9; */ ** DROPS ALL HHs BUT THOSE THAT USED NON-CODE 2&3 EXTRA LABOR **;
run;


***c2_00_03***VILL***HH*****************************************************************************;
****************************************************************************************************;


proc sort data=work&y.&f.56 out=work&y.&f.62;
     by HHID00;                            ** NOTE THAT SORT IS NOW BY HHID00 **;
run;

******************************************************************************
** This step removes all cases about which there is no information about    **
** how their laborers were compensated. This is my fix for the time being.  **
** Note: in doing so, I lose 7 cases (a case here is a helper group)        **
******************************************************************************;

data work&y.&f.63;
     set work&y.&f.62;

     /* if X6_86W ne . then output;      */
run;

***************************************************************
** The Following code is executed for each possible location **
***************************************************************;

** 2/15/09: I collapsed categories in 2000 0/1 ->1 3/4 -> 4 **;
** Category 7 had no cases in either year **;

* Location=1 *;

data work&y.&f.64_1 (keep=HHID00 H_NUM_T1 H_NUM_P1 H_NUM_F1);  * Collapse into HHs *;
     set work&y.&f.63 (keep=HHID00 X6_86L X6_86N X6_86W LOCATION);

     by HHID00;

  retain H_NUM_T1 H_NUM_P1 H_NUM_F1 0;

  if first.HHID00 then do;
                          H_NUM_T1=0;
                          H_NUM_P1=0;
                          H_NUM_F1=0;
                       end;

  if LOCATION in (0,1) then do;
                        H_NUM_T1=H_NUM_T1+X6_86N;
                        if X6_86W=1 then H_NUM_P1=H_NUM_P1+X6_86N;
                        if X6_86W in (2,3) then H_NUM_F1=H_NUM_F1+X6_86N;
                     end;

  if last.HHID00 then output;

run;

data work&y.&f.65_1;                                          * Create Proportion Variable *;
     set work&y.&f.64_1;

     H_PRO_P1=ROUND(H_NUM_P1/(H_NUM_T1+0.0000001),.0001);
     H_PRO_F1=ROUND(H_NUM_F1/(H_NUM_T1+0.0000001),.0001);

     if H_NUM_T1=0 then do;
                           H_NUM_T1=.;
                           H_NUM_P1=.;
                           H_NUM_F1=.;
                           H_PRO_P1=.;
                           H_PRO_F1=.;
                        end;

run;

* Location=4 *;

data work&y.&f.64_4 (keep=HHID00 H_NUM_T4 H_NUM_P4 H_NUM_F4);  * Collapse into HHs *;
     set work&y.&f.63 (keep=HHID00 X6_86L X6_86N X6_86W LOCATION);

     by HHID00;

  retain H_NUM_T4 H_NUM_P4 H_NUM_F4 0;

  if first.HHID00 then do;
                          H_NUM_T4=0;
                          H_NUM_P4=0;
                          H_NUM_F4=0;
                       end;

  if LOCATION in (3,4) then do;
                        H_NUM_T4=H_NUM_T4+X6_86N;
                        if X6_86W=1 then H_NUM_P4=H_NUM_P4+X6_86N;
                        if X6_86W in (2,3) then H_NUM_F4=H_NUM_F4+X6_86N;
                     end;

  if last.HHID00 then output;

run;

data work&y.&f.65_4;                                          * Create Proportion Variable *;
     set work&y.&f.64_4;

     H_PRO_P4=ROUND(H_NUM_P4/(H_NUM_T4+0.0000001),.0001);
     H_PRO_F4=ROUND(H_NUM_F4/(H_NUM_T4+0.0000001),.0001);

     if H_NUM_T4=0 then do;
                           H_NUM_T4=.;
                           H_NUM_P4=.;
                           H_NUM_F4=.;
                           H_PRO_P4=.;
                           H_PRO_F4=.;
                        end;

run;

* Location=5 *;

data work&y.&f.64_5 (keep=HHID00 H_NUM_T5 H_NUM_P5 H_NUM_F5);  * Collapse into HHs *;
     set work&y.&f.63 (keep=HHID00 X6_86L X6_86N X6_86W LOCATION);

     by HHID00;

  retain H_NUM_T5 H_NUM_P5 H_NUM_F5 0;

  if first.HHID00 then do;
                          H_NUM_T5=0;
                          H_NUM_P5=0;
                          H_NUM_F5=0;
                       end;

  if LOCATION=5 then do;
                        H_NUM_T5=H_NUM_T5+X6_86N;
                        if X6_86W=1 then H_NUM_P5=H_NUM_P5+X6_86N;
                        if X6_86W in (2,3) then H_NUM_F5=H_NUM_F5+X6_86N;
                     end;

  if last.HHID00 then output;

run;

data work&y.&f.65_5;                                          * Create Proportion Variable *;
     set work&y.&f.64_5;

     H_PRO_P5=ROUND(H_NUM_P5/(H_NUM_T5+0.0000001),.0001);
     H_PRO_F5=ROUND(H_NUM_F5/(H_NUM_T5+0.0000001),.0001);

     if H_NUM_T5=0 then do;
                           H_NUM_T5=.;
                           H_NUM_P5=.;
                           H_NUM_F5=.;
                           H_PRO_P5=.;
                           H_PRO_F5=.;
                        end;

run;


* Location=6 *;

data work&y.&f.64_6 (keep=HHID00 H_NUM_T6 H_NUM_P6 H_NUM_F6);  * Collapse into HHs *;
     set work&y.&f.63 (keep=HHID00 X6_86L X6_86N X6_86W LOCATION);

     by HHID00;

  retain H_NUM_T6 H_NUM_P6 H_NUM_F6 0;

  if first.HHID00 then do;
                          H_NUM_T6=0;
                          H_NUM_P6=0;
                          H_NUM_F6=0;
                       end;

  if LOCATION=6 then do;
                        H_NUM_T6=H_NUM_T6+X6_86N;
                        if X6_86W=1 then H_NUM_P6=H_NUM_P6+X6_86N;
                        if X6_86W in (2,3) then H_NUM_F6=H_NUM_F6+X6_86N;
                     end;

  if last.HHID00 then output;

run;

data work&y.&f.65_6;                                          * Create Proportion Variable *;
     set work&y.&f.64_6;

     H_PRO_P6=ROUND(H_NUM_P6/(H_NUM_T6+0.0000001),.0001);
     H_PRO_F6=ROUND(H_NUM_F6/(H_NUM_T6+0.0000001),.0001);

     if H_NUM_T6=0 then do;
                           H_NUM_T6=.;
                           H_NUM_P6=.;
                           H_NUM_F6=.;
                           H_PRO_P6=.;
                           H_PRO_F6=.;
                        end;

run;

* Location=8 *;

data work&y.&f.64_8 (keep=HHID00 H_NUM_T8 H_NUM_P8 H_NUM_F8);  * Collapse into HHs *;
     set work&y.&f.63 (keep=HHID00 X6_86L X6_86N X6_86W LOCATION);

     by HHID00;

  retain H_NUM_T8 H_NUM_P8 H_NUM_F8 0;

  if first.HHID00 then do;
                          H_NUM_T8=0;
                          H_NUM_P8=0;
                          H_NUM_F8=0;
                       end;

  if LOCATION=8 then do;
                        H_NUM_T8=H_NUM_T8+X6_86N;
                        if X6_86W=1 then H_NUM_P8=H_NUM_P8+X6_86N;
                        if X6_86W in (2,3) then H_NUM_F8=H_NUM_F8+X6_86N;
                     end;

  if last.HHID00 then output;

run;

data work&y.&f.65_8;                                          * Create Proportion Variable *;
     set work&y.&f.64_8;

     H_PRO_P8=ROUND(H_NUM_P8/(H_NUM_T8+0.0000001),.0001);
     H_PRO_F8=ROUND(H_NUM_F8/(H_NUM_T8+0.0000001),.0001);

     if H_NUM_T8=0 then do;
                           H_NUM_T8=.;
                           H_NUM_P8=.;
                           H_NUM_F8=.;
                           H_PRO_P8=.;
                           H_PRO_F8=.;
                        end;

run;

* Location=9 *;

data work&y.&f.64_9 (keep=HHID00 H_NUM_T9 H_NUM_P9 H_NUM_F9);  * Collapse into HHs *;
     set work&y.&f.63 (keep=HHID00 X6_86L X6_86N X6_86W LOCATION);

     by HHID00;

  retain H_NUM_T9 H_NUM_P9 H_NUM_F9 0;

  if first.HHID00 then do;
                          H_NUM_T9=0;
                          H_NUM_P9=0;
                          H_NUM_F9=0;
                       end;

  if LOCATION=9 then do;
                        H_NUM_T9=H_NUM_T9+X6_86N;
                        if X6_86W=1 then H_NUM_P9=H_NUM_P9+X6_86N;
                        if X6_86W in (2,3) then H_NUM_F9=H_NUM_F9+X6_86N;
                     end;

  if last.HHID00 then output;

  label H_NUM_T9='Total Number Persons Helping';
  label H_NUM_P9='Total Number Persons Helping for Pay';
  label H_NUM_F9='Total Number Persons Helping for Free';

run;

data work&y.&f.65_9;                                          * Create Proportion Variable *;
     set work&y.&f.64_9;

     H_PRO_P9=ROUND(H_NUM_P9/(H_NUM_T9+0.0000001),.0001);
     H_PRO_F9=ROUND(H_NUM_F9/(H_NUM_T9+0.0000001),.0001);

     if H_NUM_T9=0 then do;
                           H_NUM_T9=.;
                           H_NUM_P9=.;
                           H_NUM_F9=.;
                           H_PRO_P9=.;
                           H_PRO_F9=.;
                        end;

run;

*******************************************************************
**  Merge all separate HH files together, number cases=4406      **
*******************************************************************;

data work&y.&f.66;
     merge work&y.&f.65_1
           work&y.&f.65_4
           work&y.&f.65_5
           work&y.&f.65_6
           work&y.&f.65_8
           work&y.&f.65_9;
     by HHID00;
run;

proc sort data=work&y.&f.53 out=work&y.&f.57;
     by X6_86W HHID00;
run;

** NOTE: The code that follows will be affected by any **
** changes to the grouping of cases above done on 2/15 **;

** Code 2 & 3 excluded from analysis, as well as unknown location **;

** After examining the data for 1994 and 2000, I found very few cases  **
** in which a household mixed payment strategies or labor sources, so  **
** the decision to recode these variables to dichotomous indicators    **
** 0,any seems a sensible way to simplify the data analysis. For the   **
** variable H_PRO_PD, roughly 4% in either year fell between 0 and 1,  **
** while for H_PRO_OT it was somewhere near 13% in either year. 3/10    **;

data work&y.&f.68 (drop=ZIPPO);
     set work&y.&f.66;
     ZIPPO=0;     ** SLICK TRICK TO TAKE CARE OF MISSING DATA **;
     H_TOT_T=sum(of H_NUM_T1 H_NUM_T4 H_NUM_T5 H_NUM_T6 ZIPPO);
     H_TOT_P=sum(of H_NUM_P1 H_NUM_P4 H_NUM_P5 H_NUM_P6 ZIPPO);
     H_TOT_F=sum(of H_NUM_F1 H_NUM_F4 H_NUM_F5 H_NUM_F6 ZIPPO);
     H_TOT_IN=sum(of H_NUM_T1 ZIPPO);
     H_TOT_OT=sum(of H_NUM_T4 H_NUM_T5 H_NUM_T6 ZIPPO);

     H_PRO_PD=ROUND(H_TOT_P/(H_TOT_T+0.0000001),.0001);
     H_PRO_IN=ROUND(H_TOT_IN/(H_TOT_T+0.0000001),.0001);
     H_PRO_OT=ROUND(H_TOT_OT/(H_TOT_T+0.0000001),.0001);
     H_PRO_FR=ROUND(H_TOT_F/(H_TOT_T+0.0000001),.0001);

      if H_TOT_P>0 then H_ANY_PD=1;
         else H_ANY_PD=0;
      if H_TOT_F>0 then H_ANY_FR=1;
         else H_ANY_FR=0;
      if H_TOT_IN>0 then H_ANY_IN=1;
         else H_ANY_IN=0;
      if H_TOT_OT>0 then H_ANY_OT=1;
         else H_ANY_OT=0;


      if H_TOT_P >= 1 and H_TOT_F >= 1 then H_PF_11=1;
         else H_PF_11=0;
      if H_TOT_P >= 1 and H_TOT_F = 0 then H_PF_10=1;
         else H_PF_10=0;
      if H_TOT_P = 0 and H_TOT_F >= 1 then H_PF_01=1;
         else H_PF_01=0;
      if H_TOT_P =0 and H_TOT_F = 0 then H_PF_00=1;
         else H_PF_00=0;

      if H_TOT_OT >= 1 and H_TOT_IN >= 1 then H_OI_11=1;
         else H_OI_11=0;
      if H_TOT_OT >= 1 and H_TOT_IN = 0 then H_OI_10=1;
         else H_OI_10=0;
      if H_TOT_OT = 0 and H_TOT_IN >= 1 then H_OI_01=1;
         else H_OI_01=0;
      if H_TOT_OT =0 and H_TOT_IN = 0 then H_OI_00=1;
        else H_OI_00=0;

      if H_PF_10=1 then HELPDV5=1;
         else HELPDV5=0;

     /* if H_TOT_T>0; */  ** DROPS ALL HHs BUT THOSE THAT USED NON-CODE 2&3 EXTRA LABOR **;

 run;

**NEW STUFF ***********************************************************************************************;
***********************************************************************************************************;

data work&y.&f.70;
     merge work&y.&f.24 (in=a)
           work&y.&f.68 (in=b);
     by HHID&y;
     if a=1 then output;
run;

data work&y.&f.71 (drop=ru00_0 fuel_no);
     set work&y.&f.70;
     if HELPDV5=. and HELPDV3^=. then HELPDV5=0;    ** Could only be done once files were merged **;
     if ru00_0=1 then ru00_1=1;
     if fuel_no=1 then fuel_old=1;

run;

data work&y.&f.72;
     set work&y.&f.71 (keep=hhtype&y helpdv3 m_13_55 f_13_55 numdepch numdepel codetwo
                            meanage migrem_y migrem_n rai_rice riceprop plantnum
                            cassava cottage stock charcoal casset passet pcasset
                            workwage pipe_wat wind_0_1 fuel_new fuel_old
                            vill1355 vill_ric v94dry v94phone ru00_1 ru00_2
                            ru00_3 equip00 vill_rai vill94 hhid00 helpdv5
                            ru00_A plantnum workwage tothelp h_tot_t h_tot_p h_tot_f
                            v94helpm v94helpf v94help rice_yld r_all_kg );

run;

data ot&y.&f.04.c3_0005B;
     set work&y.&f.72;
run;


** CREATE STATA DATASET **;

data c3_&y.05B;
     set work&y.&f.72;
run;

%include "/bigtemp/sas_macros/savastata.mac";

%savastata(/trainee/jrhull/diss/ch3/c3data/,-x -replace);
