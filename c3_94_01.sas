*********************************************************************
**     Program Name: /home/jrhull/diss/ch3/c3prog/c3_94_01.sas
**     Programmer: james r. hull
**     Start Date: 2007 SEPTEMBER 7
**     Purpose:
**        1.) Create variables for first go at chapter 3 - PAA 08
**     Input Data:
**        1.) /nangrong/data_sas/1994/current/hh94.02
**        2.) /nangrong/data_sas/1994/current/helprh94.01
**     Output Data:
**        1.) /trainee/jrhull/diss/ch3/c3data/c3_94_01.xpt
**
*********************************************************************;

***************
**  Options  **
***************;

options nocenter linesize=80 pagesize=60;

title1 'Program to create HH-level rice harvest variables';

**********************
**  Data Libraries  **
**********************;

libname in94_1 xport '/nangrong/data_sas/1994/current/hh94.03';
libname in94_2 xport '/nangrong/data_sas/1994/current/helprh94.01';

libname out94_1 xport '/trainee/jrhull/diss/ch3/c3data/c3_94_01.xpt';


******************************
**  Create Working Dataset  **
******************************;

***********************************************************
**  Variables initially in Work1 dataset:
**
**  hhid94 = 1994 identifiers
**  hhtype94
**  lekti94
**  vill94
**  lekti84 = 1984 identifiers
**  vill84
**  house84
**  hhid84
**  Q6_16 = In the last year, did this household grow rice?
**  Q6_17 = In the last year, how many rai did this
**          household plant in rice?
**  Q6_18 = In the last year, during what months did
**          this household plant rice?
**  Q6_19 = In the last year, how long did it take to
**          plant rice?
**  Q6_20 = In the last year, this household used how
**          many people to plant rice?
**  Q6_21 = In the last year, this household harvested
**          rice during which months?
**  Q6_22 = In the last year, how much rice was harvested?
**  Q6_23 = Number of people coded 2 or 3 on Q1.1 who
**          helped with harvesting rice last year.
**  Q23A1-5 = CEP94 # from form 1
**  Q23B1-5 = Number of days
**  Q23C1-5 = Type of labor (Hired, Helped without pay,
**            N/A, missing)
**  Q23D1-5 = Wage per day
**  f6fFL = Does this household have form 6 data?
**
**  These variables come from the social network file:
**
**  Q6_24A = Did anyone from this village (or another village)
**           help to harvest rice in the last year?
**  Q6_24B = Number of people
**  Q6_24C = Number of days
**  Q6_24D = Type of labor (hired, helped without pay,
**           worked together)
**  Q6_24E = Wage per day
************************************************************;


data work94_1;
     set in94_1.hh94;
     keep hhid94 hhtype94 lekti84 vill84 house84 hhid84 lekti94 vill94
          Q6_16 Q6_17 Q6_18 Q6_19 Q6_20 Q6_21 Q6_22 Q6_23
          Q6_23A: Q6_23B: Q6_23C: Q6_23D:;
     rename Q6_16=RICE Q6_23=HELP23B Q6_23A1=HELP23C1 Q6_23A2=HELP23C2
          Q6_23A3=HELP23C3 Q6_23A4=HELP23C4 Q6_23A5=HELP23C5
          Q6_23B1=HELP23D1 Q6_23B2=HELP23D2 Q6_23B3=HELP23D3
          Q6_23B4=HELP23D4 Q6_23B5=HELP23D5 Q6_23C1=HELP23F1
          Q6_23C2=HELP23F2 Q6_23C3=HELP23F3 Q6_23C4=HELP23F4
          Q6_23C5=HELP23F5 Q6_23D1=HELP23G1 Q6_23D2=HELP23G2
          Q6_23D3=HELP23G3 Q6_23D4=HELP23G4 Q6_23D5=HELP23G5;

run;

/* proc contents data=work94_1 varnum;
run; */


*****************************************************************
**  Separate helping households into same and different villages
*****************************************************************;

/*NEED TO DOUBLE CHECK THE GROUPING OF THE CASES IN THE NEXT STEP*/


data work94_2;
     set in94_2.helprh94 (keep=hhid94 Q6_24A Q6_24B Q6_24C Q6_24D Q6_24E);

     if substr(Q6_24A,1,3)='000' then LOCATION=1; /* outside village */
        else if Q6_24A in ('9999997','9999999') then LOCATION=.; /* missing */
        else LOCATION=0; /* inside village */
