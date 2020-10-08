*********************************************************************
**     Program Name: /home/jrhull/diss/ch3/c3prog/c3_94_03.sas
**     Programmer: james r. hull
**     Start Date: 2007 09 09
**     Purpose:
**        1.) Create control variables from 1994 data, Chapter3
**     Input Data:
**        1.) '/nangrong/data_sas/1994/current/hh94.03'
**        2.) '/nangrong/data_sas/1994/current/indiv94.03'
**        3.) '/nangrong/data_sas/1994/current/comm94.01'
**        4.) '/trainee/jrhull/diss/ch3/c3data/c3_94_02.xpt'
**        5.) '/nangrong/data_sas/1994/current/plots94.01'
**        6.) '/trainee/jrhull/diss/ch3/c3data/c3_94_01.xpt'
**        7.) '/nangrong/data/_sas/1984/current/hh84.01.xpt'
**     Output Data:
**        1.) '/trainee/jrhull/diss/ch3/c3data/c3_94_03.xpt'
**
*********************************************************************;

*--------------*
*   Options    *
*--------------*;

options nocenter linesize=80 pagesize=60;

title1 'Creating Control Variables: 1994 migration data';

*------------------*
*  Data Libraries  *
*------------------*;

libname in94_1 xport '/nangrong/data_sas/1994/current/hh94.03';
libname in94_2 xport '/nangrong/data_sas/1994/current/indiv94.04';
libname in94_3 xport '/nangrong/data_sas/1994/current/comm94.01';
libname in94_4 xport '/trainee/jrhull/diss/ch3/c3data/c3_94_02.xpt';
libname in94_5 xport '/nangrong/data_sas/1994/current/plots94.01';
libname in94_6 xport '/trainee/jrhull/diss/ch3/c3data/c3_94_01.xpt';

libname in84_1 xport '/nangrong/data_sas/1984/current/hh84.01.xpt';

libname out94_1 xport '/trainee/jrhull/diss/ch3/c3data/c3_94_03.xpt';

*---------------------------------------------*
*  Assemble individual-level origin variables *
*---------------------------------------------*;

data work94_1 (keep=VILL94 LEKTI94 HHID94 CEP94 Q1 AGE Q3 Q27 Q31);
     set in94_2.indiv94 (keep=VILL94 LEKTI94 HHID94 CEP94 Q1 Q2 Q3 CODE2 Q27 Q31);

     *** Recode specially coded ages to numeric equivalents ***;

     if Q2 in (81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91) then AGE=0;
        else if Q2=98 then AGE=0;
        else if Q2=99 then AGE=0;
        else AGE=Q2;

    *** Remove duplicate code 2 cases - leave destination HH data ***;

    if CODE2 ^in (1,5);

run;

data work94_2 (keep=VILL94 HHID94 AGETOTAL NUMMEMS NUMMALES NUMFEMS NUMDEPCH NUMDEPEL NUMDEPS M_13_55 F_13_55 CODETWO);
     set work94_1;

     by HHID94;

     keep VILL94 HHID94 AGETOTAL NUMMEMS NUMMALES NUMFEMS NUMDEPCH NUMDEPEL NUMDEPS M_13_55 F_13_55 CODETWO;

     *** Create variables: # of HH members, # males, # females, mean age ***;

     retain AGETOTAL NUMMEMS NUMMALES NUMFEMS NUMDEPCH NUMDEPEL NUMDEPS M_13_55 F_13_55 CODETWO;

     if first.HHID94 then do;
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

     if Q1=2 then CODETWO=CODETWO+1;

     if Q1 ^in (0,2,3,9) then do;

                       if ((13 <= AGE <=55) and (Q3=1))
                          then M_13_55=M_13_55+1; /*Males 13-55*/

                       if ((13 <= AGE <=55) and (Q3=2))
                          then F_13_55=F_13_55+1; /*Females 13-55*/

                       if (AGE < 13) then NUMDEPCH=NUMDEPCH+1;
                       if (AGE > 55) then NUMDEPEL=NUMDEPEL+1;

                       NUMDEPS=NUMDEPCH+NUMDEPEL;

                       AGETOTAL=AGETOTAL+AGE;

                       NUMMEMS=NUMMEMS+1;

                       if Q3=1 then NUMMALES=NUMMALES+1;
                          else if Q3=2 then NUMFEMS=NUMFEMS+1;

                     end;

     if last.HHID94 then output;

