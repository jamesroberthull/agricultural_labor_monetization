********************************************************************************
**
**  Program Location: /trainee/jrhull/diss/ch3/c3prog/c3_94_06.do
**  Programmer: james r. hull
**  Date: 2009 10 12
**  Purpose: Heckman selection model for ch 3 on monetization
**  Data used: /trainee/jrhull/diss/ch3/c3data/c3_94_06.dta
**
********************************************************************************


**--------------------------------------------------------------**
** Remove cases with missing data - TEMP FIX - SHOULD DO IN SAS **
**--------------------------------------------------------------**

capture clear
* set mem 100m

use /trainee/jrhull/diss/ch3/c3data/c3_94_05

drop if m_13_55==. | f_13_55==. | numdepch==. | numdepel==. | codetwo==. | meanage==. | migrem_y==. | migrem_n==. | rai_rice==. | riceprop==. | plantnum==. | cassava==. | cottage==. | stock==. | charcoal==. | casset1==. | passet1==. | pcasset1==. | workwage==. | pipe_wat==. | wind_0_1==. | fuel_new==. | vill1355==. | vill_ric==. | v_toodry==. | v_phone==. | ro94_2==. | ro94_3==. | equip94==. | vill_rai==. | v_help==.

gen grewrice = 0
recode grewrice (0=1) if helpdv5 ~= .

save /trainee/jrhull/diss/ch3/c3data/c3_94_06, replace

**-----------------------------**
**  RUN MODEL WITH REVISED DV  **
**-----------------------------**


capture clear
* set mem 100m

use /trainee/jrhull/diss/ch3/c3data/c3_94_06

*** A Heckman model with binomial probit outcome ***


heckprob helpdv5 m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ro94_2 ro94_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset1 passet1 pcasset1 workwage vill1355 v_help vill_ric v_toodry v_phone, select (m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ro94_2 ro94_3 equip94 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset1 passet1 pcasset1 workwage vill_ric v_toodry v_phone) robust cluster(vill94)

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


save temp, replace

use /trainee/jrhull/diss/ch3/c3data/c3_00_06

rename ru00_2 ro94_2
rename ru00_3 ro94_3
rename v94dry v_toodry
rename v94help v_help
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

**------------------------------------**
** Collinearity Tests with new Model  **
**------------------------------------**

quietly: heckman helpdv5 m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ro94_2 ro94_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset1 passet1 pcasset1 workwage vill1355 v_help  vill_ric v_toodry v_phone, select (m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ro94_2 ro94_3 equip94 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset1 passet1 pcasset1 workwage vill_ric v_toodry v_phone) robust cluster(vill94) mills(mills94)

collin (m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ro94_2 ro94_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset1 passet1 pcasset1 workwage vill1355 v_help vill_ric v_toodry v_phone mills94)

reg mills94 m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ro94_2 ro94_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset1 passet1 pcasset1 workwage vill1355 v_help vill_ric v_toodry v_phone


**------------------------------**
** Unconditioned Probit Models  **
**------------------------------**

capture clear
* set mem 100m

use /trainee/jrhull/diss/ch3/c3data/c3_94_06

** Main Model - Paid Labor **

probit helpdv5 m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ro94_2 ro94_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset1 passet1 pcasset1 workwage vill1355 v_help vill_ric v_toodry v_phone, cluster (vill94)

** Collinearity TEST **

collin (m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ro94_2 ro94_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset1 passet1 pcasset1 workwage vill1355 v_help vill_ric v_toodry v_phone)

** Save estimates for Pred Prob's **

est store m1994_r

** "Selection Model" - Grew Rice **

probit grewrice m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ro94_2 ro94_3 equip94 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset1 passet1 pcasset1 workwage vill_ric v_toodry v_phone, cluster(vill94)

** Collinearity TEST **

collin (m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ro94_2 ro94_3 equip94 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset1 passet1 pcasset1 workwage vill_ric v_toodry v_phone)

** Save estimates for Pred Prob's **

est store m1994_s

** Calculate Predicted Probabilities: 94 coefficients 94 data **

est for m1994_r: predict p94c94dr, pr
est for m1994_s: predict p94c94ds, pr

sum p94c94dr p94c94ds


** Calculate Predicted Probabilities: 94 coefficients 94 data **

save temp, replace

use /trainee/jrhull/diss/ch3/c3data/c3_00_06

rename ru00_2 ro94_2
rename ru00_3 ro94_3
rename v94dry v_toodry
rename v94help v_help
rename v94phone v_phone
rename casset casset1
rename passet passet1
rename pcasset pcasset1
rename equip00 equip94

est for m1994_r: predict p94c00dr, pr
est for m1994_s: predict p94c00ds, pr


sum p94c00dr p94c00ds


**-----------------------------**
** Unconditioned Logit Models  **
**-----------------------------**

capture clear
* set mem 100m

use /trainee/jrhull/diss/ch3/c3data/c3_94_06

logit helpdv5 m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ro94_2 ro94_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset1 passet1 pcasset1 workwage vill1355 v_help vill_ric v_toodry v_phone, cluster (vill94)

** Save estimates for Pred Prob's **

est store m1994_rL

logit grewrice m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ro94_2 ro94_3 equip94 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset1 passet1 pcasset1 workwage vill_ric v_toodry v_phone, cluster(vill94)

** Save estimates for Pred Prob's **

est store m1994_sL

** Calculate Predicted Probabilities: 94 coefficients 94 data **

est for m1994_rL: predict l94c94dr, pr
est for m1994_sL: predict l94c94ds, pr

sum l94c94dr l94c94ds


** Calculate Predicted Probabilities: 94 coefficients 94 data **

save temp, replace

use /trainee/jrhull/diss/ch3/c3data/c3_00_06

rename ru00_2 ro94_2
rename ru00_3 ro94_3
rename v94help v_help
rename v94dry v_toodry
rename v94phone v_phone
rename casset casset1
rename passet passet1
rename pcasset pcasset1
rename equip00 equip94

est for m1994_rL: predict l94c00dr, pr
est for m1994_sL: predict l94c00ds, pr


sum l94c00dr l94c00ds


**------------------------------------------------**
** Descriptive Statistics for All Model Variables **
**------------------------------------------------**

capture clear
* set mem 100m

use /trainee/jrhull/diss/ch3/c3data/c3_94_06

sum helpdv5 grewrice m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ro94_2 ro94_3 plantnum equip94 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset1 passet1 pcasset1 workwage vill1355 v_help vill_ric v_toodry v_phone

sum helpdv5 grewrice m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ro94_2 ro94_3 plantnum equip94 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset1 passet1 pcasset1 workwage vill1355 v_help vill_ric v_toodry v_phone if helpdv5~=.
