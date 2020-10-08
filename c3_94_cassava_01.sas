*********************************************************************
**     Program Name: /home/jrhull/diss/ch3/c3prog/c3_94_cassava_01.sas
**     Programmer: james r. hull
**     Start Date: 2008 NOVEMBER 9
**     Purpose:
**        1.) Create identical var's to rice harvest var's for cassava
**     Input Data:
**        1.) /nangrong/data_sas/1994/current/hh94.02
**     Output Data:
**        1.) /trainee/jrhull/diss/ch3/c3data/c3_940_c1.xpt
**
*********************************************************************;

***************
**  Options  **
***************;

options nocenter linesize=80 pagesize=60;

title1 'Program to create HH-level cassava variables';

**********************
**  Data Libraries  **
**********************;

libname in94_1 xport '/nangrong/data_sas/1994/current/hh94.03';

libname out94_1 xport '/trainee/jrhull/diss/ch3/c3data/c3_94_c1.xpt';


******************************
**  Create Working Dataset  **
******************************;


data work94_1;
     set in94_1.hh94;
     keep hhid94 hhtype94 lekti84 vill84 house84 hhid84 lekti94 vill94
          Q6_26 Q6_27 Q6_28 Q6_29 Q6_30 Q6_31 Q6_32 Q6_33 Q6_34;
run;

*****************************************************************
**  Separate helping households into same and different villages
*****************************************************************;

*************************************************************
**  Freqs, means, and sd for all variables in the dataset  **
*************************************************************;

proc freq data=work94_1;
     tables q:;
run;