run;


*** miscellaneous manipulations on formerly indiv-level data ***;

data work94_3;
     set work94_2;

     *** calculated HH demography variable ***;

     MEANAGE=AGETOTAL/NUMMEMS;

run;

*---------------------------------------------*
*  Assemble household-level origin variables  *
*---------------------------------------------*;

data work94_4 (drop=Q6_4SA Q6_4WA Q6_4OA Q6_4CA Q6_10A Q6_10B Q6_10C Q6_26 Q6_22
                    Q6_13: Q6_20 Q6_5: Q6_9D: Q6_9C: WAGE: DAYS:Q6_2: Q6_3 WINDOW);
     set in94_1.hh94 (keep=vill94 hhid94 Q6_4SA Q6_4WA Q6_4OA Q6_4CA
                             Q6_10A Q6_10B Q6_10C Q6_17 Q6_22 Q6_26
                             Q6_5: Q6_13: Q6_20 Q6_9D: Q6_9C: Q6_2: Q6_3 WINDOW);


     *** HH production variables ***;

     if Q6_4SA=0 then SILK=0;
        else SILK=1;

     if Q6_4WA=0 then SILKWORM=0;
        else SILKWORM=1;

     if Q6_4OA=0 then CLOTH=0;
        else CLOTH=1;

     if Q6_4CA=0 then CHARCOAL=0;
        else CHARCOAL=1;

     if Q6_10A=0 then COWS=0;
        else if Q6_10A=9999 then COWS=.;
        else if Q6_10A>=3000 then COWS=Q6_10A-3000;
        else if Q6_10A>=2000 then COWS=Q6_10A-2000;
        else if Q6_10A>=1000 then COWS=Q6_10A-1000;

     if Q6_10B=0 then BUFFALO=0;
        else if Q6_10B=9999 then BUFFALO=.;
        else if Q6_10B>=3000 then BUFFALO=Q6_10B-3000;
        else if Q6_10B>=2000 then BUFFALO=Q6_10B-2000;
        else if Q6_10B>=1000 then BUFFALO=Q6_10B-1000;

     if Q6_10C=0 then PIGS=0;
        else if Q6_10C=999 then PIGS=.;
        else if Q6_10C>=3000 then PIGS=Q6_10C-3000;
        else if Q6_10C>=2000 then PIGS=Q6_10C-2000;
        else if Q6_10C>=1000 then PIGS=Q6_10C-1000;


     if (COWS>1 or BUFFALO>1 or PIGS>1) then STOCK=1;
        else STOCK=0;

     if Q6_26=2 then CASSAVA=0;
        else if Q6_26=1 then CASSAVA=1;
        else CASSAVA=.;

     if SILK=1 or SILKWORM=1 or CLOTH=1 then COTTAGE=1;
        else COTTAGE=0;

     *** HH assets variables ***;

     LTV1=Q6_5A1;
     STV1=Q6_5B1;
     VIDEO1=Q6_5C1;
     REFRI=Q6_5D1;
     ITAN1=Q6_5E1;
     CAR1=Q6_5F1;
     MOTOR=Q6_5G1;
     SEWM1=Q6_5H1;
     LTRACTOR=Q6_13A2;
     if Q6_13A2 ne 1 then LTRACTOR=0;
     STRACTOR=Q6_13B2;
     if Q6_13B2 ne 1 then STRACTOR=0;

     *** Create a variable measuring ownership of any equipment ***;

        if((Q6_13A2=1) or (Q6_13B2=1) or (Q6_13C2=1) or (Q6_13D2=1) or (Q6_13E2=1)) then EQUIP94=1;
           else EQUIP94=0;

     CASSET1=LTV1*8.513+STV1*6.280+VIDEO1*7.522+REFRI*8.5;
     PASSET1=ITAN1*80+LTRACTOR*483.75+STRACTOR*42.607+SEWM1*6.4;
     PCASSET1=CAR1*626.33+MOTOR*37.82;

     ASSET_T=CASSET1+PASSET1+PCASSET1;


     *** HH Rice Yield ***;

     if Q6_22=9998 then RICE_YLD=0;
        else if Q6_22=9999 then RICE_YLD=.;
        else RICE_YLD=Q6_22;

     *** EXTRA HH RICE AREA VARIABLE AVAILABLE ONLY IN 1994 - COMPARE TO RAI_RICE ***;

     if Q6_17=99995 then RAI_RIC2=(250);
        else if Q6_17=99999 then RAI_RIC2=.;
        else if Q6_17=99998 then RAI_RIC2=0;
        else if Q6_17<100 then RAI_RIC2=0;
                else RAI_RIC2=Q6_17*0.0025;

    *** COUNT OF NUMBER OF RICE PLANTING HELPERS ***;

    if Q6_20=99 then PLANTNUM=.;
       else if Q6_20=98 then PLANTNUM=0;
       else PLANTNUM=Q6_20;

    *** HH WAGES EARNED IN LOCAL ECONOMY ***;

    if (q6_9D1 ne 999 & q6_9C1 ne 99) then do;
                                       if q6_9D1=998 then WAGE1=0;
                                          else WAGE1=Q6_9D1;
                                       if Q6_9C1=98 then DAYS1=0;
                                          else DAYS1=Q6_9C1;
                                       WAGELAB1=WAGE1*DAYS1;
                                     end;
       else WAGELAB1=.;

    if (q6_9D2 ne 999 & q6_9C2 ne 99) then do;
                                       if q6_9D2=998 then WAGE2=0;
                                          else WAGE2=Q6_9D2;
                                       if Q6_9C2=98 then DAYS2=0;
                                          else DAYS2=Q6_9C2;
                                       WAGELAB2=WAGE2*DAYS2;
                                     end;
       else WAGELAB2=.;

    if (q6_9D3 ne 999 & q6_9C3 ne 99) then do;
                                       if q6_9D3=998 then WAGE3=0;
                                          else WAGE3=Q6_9D3;
                                       if Q6_9C3=98 then DAYS3=0;
                                          else DAYS3=Q6_9C3;
                                       WAGELAB3=WAGE3*DAYS3;
                                     end;
        else WAGELAB3=.;

     if (q6_9D4 ne 999 & q6_9C4 ne 99) then do;
                                       if q6_9D4=998 then WAGE4=0;
                                          else WAGE4=Q6_9D4;
                                       if Q6_9C4=98 then DAYS4=0;
                                          else DAYS4=Q6_9C4;
                                       WAGELAB4=WAGE4*DAYS4;
                                     end;
        else WAGELAB4=.;

     if (q6_9D5 ne 999 & q6_9C5 ne 99) then do;
                                       if q6_9D5=998 then WAGE5=0;
                                          else WAGE5=Q6_9D5;
                                       if Q6_9C5=98 then DAYS5=0;
                                          else DAYS5=Q6_9C5;
                                       WAGELAB5=WAGE5*DAYS5;
                                     end;
        else WAGELAB5=.;

    if ((WAGELAB1 ne .) and (WAGELAB2 ne .) and (WAGELAB3 ne .)
       and (WAGELAB4 ne .) and (WAGELAB5 ne .)) then
       WORKWAGE=WAGELAB1+WAGELAB2+WAGELAB3+WAGELAB4+WAGELAB5;

   *** General HH development indicators ***;

   if Q6_3=9 then PIPE_WAT=.;
      else if Q6_3=2 then PIPE_WAT=0;
      else PIPE_WAT=Q6_3;

   FUEL_OLD=0;
   FUEL_NEW=0;
   FUEL_NO=0;

   if (Q6_2A=1 or Q6_2B=1) then FUEL_OLD=1;
      else if (Q6_2C=1 or Q6_2D=1 or Q6_2E=1) then FUEL_NEW=1;
      else if (Q6_2A ne . & Q6_2B ne . & Q6_2C ne . & Q6_2D ne . & Q6_2E ne .) then FUEL_NO=1;
      else do;
             FUEL_OLD=.;
             FUEL_NEW=.;
             FUEL_NO=.;
           end;

   if WINDOW=9 then WIND_0_1=.;
      else if WINDOW=1 then WIND_0_1=0;
      else WIND_0_1=1;