run;

data village othervi noinfo;
     set work94_2;
     if LOCATION=0 then output village;
        else if LOCATION=1 then output othervi;
        else output noinfo;
run;

/*Used this code to check the max number of cases*/

/* proc freq data=village;
     tables HHID94;
run;

proc freq data=othervi;
     tables HHID94;
run;

proc freq data=noinfo;
     tables HHID94;
run;

proc means data=village mean median stddev;
run;

proc means data=othervi mean median stddev;
run;

proc means data=noinfo mean median stddev;
run; */

*****************************************************************
**  Un-stack data in helprh94 to create single cases for each HH
*****************************************************************;

/*File othervi - max number of variables is 4*/

data work94_3 (keep=HELPOC1-HELPOC4 HELPOE1-HELPOE4 HELPOD1-HELPOD4
     HELPOF1-HELPOF4 HELPOG1-HELPOG4 HHID94);
     set othervi (rename=(Q6_24A=HELPOC Q6_24B=HELPOE Q6_24C=HELPOD
      Q6_24D=HELPOF Q6_24E=HELPOG));

   by HHID94;

   length HELPOC1-HELPOC4 $ 7;

   retain HELPOC1-HELPOC4 HELPOE1-HELPOE4 HELPOD1-HELPOD4
          HELPOF1-HELPOF4 HELPOG1-HELPOG4 i;

   array c(1:4) HELPOC1-HELPOC4;
   array e(1:4) HELPOE1-HELPOE4;
   array d(1:4) HELPOD1-HELPOD4;
   array f(1:4) HELPOF1-HELPOF4;
   array g(1:4) HELPOG1-HELPOG4;

   if first.HHID94 then do;
                           do j=1 to 4;
                              c(j)='       ';
                              e(j)=.;
                              d(j)=.;
                              f(j)=.;
                              g(j)=.;
                           end;
                           i=1;
                        end;
   c(i)=HELPOC;
   e(i)=HELPOE;
   d(i)=HELPOD;
   f(i)=HELPOF;
   g(i)=HELPOG;


   i=i+1;

   if last.HHID94 then output;

   attrib HELPOC1-HELPOC4 label='OTHERVI: identifier of helping HH';
   attrib HELPOE1-HELPOE4 label='OTHERVI: number of people from HH';
   attrib HELPOD1-HELPOD4 label='OTHERVI: number of days helped';
   attrib HELPOF1-HELPOF4 label='OTHERVI: type of labor';
   attrib HELPOG1-HELPOG4 label='OTHERVI: wage per day';

run;

/*File village - maximum number of variables is 50*/


data work94_4 (keep=HELPVC1-HELPVC50 HELPVE1-HELPVE50 HELPVD1-HELPVD50
     HELPVF1-HELPVF50 HELPVG1-HELPVG50 HHID94);
     set village (rename=(Q6_24A=HELPVC Q6_24B=HELPVE Q6_24C=HELPVD
      Q6_24D=HELPVF Q6_24E=HELPVG));

   by HHID94;

   length HELPVC1-HELPVC50 $ 7;

   retain HELPVC1-HELPVC50 HELPVE1-HELPVE50 HELPVD1-HELPVD50
          HELPVF1-HELPVF50 HELPVG1-HELPVG50 i;

   array c(1:50) HELPVC1-HELPVC50;
   array e(1:50) HELPVE1-HELPVE50;
   array d(1:50) HELPVD1-HELPVD50;
   array f(1:50) HELPVF1-HELPVF50;
   array g(1:50) HELPVG1-HELPVG50;

   if first.HHID94 then do;
                           do j=1 to 50;
                              c(j)='       ';
                              e(j)=.;
                              d(j)=.;
                              f(j)=.;
                              g(j)=.;
                           end;
                           i=1;
                        end;
   c(i)=HELPVC;
   e(i)=HELPVE;
   d(i)=HELPVD;
   f(i)=HELPVF;
   g(i)=HELPVG;


   i=i+1;

   if last.HHID94 then output;

   attrib HELPVC1-HELPVC50 label='VILLAGE: identifier of helping HH';
   attrib HELPVE1-HELPVE50 label='VILLAGE: number of people from HH';
   attrib HELPVD1-HELPVD50 label='VILLAGE: number of days helped';
   attrib HELPVF1-HELPVF50 label='VILLAGE: type of labor';
   attrib HELPVG1-HELPVG50 label='VILLAGE: wage per day';

