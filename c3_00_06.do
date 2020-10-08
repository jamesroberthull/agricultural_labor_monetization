********************************************************************************
**
**  Program Location: /trainee/jrhull/diss/ch3/c3prog/c3_00_06.do
**  Programmer: james r. hull
**  Date: 2009 10 12
**  Purpose: Heckman selection model for ch 3 on monetization
**  Data used: /trainee/jrhull/diss/ch3/c3data/c3_00_06.dta
**
********************************************************************************


**--------------------------------------------------------------**
** Remove cases with missing data - TEMP FIX - SHOULD DO IN SAS **
**--------------------------------------------------------------**

capture clear
* set mem 100m

use /trainee/jrhull/diss/ch3/c3data/c3_00_05

drop if m_13_55==. | f_13_55==. | numdepch==. | numdepel==. | codetwo==. | meanage==. | migrem_y==. | migrem_n==. | rai_rice==. | riceprop==. | plantnum==. | cassava==. | cottage==. | stock==. | charcoal==. | casset==. | passet==. | pcasset==. | workwage==. | pipe_wat==. | wind_0_1==. | fuel_new==. | vill1355==. | vill_ric==. | v94dry==. | v94phone==. | ru00_2==. | ru00_3==. | equip00==. | vill_rai==. | v94help==.

gen grewrice = 0
recode grewrice (0=1) if helpdv5 ~= .

save /trainee/jrhull/diss/ch3/c3data/c3_00_06, replace

**-----------------------------**
**  RUN MODEL WITH REVISED DV  **
**-----------------------------**

capture clear

* set mem 100m

use /trainee/jrhull/diss/ch3/c3data/c3_00_06

*** A Heckman model with binomial probit outcome ***

heckprob helpdv5 m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill1355 v94help vill_ric v94dry v94phone, select (m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 equip00 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill_ric v94dry v94phone) robust cluster(vill94)


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


save temp, replace

use /trainee/jrhull/diss/ch3/c3data/c3_94_06

rename ro94_2 ru00_2 
rename ro94_3 ru00_3 
rename v_toodry v94dry
rename v_help v94help
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


**------------------------------------**
** Collinearity Tests with new Model  **
**------------------------------------**


quietly: heckman helpdv5 m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill1355 v94help vill_ric v94dry v94phone, select (m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 equip00 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill_ric v94dry v94phone) robust cluster(vill94) mills(mills00)

collin (m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill1355 v94help vill_ric v94dry v94phone mills00)

reg mills00 m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill1355 v94help vill_ric v94dry v94phone


**------------------------------**
** Unconditioned Probit Models  **
**------------------------------**

capture clear

* set mem 100m

use /trainee/jrhull/diss/ch3/c3data/c3_00_06

** Main Model - Paid Labor **

probit helpdv5 m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill1355 v94help vill_ric v94dry v94phone, cluster (vill94)

** Collinearity TEST **

collin (m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill1355 v94help vill_ric v94dry v94phone)

** Save estimates for Pred Prob's **

est store m2000_r

** "Selection Model" - Grew Rice **

probit grewrice m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 equip00 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill_ric v94dry v94phone, cluster(vill94)

** Collinearity TEST **

collin(m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 equip00 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill_ric v94dry v94phone)

** Save estimates for Pred Prob's **

est store m2000_s

** Calculate Predicted Probabilities: 00 coefficients 00 data **

est for m2000_r: predict p00c00dr, pr
est for m2000_s: predict p00c00ds, pr

sum p00c00dr p00c00ds


** Calculate Predicted Probabilities: 00 coefficients 94 data **

save temp, replace

use /trainee/jrhull/diss/ch3/c3data/c3_94_06

rename ro94_2 ru00_2 
rename ro94_3 ru00_3 
rename v_toodry v94dry
rename v_help v94help
rename v_phone v94phone
rename casset1 casset
rename passet1 passet
rename pcasset1 pcasset
rename equip94 equip00cb

est for m2000_r: predict p00c94dr, pr
est for m2000_s: predict p00c94ds, pr


sum p00c94dr p00c94ds

**-----------------------------**
** Unconditioned Logit Models  **
**-----------------------------**

capture clear

* set mem 100m

use /trainee/jrhull/diss/ch3/c3data/c3_00_06

logit helpdv5 m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill1355 v94help vill_ric v94dry v94phone, cluster (vill94)

** Save estimates for Pred Prob's **

est store m2000_rL

logit grewrice m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 equip00 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill_ric v94dry v94phone, cluster(vill94)

** Save estimates for Pred Prob's **

est store m2000_sL

** Calculate Predicted Probabilities: 00 coefficients 00 data **

est for m2000_rL: predict l00c00dr, pr
est for m2000_sL: predict l00c00ds, pr

sum l00c00dr l00c00ds


** Calculate Predicted Probabilities: 00 coefficients 94 data **

save temp, replace

use /trainee/jrhull/diss/ch3/c3data/c3_94_06

rename ro94_2 ru00_2 
rename ro94_3 ru00_3 
rename v_toodry v94dry
rename v_help v94help
rename v_phone v94phone
rename casset1 casset
rename passet1 passet
rename pcasset1 pcasset
rename equip94 equip00

est for m2000_rL: predict l00c94dr, pr
est for m2000_sL: predict l00c94ds, pr

sum l00c94dr l00c94ds

**------------------------------------------------**
** Descriptive Statistics for All Model Variables **
**------------------------------------------------**

capture clear

* set mem 100m

use /trainee/jrhull/diss/ch3/c3data/c3_00_06

sum helpdv5 grewrice m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 plantnum equip00 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill1355 v94help vill_ric v94dry v94phone

sum helpdv5 grewrice m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 plantnum equip00 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill1355 v94help vill_ric v94dry v94phone if helpdv5~=.