run;

*** Create HH land and rice area variables ***;

data work94_5;                                                            /* S.B. HHID94 */
     set in94_5.plots94 (keep=HHID94 Q6_15C Q6_15A Q6_15B);

     by HHID94;

     keep HHID94 RAI_RICE RAI_O_94 MISCOUNT PLANGNUM;

     retain RAI_RICE RAI_O_94 MISCOUNT PLANGNUM;

     if first.HHID94 then do;
                            RAI_RICE=0;
                            RAI_O_94=0;
                            MISCOUNT=0;
                            PLANGNUM=0;
                          end;

      PLANGNUM=PLANGNUM+1;

      if Q6_15C in (99999,.) then MISCOUNT=MISCOUNT+1;
         else if Q6_15C=99995 then RAI_O_94=RAI_O_94+250; ***Automatically converts to RAI***;
         else RAI_O_94=RAI_O_94+(Q6_15C*0.0025);

      if (Q6_15A=2 or Q6_15B=2) then do;
                            if Q6_15C=99995 then RAI_RICE=RAI_RICE+250; ***Automatically converts to RAI***;
                              else RAI_RICE=RAI_RICE+(Q6_15C*0.0025);
                        end;

     if last.HHID94 then output;

run;


*** miscellaneous manipulations on rice land data ***;