run;

/*File noinfo - maximum number of variables is 2*/

data work94_5 (keep=HELPXC1-HELPXC2 HELPXE1-HELPXE2 HELPXD1-HELPXD2
     HELPXF1-HELPXF2 HELPXG1-HELPXG2 HHID94);
     set noinfo (rename=(Q6_24A=HELPXC Q6_24B=HELPXE Q6_24C=HELPXD
      Q6_24D=HELPXF Q6_24E=HELPXG));

   by HHID94;

   length HELPXC1-HELPXC2 $ 7;

   retain HELPXC1-HELPXC2 HELPXE1-HELPXE2 HELPXD1-HELPXD2
          HELPXF1-HELPXF2 HELPXG1-HELPXG2 i;

   array c(1:2) HELPXC1-HELPXC2;
   array e(1:2) HELPXE1-HELPXE2;
   array d(1:2) HELPXD1-HELPXD2;
   array f(1:2) HELPXF1-HELPXF2;
   array g(1:2) HELPXG1-HELPXG2;

   if first.HHID94 then do;
                           do j=1 to 2;
                              c(j)='       ';
                              e(j)=.;
                              d(j)=.;
                              f(j)=.;
                              g(j)=.;
                           end;
                           i=1;
                        end;
   c(i)=HELPXC;
   e(i)=HELPXE;
   d(i)=HELPXD;
   f(i)=HELPXF;
   g(i)=HELPXG;


   i=i+1;

   if last.HHID94 then output;

   attrib HELPXC1-HELPXC2 label='NOINFO: identifier of helping HH';
   attrib HELPXE1-HELPXE2 label='NOINFO: number of people from HH';
   attrib HELPXD1-HELPXD2 label='NOINFO: number of days helped';
   attrib HELPXF1-HELPXF2 label='NOINFO: type of labor';
   attrib HELPXG1-HELPXG2 label='NOINFO: wage per day';

run;

/* proc print data=WORK94_5; */ /*Create a list of these cases to examine*/
/*   id HHID94;
     var HELPXC1-HELPXC2 HELPXE1-HELPXE2 HELPXD1-HELPXD2
     HELPXF1-HELPXF2 HELPXG1-HELPXG2;
run; */

data work94_6 nowork;
   merge
   work94_1 (in=a)
   work94_3 (in=b)
   work94_4 (in=c)
   work94_5 (in=d);
   by HHID94;
   if a=1 then output work94_6;
   if a=0 then output nowork;
run;

/* proc contents data=work94_6 varnum;
run; */

/* proc freq data=work94_6;
     tables RICE HELP23B HELP23D: HELP23F: HELP23G:
     HELPVD: HELPVE: HELPVF: HELPVG:
     HELPOD: HELPOE: HELPOF: HELPOG:;
run; */


