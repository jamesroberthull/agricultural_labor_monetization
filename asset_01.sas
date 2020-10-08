proc freq data=in1.papera8;
table q6_5a1 q6_5b1 q6_5c1 q6_5d1 q6_5e1 q6_5f1 q6_5g1 q6_5h1 cattle buffalo pig;
run;

data m1;
set in1.papera8;
ltv1=q6_5a1;
stv1=q6_5b1;
video1=q6_5c1;
refri=q6_5d1;
itan1=q6_5e1;
car1=q6_5f1;
motor=q6_5g1;
sewm1=q6_5h1;
animal1=cattle*3+buffalo*2+pig*1;

casset1=ltv1*8.513+stv1*6.280+video1*7.522+refri*8.5+motor*37.82+sewm1*6.4;
passet1=itan1*80+car1*626.33+land*497+cattle*8+buffalo*11+pig*3.8;
proc means;
   variable casset1 passet1;
run;







data assets;
set in2.hh00;

ltv=x6_4a1;
if x6_4a1 eq 99 then ltv=.;

stv=x6_4a2;
if x6_4a2 eq 99 then stv=.;

video=x6_4a3;
if x6_4a3 eq 99 then video=.;

htele=x6_4a4;
if x6_4a4 eq 99 then htele=.;

tele=x6_4a5;
if x6_4a5 eq 99 then tele=.;

compu=x6_4a6;
if x6_4a6 eq 99 then compu=.;

miwave=x6_4a8;
if x6_4a8 eq 99 then miwave=.;

wash=x6_4a9;
if x6_4a9 eq 99 then wash=.;

ac=x6_4a10;
if x6_4a10 eq 99 then ac=.;

roned=x6_4a11;
if x6_4a11 eq 99 then roned=.;

rtwod=x6_4a12;
if x6_4a12 eq 99 then rtwod=.;

itan=x6_4a13;
if x6_4a13 eq 99 then itan=.;

bike=x6_4a14;
if x6_4a14 eq 99 then bike=.;

lmc=x6_4a15;
if x6_4a15 eq 99 then lmc=.;

smc=x6_4a16;
if x6_4a16 eq 99 then smc=.;

car=x6_4a17;
if x6_4a17 eq 99 then car=.;

truck=x6_4a18;
if x6_4a18 eq 99 then truck=.;

picku=x6_4a19;
if x6_4a19 eq 99 then picku=.;

sewm=x6_4a20;
if x6_4a20 eq 99 then sewm=.;

/*animals raising*/
cow2=x6_10a1;
if x6_10a1 eq 9 then cow2=.;
bufflo2=x6_10a2;
if x6_10a2 eq 9 then bufflo2=.;
pig2=x6_10a3;
if x6_10a3 eq 9 then pig2=.;
duck2=x6_10a4;
if x6_10a4 eq 9 then duck2=.;
chiken2=x6_10a5;
if x6_10a5 eq 9 then chiken2=.;
fish2=x6_10a6;
if x6_10a6 eq 9 then fish2=.;
anmial2=cow2*3+bufflo2*2+pig2*1+duck2*0.5+chiken2*0.25;

casset=ltv*8.513+stv*6.280+video*7.522+htele*3.255+compu*19.9+miwave*7.5+wash*7.2+ac*28.25+roned*5.85+rtwod*12.22+bike*1.925
+lmc*39.857+smc*35.750+sewm*6.4;
passet=itan*80+car*841+picku*394+truck*644+cow2*8+bufflo2*11+pig2*3.8+duck2*0.05+chiken2*0.04+fish2*0.5;
proc means;
   variable casset passet;
run;

/*ownership of land*/
data land;
set in3.plots00;
area1=x6_14RAI;
if x6_14RAI eq 9999 then area1=0;
area2=x6_15RAI;
if x6_15RAI eq 9999 or x6_15RAI eq . then area2=0;
area=area1+area2;
proc freq;
table area1;
proc freq;
table area2;
proc freq;
table area;
proc freq;
table PLANG00;
run;

proc sort data=land;
by hhid00;
run;

proc sort data=land;
by hhid00 plang00;
run;

ods output summary=landn;
proc means data=land sum;
  CLASS hhid00;
  VAR area;
run;
ods output close;

proc means data=landn;
VAR area_Sum;
run;

data assetsn nolandn noassets;
merge assets(in=a)
      landn(in=b);
if a=1 and b=1 then output assetsn;
if a=1 and b=0 then output nolandn;
if a=0 and b=1 then output noassets;
by HHID00;
run;






 options pageno=1 linesize=96 pagesize=73;

 libname out xport '/trainee/yytong/Nangrong/sem/asset.xpt';
 libname in1 xport '/trainee/yytong/Nangrong/sem/assets.xpt';
 libname in2 xport '/trainee/yytong/Nangrong/sem/assetss.xpt';

 data m1;
 set in1.assets;
 data m2;
 set in2.assetss;

 proc sort data=m1;
 by HHID94;

 proc sort data=m2;
 by HHID94;

 data m3 nom2 nom1;
 merge m1 (in=a)
       m2 (in=b);
 by HHID94;
 if a=1 and b=1 then output m3;
 if a=1 and b=0 then output nom2;
 if a=0 and b=1 then output nom1;
 run;

 proc sort data=m3;
 by HHID94;
 run;

 /*number of migrants remit money*/
 libname in3 xport '/trainee/yytong/master/papera8.xpt';
 ods output summary=nremit;
 proc means data=in3.papera8 sum;
   CLASS hhid94;
   VAR remit;
 run;
 ods output close;

 data nrem;
 set nremit;
 rename REMIT_Sum=nremit;
 run;

 proc sort data=nrem;
 by HHID94;
 run;

 data m4 nonrem nom3;
 merge m3 (in=a)
       nrem (in=b);
 if a=1 and b=1 then output m4;
 if a=1 and b=0 then output nonrem;
 if a=0 and b=1 then output nom3;
 by HHID94;
 run;

 proc sort data=m4;
 by HHID94;
 run;

 /*number of migrants remit goods*/
 ods output summary=nremitg;
 proc means data=in3.papera8 sum;
   CLASS hhid94;
   VAR remitg;
 run;
 ods output close;

 data nremg;
    set nremitg;
    rename REMITG_Sum=nremitg;
 run;

 proc sort data=nremg;
 by HHID94;
 run;

 data m5 nonremg nom4;
 merge m4 (in=a)
       nremg (in=b);
 if a=1 and b=1 then output m5;
 if a=1 and b=0 then output nonremg;
 if a=0 and b=1 then output nom4;
 by HHID94;
 run;

 proc sort data=m5;
 by HHID94;
 run;

 libname in4 xport '/trainee/yytong/Nangrong/sem/np.xpt';

 data npp;
 set in4.np;
 run;

 data m6 nonpp nom5;
 merge m5 (in=a)
       npp (in=b);
 if a=1 and b=1 then output m6;
 if a=1 and b=0 then output nonpp;
 if a=0 and b=1 then output nom5;
 by HHID94;
 run;


 data out.asset;
 set m6;
 keep HHID94 HHID00 land q6_14 passet1 casset1 animal1 area_Sum passet casset nremit nremitg nmig nyouth nelder nkids npop;
 run;

 proc means data=out.asset;
 run;

 proc print data=out.asset(obs=30);
 VAR hhid94 nremit nremitg npop;
 run;