data work94_6 (drop=MISCOUNT PLANGNUM);
     set work94_5;

     RICEPROP=.;

     if MISCOUNT=PLANGNUM then do;
                                 RAI_O_94=.;
                                 RAI_RICE=.;
                               end;

     if ((RAI_O_94 ne .) and (RAI_RICE ne .) and (RAI_o_94 ne 0)) then RICEPROP=RAI_RICE/RAI_O_94;

run;


*** Create Categorical land variable ***;

data work94_7;
     set work94_6;

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


*---------------------------------------------*
*  Assemble village-level origin variables    *
*---------------------------------------------*;

*** Prepare previous files for aggregation at village 94 level ***;

data work94_7a;
     merge work94_7 (in=a)
           in94_1.hh94 (in=b keep=VILL94 HHID94);

     by HHID94;

     if a=0 and b=1 then do;
                            RAI_O_94=0;
                            RAI_RICE=0;
                            RICEPROP=0;
                            RO94_0=0;
                            RO94_1=0;
                            RO94_2=0;
                            RO94_3=0;
                         end;

     if b=1 then output work94_7a;
run;


*** Aggregated Village-Level Variables ***;

data work94_8 (keep=VILL94 VILL1355 VILL_WAM VILL_WAF);
     set work94_3;
     by VILL94;

     keep VILL94 VILL1355 VILL_WAM VILL_WAF;

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

