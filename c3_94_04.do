********************************************************************************
**
**  Program Location: /trainee/jrhull/diss/ch3/c3prog/c3_94_04.do
**  Programmer: james r. hull
**  Date: 2007 09 09
**  Purpose: Preliminary Heckman selection model for ch 3 on monetization
**  Data used: /trainee/jrhull/diss/ch3/c3data/c3_94_03.dta
**
********************************************************************************

clear

set mem 100m

capture log close


log using /trainee/jrhull/diss/ch3/c3prog/c3_94_04, text replace

use /trainee/jrhull/diss/ch3/c3data/c3_94_03.dta


*** Generate descriptive statistics ***

*sum

*** LAST MINUTE RE-CODES (TEMPORARY FIX) ***

recode ro94_1 (0=1) if ro94_0==1

recode fuel_old (0=1) if fuel_no==1

sum 

sum if helpdv3==0 | helpdv3==1


*** A Heckman model with binomial probit outcome ***


heckprob helpdv3 m_13_55 f_13_55 numdepch numdepel codetwo meanage migrem_y migrem_n rai_rice riceprop plantnum cassava cottage stock charcoal casset passet pcasset workwage pipe_wat wind_0_1 fuel_new vill1355 vill_ric v_toodry v_phone, select (m_13_55 f_13_55 numdepch numdepel codetwo meanage migrem_y migrem_n ro94_2 ro94_3 cottage stock charcoal casset passet pcasset workwage pipe_wat wind_0_1 fuel_new equip94 vill_rai v_toodry v_phone) robust cluster(vill94)

*** Generate predicted probabilities using 2000 data with 1994 coefficients ***

est store m1994_1

est for m1994_1: predict p9c9d00, p00
est for m1994_1: predict p9c9d01, p01
est for m1994_1: predict p9c9d10, p10
est for m1994_1: predict p9c9d11, p11
est for m1994_1: predict p9c9dsl, psel
est for m1994_1: predict p9c9dcd, pcond
est for m1994_1: predict p9c9d

sum p9c9d00 p9c9d01 p9c9d10 p9c9d11 p9c9dsl p9c9dcd p9c9d

save temp00_2, replace

use /trainee/jrhull/diss/ch3/c3data/c3_00_03

rename ru00_2 ro94_2
rename ru00_3 ro94_3
rename v94dry v_toodry
rename v94phone v_phone
rename casset casset1
rename passet passet1
rename pcasset pcasset1
rename equip00 equip94


est for m1994_1: predict p9c0d00, p00
est for m1994_1: predict p9c0d01, p01
est for m1994_1: predict p9c0d10, p10
est for m1994_1: predict p9c0d11, p11
est for m1994_1: predict p9c0dsl, psel
est for m1994_1: predict p9c0dcd, pcond
est for m1994_1: predict p9c0d


sum p9c0d00 p9c0d01 p9c0d10 p9c0d11 p9c0dsl p9c0dcd p9c0d




