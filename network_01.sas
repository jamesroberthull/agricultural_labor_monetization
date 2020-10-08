    ***************
**  Options  **
***************;

options nocenter linesize=80 pagesize=60;

title1 'Program to create HH-level cassava harvest variables: 2000';

**********************
**  Data Libraries  **
**********************;

libname sm_00_1 xport '/nangrong/data_sas/2000/sociomatrices/helpcass.X00';
libname sm_00_2 xport '/nangrong/data_sas/2000/sociomatrices/helprh.X00';
libname sm_00_3 xport '/nangrong/data_sas/2000/network/snhh00.X00';

libname sm_out_1 xport '/trainee/jrhull/diss/ch3/c3data/c3_00_01.xpt';

libname extra_1 xport '/nangrong/data_sas/1994/current/hh94.03';

data sm_00_1;
     set sm_00_1.helpcass;
run;

data sm_00_2;
     set sm_00_3.snhh00;
run;