data work94_9;
     set work94_7a;

     by VILL94;

     keep VILL94 VILL_RAI VILL_RIC;

     retain VILL_RAI VILL_RIC;

     if first.VILL94 then do;
                             VILL_RAI=0;
                             VILL_RIC=0;
                          end;

     if RAI_RICE ne . then VILL_RIC=VILL_RIC+RAI_RICE;

     if RAI_O_94 ne . then VILL_RAI=VILL_RAI+RAI_O_94;

     if last.VILL94 then output;

run;

*** True Village-Level Variables ***;

data work94_10 (drop=Q4_53 Q8_104);
     set in94_3.comm94 (in=d keep=VILL94 Q5_76_1 Q5_76_2 Q4_53 Q8_104);

     rename Q5_76_1=V_HELPM Q5_76_2=V_HELPF;

        if Q4_53=2 then V_TOODRY=1;
             else V_TOODRY=0;

          if Q8_104=2 then V_PHONE=0;
            else if Q8_104=1 then V_PHONE=1;

run;


***----------------------------------------------------***
*** merge variables from all levels and existing files ***
***----------------------------------------------------***;

 *** Strategy:
               Merge MIG VARS onto
               Merge DEP VARS onto;


*** merge HH-level variables ***;

data work94_hh;
     merge work94_7a (in=a)
           work94_4 (in=b)
           work94_3 (in=c);

     by HHID94;

     if a=1 and b=1 and c=1 then output work94_hh;

run;

data work94_vil;
     merge work94_8 (in=a)
           work94_9 (in=b)
           work94_10 (in=c);

     by VILL94;

     if a=1 and b=1 and c=1 then output;

run;

 data work94_hh_vil;
     merge work94_hh (in=a)
           work94_vil (in=b);

     by VILL94;

     if a=1 then output;

run;

proc sort data=in94_4.c3_94_02 out=c3_94_02a;
     by HHID94;
run;

proc sort data=work94_hh_vil out=work94_hh_vila;
     by HHID94;
run;


data work94_all;
     merge work94_hh_vila (in=a)
           c3_94_02a (in=b);

    by HHID94;

    if a=1 and b=1 then output;

run;

 *** Clean up dataset and label variables ***;

/*  data work00_;
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
     label NUMDEPEL= '# HH members over age 55';
     label NUMDEPS= '#HH members under 13 & over 55';
     label PIGS= '# pigs raised by HH';
     label RECMIG= '# HH migrants (left after last harvest)';
     label SILK= 'HH makes silk: 0-no 1-yes';
     label SILKWORM= 'HH raises silkworm 0-no 1-yes';
     label VILL_RAI= '# rai rice paddy village last yr';
     label VILL_WAF= '# working age females in village';
     label VILL_WAM= '# working age males in village';
     label CASSAVA= '94: plant cassava in past year (Q6.26)';
     label RICE_YLD= '94: amount of rice yield - tangs (Q6.22)';
     label V_WAGEMH= '94: rice labor high demand - men (Q76)';
     label V_WAGEFH= '94: rice labor low demand - men (Q76)';
     label V_WAGEML= '94: rice labor high demand - women (Q76)';
     label V_WAGEFL= '94: rice labor low demand - women (Q76)';
     label VILL1355= '# working age adults in village';
     label TOTHELP= 'Total # helpers all sources';
     label NUMMIGT2= '# HH mig (b/f harvest) 3-yr window';
     label RECMIG2= '# HH mig (after harvest) 3-yr window';
     label MISSMIG2= '# HH mig (left unknown) 3-yr window';
     label NUMRRCD3= '# HH remit (b/f harvest) 3-yr win';
     label NURRSND3= '# HH receive (b/f harvest) 3-yr win';
     label CODETWO= '# Former HH members living in village';

run;


*** Clean up my mess ***;

proc datasets;
     delete work94_1 work94_2 work94_3 work94_4 work94_5 work94_6 work94_7;
run; */


*** Output dataset to library ***;

data out94_1.c3_94_03;
     set work94_all;
     if HHTYPE94 in (1,3);      *** Remove NEW HH's from final file ***;
run;