data work94_7 (drop=i j k HELPVB1-HELPVB50 HELPVAT               /*RECODES*/
     HELPVT1-HELPVT50 HELPOB1-HELPOB4 HELPOAT
     HELPOET1-HELPOET4);

     set work94_6;

     if HELP23B=8 then HELP23B=0;

     if HELP23B > 0 then HELP23A=1;
        else HELP23A=0;

     array c(1:5) HELP23C1-HELP23C5;
     array d(1:5) HELP23D1-HELP23D5;
     array f(1:5) HELP23F1-HELP23F5;
     array g(1:5) HELP23G1-HELP23G5;

     array vb(1:50) HELPVB1-HELPVB50;
     array vc(1:50) HELPVC1-HELPVC50;
     array vd(1:50) HELPVD1-HELPVD50;
     array ve(1:50) HELPVE1-HELPVE50;
     array vet(1:50) HELPVT1-HELPVT50;
     array vg(1:50) HELPVG1-HELPVG50;

     array ob(1:4) HELPOB1-HELPOB4;
     array oc(1:4) HELPOC1-HELPOC4;
     array od(1:4) HELPOD1-HELPOD4;
     array oe(1:4) HELPOE1-HELPOE4;
     array oet(1:4) HELPOET1-HELPOET4;
     array og(1:4) HELPOG1-HELPOG4;

     do i=1 to 5;
        if c(i)='998' then c(i)='   ';
           else if c(i)='999' then c(i)='   ';
        if d(i)=98 then d(i)=.;
           else if d(i)=99  then d(i)=1;
        if f(i)=8 then f(i)=.;
           else if f(i)=9 then f(i)=.;
        if g(i)=996 then g(i)=.;
           else if g(i)=998 then g(i)=.;
           else if g(i)=999 then g(i)=1;
     end;

     do j=1 to 50;
        if vd(j)=99 then vd(j)=1;
        if ve(j)=99 then ve(j)=1;
        if vg(j)=996 then vg(j)=.;
           else if vg(j)=998 then vg(j)=.;
           else if vg(j)=999 then vg(j)=1;
        if vc(j) ne '       ' then vb(j)=1;
           else vb(j)=0;
        if ve(j)=. then vet(j)=0;
           else vet(j)=ve(j);
     end;

     do k=1 to 4;
        if od(k)=99 then od(k)=1;
        if oe(k)=99 then oe(k)=1;
        if og(k)=996 then og(k)=.;
           else if og(k)=998 then og(k)=.;
           else if og(k)=999 then og(k)=1;
        if oc(k) ne '       ' then ob(k)=1;
           else ob(k)=0;
        if oe(k)=. then oet(k)=0;
           else oet(k)=oe(k);
     end;

     HELPVAT = sum(of HELPVB1-HELPVB50);

     if HELPVAT > 0 then HELPVA=1;
        else if HELPVAT = 0 then HELPVA = 0;
        else HELPVA=.;                       /*There should be no missing values*/

     HELPVB= sum(of HELPVT1-HELPVT50);  /*should not produce a missing-value operation error*/

     HELPOAT = HELPOB1+HELPOB2+HELPOB3+HELPOB4;

     if HELPOAT > 0 then HELPOA=1;
        else if HELPOAT = 0 then HELPOA = 0;
        else HELPOA=.;

     HELPOB=sum(of HELPOET1-HELPOET4);

     TOTHELP=HELP23B+HELPVB+HELPOB;

      if HELP23B = 0 then HELP23B =.;
     if HELPOB = 0 then HELPOB = .;
     if HELPVB = 0 then HELPVB =.;

     if RICE=2 then RICE=0;      /* End of Recodes*/

     label HELP23A='Code 2 & 3 HH members helped harvest';
     label HELPOA='Other villages helped harvest';
     label HELPOB='# other villagers who helped';
     label HELPVA='Villagers helped harvest';
     label HELPVB='# Villagers who helped';

run;

/* proc freq data=work94_7;
     tables RICE HELP23A HELP23B HELP23D: HELP23F: HELP23G:
     HELPVA HELPVB HELPVD: HELPVE: HELPVF: HELPVG:
     HELPOA HELPOB HELPOD: HELPOE: HELPOF: HELPOG:;
run; */


proc datasets library=work;
     delete work94_1 work94_2 work94_3 work94_4 work94_5 work94_6 village othervi noinfo nowork;
run;


*************************************************************
**  Freqs, means, and sd for all variables in the dataset  **
*************************************************************;

/* proc freq data=work94_7;
     tables RICE HELP23A HELPVA HELPOA /missprint;
run;

proc means data=work94_7 maxdec=2 mean std min max nmiss;
     var HELP23B HELPVB HELPOB;
run; */

******************************************************************
**  Concatenate variables A and F for groups 23, V, and O       **
**  asking about paid labor status into single strings in       **
**  order to examine a frequency distribution of all sequences  **
******************************************************************;

data work94_8 (drop= string1-string3 i); /* concatenate 'A' variables */
    set work94_7;

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


