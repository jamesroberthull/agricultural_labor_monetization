********************************************************************************
**
**  Program Location: /trainee/jrhull/diss/ch3/c3prog/c3_00_04.do
**  Programmer: james r. hull
**  Date: 2007 09 09
**  Purpose: Preliminary Heckman selection model for ch 3 on monetization
**  Data used: /trainee/jrhull/diss/ch3/c3data/c3_00_03.dta
**
********************************************************************************

clear

set mem 100m

capture log close

log using /trainee/jrhull/diss/ch3/c3prog/c3_00_04, text replace

use /trainee/jrhull/diss/ch3/c3data/c3_00_03.dta


*** Generate descriptive statistics ***

*sum


*** LAST MINUTE RE-CODES (TEMPORARY FIX) ***

recode ru00_1 (0=1) if ru00_0==1

recode fuel_old (0=1) if fuel_no==1


sum

sum if helpdv3==1 | helpdv3==0

*** A Heckman model with binomial probit outcome ***


heckprob helpdv3 m_13_55 f_13_55 numdepch numdepel codetwo meanage migrem_y migrem_n rai_rice riceprop plantnum cassava cottage stock charcoal casset passet pcasset workwage pipe_wat wind_0_1 fuel_new vill1355 vill_ric v94dry v94phone, select (m_13_55 f_13_55 numdepch numdepel codetwo meanage migrem_y migrem_n ru00_2 ru00_3 cottage stock charcoal casset passet pcasset workwage pipe_wat wind_0_1 fuel_new equip00 vill_rai v94dry v94phone) robust cluster(vill94)


*** Generate predicted probabilities using 1994 data with 2000 coefficients ***

est store m2000_1

est for m2000_1: predict p0c0d00, p00
est for m2000_1: predict p0c0d01, p01
est for m2000_1: predict p0c0d10, p10
est for m2000_1: predict p0c0d11, p11
est for m2000_1: predict p0c0dsl, psel
est for m2000_1: predict p0c0dcd, pcond
est for m2000_1: predict p0c0d

sum p0c0d00 p0c0d01 p0c0d10 p0c0d11 p0c0dsl p0c0dcd p0c0d

save temp00_1, replace

use /trainee/jrhull/diss/ch3/c3data/c3_94_03

rename ro94_2 ru00_2 
rename ro94_3 ru00_3 
rename v_toodry v94dry
rename v_phone v94phone
rename casset1 casset
rename passet1 passet
rename pcasset1 pcasset
rename equip94 equip00


est for m2000_1: predict p0c9d00, p00
est for m2000_1: predict p0c9d01, p01
est for m2000_1: predict p0c9d10, p10
est for m2000_1: predict p0c9d11, p11
est for m2000_1: predict p0c9dsl, psel
est for m2000_1: predict p0c9dcd, pcond
est for m2000_1: predict p0c9d

sum p0c9d00 p0c9d01 p0c9d10 p0c9d11 p0c9dsl p0c9dcd p0c9d
