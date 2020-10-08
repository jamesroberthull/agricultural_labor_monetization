*********************************************************************
**     Program Name: /home/jrhull/diss/ch3/c3prog/c3_00_cassava_01.sas
**     Programmer: james r. hull
**     Start Date: 2008 November 9
**     Purpose:
**        1.) Create var's identical to rice var's for cassava harvest
**     Input Data:
**        1.) /nangrong/data_sas/2000/current/hh00.04
**        2.) /nangrong/data_sas/2000/current/plots00.02
**
**     Output Data:
**        1.) /trainee/jrhull/diss/ch3/c3data/c3_00_c1.xpt
**
*********************************************************************;

***************
**  Options  **
***************;

options nocenter linesize=80 pagesize=60;

title1 'Program to create HH-level cassava harvest variables: 2000';

**********************
**  Data Libraries  **
**********************;

libname in00_1 xport '/nangrong/data_sas/2000/current/hh00.04';
libname in00_2 xport '/nangrong/data_sas/2000/current/plots00.02';

libname out00_1 xport '/trainee/jrhull/diss/ch3/c3data/c3_00_01.xpt';

libname extra_1 xport '/nangrong/data_sas/1994/current/hh94.03';

******************************
**  Create Working Dataset  **
******************************;

data work00_1;                                                 /*RECODES*/
     set in00_1.hh00;
     keep VILL00 HOUSE00 HHID00 VILL94 HHID94
        VILL84 HOUSE84 HHTYPE00 CASSAVA X6_91
        X6_92: X6_93 X6_94: X6_95: X6_96:
        SUGAR X6_98 X6_99: X6_100 X6_101: X101:
        X6_102: X6102: X6_103: X6103: X6_104;
run;

proc freq data=work00_1;
     tables CASSAVA X: SUGAR;
run;

proc sort data=work00_1 out=sorted94;
     by VILL94;
run;

data vill_id_fix;
     set extra_1.hh94;
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

proc sort data=vill_id_fix3 out=work00_2;
     by VILL84;
run;


*** There are only 14 HHs in 2000 that grew sugar cane ***;
*** So, I just wanted to look at them as a group below ***;

data sugar_temp;
     set work00_2;
     if sugar=1;
run;

*** create a file that just contains the basic cassava data ***;

data cassava_temp (keep=HHID00 VILL84 X6_95H: X6_95N: X6_95W:);
     set work00_2;
run;

data cassava_temp_2 (drop=X6_95H:);    /*clean up the data a bit*/
     set cassava_temp;
     HELP1=substr(X6_95H1,2,9);
     HELP2=substr(X6_95H2,2,9);
     HELP3=substr(X6_95H3,2,9);
     HELP4=substr(X6_95H4,2,9);
     HELP5=substr(X6_95H5,2,9);
     HELP6=substr(X6_95H6,2,9);

     if HELP1=999999999 then HELP1=.;
     if HELP2=999999999 then HELP2=.;
     if HELP3=999999999 then HELP3=.;
     if HELP4=999999999 then HELP4=.;
     if HELP5=999999999 then HELP5=.;
     if HELP6=999999999 then HELP6=.;

     if substr(HELP1,7,3)="999" then HELP1="";
     if substr(HELP2,7,3)="999" then HELP2="";
     if substr(HELP3,7,3)="999" then HELP3="";
     if substr(HELP4,7,3)="999" then HELP4="";
     if substr(HELP5,7,3)="999" then HELP5="";
     if substr(HELP6,7,3)="999" then HELP6="";

run;

*** reshape data so that it can become an edgefile array ***;

data cassava_temp_3(keep=HHID00 HELP X6_95N X6_95W);
     set cassava_temp_2;

     length help $ 9;

     array h(1:6) HELP1-HELP6;
     array n(1:6) X6_95N1-X6_95N6;
     array w(1:6) X6_95W1-X6_95W6;

     do i=1 to 6;
        HELP=h(i);
        X6_95N=n(i);
        X6_95W=w(i);
       if HELP ne . then output;
     end;
run;               /* this file contains just edges */

*** An attempt to clean out erroneous helping households ***;

data just_help_1;
     set cassava_temp_3;
     keep HELP;
     rename HELP=HHID00;
run;

data just_household;
     set cassava_temp_2;
     keep HHID00;
run;

data house_help no_help no_hhid00;
     merge just_household (in=a)
           just_help_1 (in=b);
     if a=1 and b=1 then output house_help;
     if a=1 and b=0 then output no_help;
     if a=0 and b=1 then output no_hhid00;
run;

 *** There appear to be no helping households without a hhid00 ***;

data just_household_comma;
     set just_household;
     comma=",";
run;

proc print data=just_household_comma noobs;
run;

data matrix_01;
     set cassava_temp_03;
     by hhid00;


     array big(1:8638)


data cassava_temp_3(keep=HHID00 HELP X6_95N X6_95W);
     set cassava_temp_2;

     length help $ 9;

     array h(1:6) HELP1-HELP6;
     array n(1:6) X6_95N1-X6_95N6;
     array w(1:6) X6_95W1-X6_95W6;

     do i=1 to 6;
        HELP=h(i);
        X6_95N=n(i);
        X6_95W=w(i);
       if HELP ne . then output;
     end;
run;