data work94_9 (drop= stringa1-stringa5 strngb1-strngb50
       stringc1-stringc4 i j k);
    set work94_8;

    length stringa1-stringa5  $ 1 CCAT23F $ 5;
    length strngb1-strngb50  $ 1 CCATVF $ 50;
    length stringc1-stringc4  $ 1 CCATOF $ 4;

    array va (5) HELP23F1-HELP23F5;
    array a (5) stringa1-stringa5;
    array vb (50) HELPVF1-HELPVF50;
    array b (50) strngb1-strngb50;
    array vc (4) HELPOF1-HELPOF4;
    array c (4) stringc1-stringc4;

    do i=1 to 5;
      if va{i}=1 then a{i}='1';
      else if va{i}=2 then a{i}='2';
      else if va{i}=3 then a{i}='3';
      else a{i}=' ';
    end;

    do j=1 to 50;
      if vb{j}=1 then b{j}='1';
      else if vb{j}=2 then b{j}='2';
      else if vb{j}=3 then b{j}='3';
      else b{j}=' ';
    end;

    do k=1 to 4;
      if vc{k}=1 then c{k}='1';
      else if vc{k}=2 then c{k}='2';
      else if vc{k}=3 then c{k}='3';
      else c{k}=' ';
    end;

    CCAT23F=stringa1||stringa2||stringa3||stringa4||stringa5;
    CCATVF=strngb1||strngb2||strngb3||strngb4||strngb5||strngb6||
        strngb7||strngb8||strngb9||strngb10||strngb11||strngb12||
        strngb13||strngb14||strngb15||strngb16||strngb17||strngb18||
        strngb19||strngb20||strngb21||strngb22||strngb23||strngb24||
        strngb25||strngb26||strngb27||strngb28||strngb29||strngb30||
        strngb31||strngb32||strngb33||strngb34||strngb35||strngb36||
        strngb37||strngb38||strngb39||strngb40||strngb41||strngb42||
        strngb43||strngb44||strngb45||strngb46||strngb47||strngb48||
        strngb49||strngb50;
    CCATOF=stringc1||stringc2||stringc3||stringc4;

    CCATALLF=CCAT23F||CCATVF||CCATOF;

   label CCAT23F="concatenation of code 23 labor ?s";
   label CCATVF="concatenation of village labor ?s";
   label CCATOF="concatenation of oth vil labor ?s";
   label CCATALLF="concatenation of ALL labor ?s";

run;


/* proc freq data=work94_9;
     tables CCATALLA CCAT23F CCATVF CCATOF/ missprint;
run; */

proc datasets library=work;
     delete work94_7 work94_8;
run;

data work94_1 (drop=HELPVH_1 HELPVH_2 HELPVH_3
                    HELPOH_1 HELPOH_2 HELPOH_3
                    HELP2H_1 HELP2H_2 HELP2H_3 i j k);
     set work94_9;

     array f(1:5) HELP23F1-HELP23F5;
     array vf(1:50) HELPVF1-HELPVF50;
     array of(1:4) HELPOF1-HELPOF4;

     HELPVH_1=0;
     HELPVH_2=0;
     HELPVH_3=0;
     HELPOH_1=0;
     HELPOH_2=0;
     HELPOH_3=0;
     HELP2H_1=0;
     HELP2H_2=0;
     HELP2H_3=0;

     do k=1 to 5;
        if f(k)=1 then HELP2H_1=HELP2H_1+1;
           else if f(k)=2 then HELP2H_2=HELP2H_2+1;
           else if f(k)=3 then HELP2H_3=HELP2H_3+1;
     end;

     do i=1 to 50;
        if vf(i)=1 then HELPVH_1=HELPVH_1+1;
           else if vf(i)=2 then HELPVH_2=HELPVH_2+1;
           else if vf(i)=3 then HELPVH_3=HELPVH_3+1;
     end;

     do j=1 to 4;
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

/* proc freq data=work94_1;
     tables HELPVH HELPOH HELPDV HELPDV2;
run;  */

proc sort data=work94_1 out=sorted84;
     by VILL84;
run;

/* proc freq data=sorted84;
     tables VILL84*HELPDV VILL84*HELPDV2/ NOPERCENT NOCOL NOFREQ;
run; */

/* proc freq data=work94_1;
     tables VILL94*HELPDV VILL94*HELPDV2/ NOPERCENT NOCOL NOFREQ;
run; */

**************************************************************************
*** CREATE AGGREGATE MEASURES OF PERSONS, PERSON-DAYS, AND TOTAL WAGES ***
**************************************************************************;

*** At some point, I will label these newly created variables like a good boy ***;
*** For now, I'll just note that P=persons, PD=Person-Days, and T=Total Wages ***;
*** The rest should be self-explanatory, unless I hit my head really hard     ***;
*** PAID, FREE, and EXCH refer to Type of Labor, V, O, and 2 to Labor Source  ***;