data work00_2 (drop= i j k HELP23B1-HELP23B7 HELPVT1-HELPVT13 HELPOT1-HELPOT10);
     set work00_1;

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


/* proc contents data=work00_2 varnum;
run; */

/* proc datasets library=work;
     delete work00_1;
run; */

*************************************************************
**  Freqs, means, and sd for all variables in the dataset  **
*************************************************************;

/* proc freq data=work00_2;
     tables RICE HELP23A HELPVA HELPOA /missprint;
run;

proc means data=work00_2 maxdec=2 mean std min max nmiss;
     var HELP23B HELPVB HELPOB;
run; */

******************************************************************
**  Concatenate variables A and F for groups 23, V, and O       **
**  asking about paid labor status into single strings in       **
**  order to examine a frequency distribution of all sequences  **
******************************************************************;

data work00_3 (drop=string1-string3 i); /* concatenate 'A' variables */
    set work00_2;

    length string1-string3  $ 1 CCATALLA $ 3;

    array a (3) HELP23A HELPVA HELPOA;
    array b (3) string1-string3;

    do i=1 to 3;
      if a{i}=1 then b{i}='1';
      else if a{i}=2 then b{i}='2';
      else if a{i}=3 then b{i}='3';
      else b{i}=' ';
    end;

    CCATALLA=string1||string2||string3;


    label CCATALLA="concatenation of all A variables";
run;


/* concatenate labor ?s*/


data work00_4 (drop= stringa1-stringa7 strngb1-strngb13
       strngc1-strngc10 i j k);
    set work00_3;

    length stringa1-stringa7  $ 1 CCAT23F $ 7;
    length strngb1-strngb13  $ 1 CCATVF $ 13;
    length strngc1-strngc10  $ 1 CCATOF $ 10;

    array va (7) HELP23F1-HELP23F7;
    array a (7) stringa1-stringa7;
    array vb (13) HELPVF1-HELPVF13;
    array b (13) strngb1-strngb13;
    array vc (10) HELPOF1-HELPOF10;
    array c (10) strngc1-strngc10;

    do i=1 to 7;
      if va{i}=1 then a{i}='1';
      else if va{i}=2 then a{i}='2';
      else if va{i}=3 then a{i}='3';
      else a{i}=' ';
    end;

    do j=1 to 13;
      if vb{j}=1 then b{j}='1';
      else if vb{j}=2 then b{j}='2';
      else if vb{j}=3 then b{j}='3';
      else b{j}=' ';
    end;

    do k=1 to 10;
      if vc{k}=1 then c{k}='1';
      else if vc{k}=2 then c{k}='2';
      else if vc{k}=3 then c{k}='3';
      else c{k}=' ';
    end;

    CCAT23F=stringa1||stringa2||stringa3||stringa4||stringa5||
            stringa6||stringa7;
    CCATVF=strngb1||strngb2||strngb3||strngb4||strngb5||strngb6||
        strngb7||strngb8||strngb9||strngb10||strngb11||strngb12||
        strngb13;
    CCATOF=strngc1||strngc2||strngc3||strngc4||strngc5||strngc6||
        strngc7||strngc8||strngc9||strngc10;

    CCATALLF=CCAT23F||CCATVF||CCATOF;

   label CCAT23F="concatenation of code 23 labor ?s";
   label CCATVF="concatenation of village labor ?s";
   label CCATOF="concatenation of oth vil labor ?s";
   label CCATALLF="concatenation of ALL labor ?s";

run;


/* proc freq data=work00_4;
     tables CCATALLA CCAT23F CCATVF CCATOF/ missprint;
run; */


proc datasets library=work;
     delete work00_3;
run;


data work00_5 (drop=HELPVH_1 HELPVH_2 HELPVH_3
                    HELPOH_1 HELPOH_2 HELPOH_3
                    HELP2H_1 HELP2H_2 HELP2H_3 i j k);

     set work00_4;

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

/* proc freq data=work00_5;
     tables HELPVH HELPOH HELPDV HELPDV2;
run; */

proc sort data=work00_5 out=sorted94;
     by VILL94;
run;

data vill_id_fix;
     set extra_1.hh94;
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

/* proc freq data=sorted84;
     tables VILL84*HELPDV2/ NOPERCENT NOCOL NOFREQ;
run; */

/* proc freq data=work00_5;
   tables VILL94*HELPDV VILL94*HELPDV2/ NOPERCENT NOCOL NOFREQ;
run; */

/* proc contents data=work00_5 varnum;
run; */

********************************************************************************
*** CREATE AGGREGATE MEASURES OF PERSONS WORKING (NO P-D OR WAGES AVAILABLE) ***
********************************************************************************;

*** At some point, I will label these newly created variables like a good boy ***;
*** For now, I'll just note that P=persons, PD=Person-Days, and T=Total Wages ***;
*** The rest should be self-explanatory, unless I hit my head really hard     ***;
*** PAID, FREE, and EXCH refer to Type of Labor, V, O, and 2 to Labor Source  ***;


data work00_6 (drop= i j k);
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



data out00_1.c3_00_01;
     set work00_6;
run;



/* proc datasets library=work;
     delete work00_4 work00_5;
run; */

/* proc sort data=work00_6 out=work00_7;
     by RICE;
run;

proc freq data=work00_7;
     by RICE;
     tables HELPTYPE;
run; */