data work94_2 (drop= i j k);
     set sorted84;

     array d(1:5) HELP23D1-HELP23D5;
     array vd(1:50) HELPVD1-HELPVD50;
     array od(1:4) HELPOD1-HELPOD4;

     array ve(1:50) HELPVE1-HELPVE50;
     array oe(1:4) HELPOE1-HELPOE4;

     array f(1:5) HELP23F1-HELP23F5;
     array vf(1:50) HELPVF1-HELPVF50;
     array of(1:4) HELPOF1-HELPOF4;

     array g(1:5) HELP23G1-HELP23G5;
     array vg(1:50) HELPVG1-HELPVG50;
     array og(1:4) HELPOG1-HELPOG4;

     PAIDPD_2=0;
     FREEPD_2=0;
     EXCHPD_2=0;
     PAIDPD_V=0;
     FREEPD_V=0;
     EXCHPD_V=0;
     PAIDPD_O=0;
     FREEPD_O=0;
     EXCHPD_O=0;

     PAID_P_2=0;
     FREE_P_2=0;
     EXCH_P_2=0;
     PAID_P_V=0;
     FREE_P_V=0;
     EXCH_P_V=0;
     PAID_P_O=0;
     FREE_P_O=0;
     EXCH_P_O=0;

     PAID_T_2=0;
     PAID_T_V=0;
     PAID_T_O=0;


     do i=1 to 5;
        if f(i)=1 then PAIDPD_2=PAIDPD_2+(d(i));
           else if f(i)=2 then FREEPD_2=FREEPD_2+(d(i));
           else if f(i)=3 then EXCHPD_2=EXCHPD_2+(d(i));
     end;

     do j=1 to 50;
        if vf(j)=1 then PAIDPD_V=PAIDPD_V+(vd(j)*ve(j));
           else if vf(j)=2 then FREEPD_V=FREEPD_V+(vd(j)*ve(j));
           else if vf(j)=3 then EXCHPD_V=EXCHPD_V+(vd(j)*ve(j));
     end;

     do k=1 to 4;
        if of(k)=1 then PAIDPD_O=PAIDPD_O+(od(k)*oe(k));
           else if of(k)=2 then FREEPD_O=FREEPD_O+(od(k)*oe(k));
           else if of(k)=3 then EXCHPD_O=EXCHPD_O+(od(k)*oe(k));
     end;


     do i=1 to 5;
        if f(i)=1 then PAID_P_2=PAID_P_2+1;
           else if f(i)=2 then FREE_P_2=FREE_P_2+1;
           else if f(i)=3 then EXCH_P_2=EXCH_P_2+1;
     end;

     do j=1 to 50;
        if vf(j)=1 then PAID_P_V=PAID_P_V+ve(j);
           else if vf(j)=2 then FREE_P_V=FREE_P_V+ve(j);
           else if vf(j)=3 then EXCH_P_V=EXCH_P_V+ve(j);
     end;

     do k=1 to 4;
        if of(k)=1 then PAID_P_O=PAID_P_O+oe(k);
           else if of(k)=2 then FREE_P_O=FREE_P_O+oe(k);
           else if of(k)=3 then EXCH_P_O=EXCH_P_O+oe(k);
     end;


     do i=1 to 5;
        if f(i)=1 then PAID_T_2=PAID_T_2+(d(i)*g(i));
     end;

     do j=1 to 50;
        if vf(j)=1 then PAID_T_V=PAID_T_V+(vd(j)*ve(j)*vg(j));
     end;

     do k=1 to 4;
        if of(k)=1 then PAID_T_O=PAID_T_O+(od(k)*oe(k)*og(k));
     end;


     PAID_P=PAID_P_2+PAID_P_V+PAID_P_O;
     FREE_P=FREE_P_2+FREE_P_V+FREE_P_O;
     EXCH_P=EXCH_P_2+EXCH_P_V+EXCH_P_O;

     PAIDPD=PAIDPD_2+PAIDPD_V+PAIDPD_O;
     FREEPD=FREEPD_2+FREEPD_V+FREEPD_O;
     EXCHPD=EXCHPD_2+EXCHPD_V+EXCHPD_O;

     PAID_T=PAID_T_2+PAID_T_V+PAID_T_O;
     ALL_P=PAID_P+FREE_P+EXCH_P;
     ALL_PD=PAIDPD+FREEPD+EXCHPD;

     if RICE=1 then HELPDV4=ALL_P;
        else HELPDV4=.;

     if RICE=1 then HELPDV5=ALL_PD;
        else HELPDV5=.;

     if RICE=1 then HELPDV6=PAID_T;
        else HELPDV6=.;

run;


proc sort data=work94_2 out=out94_1.c3_94_01;
     by HHID94;
run;
