********************************************************************************
**
**  Program Location: /trainee/jrhull/diss/ch3/c3prog/c3_00_07.do
**  Programmer: james r. hull
**  Date: 2009 10 12
**  Purpose: Heckman selection model for ch 3 on monetization (WITH VILL MIGRANTS)
**  Data used: /trainee/jrhull/diss/ch3/c3data/c3_00_07.dta
**
**  NOTES: I Will use this file to make any additions and changes to the final model
**
********************************************************************************


**--------------------------------------------------------------**
** Remove cases with missing data - TEMP FIX - SHOULD DO IN SAS **
**--------------------------------------------------------------**

capture clear
* set mem 100m

use /trainee/jrhull/diss/ch3/c3data/c3_00_05

sort vill94

bysort vill94: egen vill_mig = sum(migrem_y + migrem_n)

sort hhid00

gen v_migrat=vill_mig/vill1355

drop if m_13_55==. | f_13_55==. | numdepch==. | numdepel==. | codetwo==. | meanage==. | migrem_y==. | migrem_n==. | rai_rice==. | riceprop==. | plantnum==. | cassava==. | cottage==. | stock==. | charcoal==. | casset==. | passet==. | pcasset==. | workwage==. | pipe_wat==. | wind_0_1==. | fuel_new==. | vill1355==. | vill_ric==. | v94dry==. | v94phone==. | ru00_2==. | ru00_3==. | equip00==. | vill_rai==. | v94help==. | vill_mig==.

gen grewrice = 0
recode grewrice (0=1) if helpdv5 ~= .

save /trainee/jrhull/diss/ch3/c3data/c3_00_07, replace


**------------------------------**
** Unconditioned Probit Models  **
**------------------------------**

capture clear

* set mem 100m

use /trainee/jrhull/diss/ch3/c3data/c3_00_07

** Main Model - Paid Labor **

probit helpdv5 m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill1355 v_migrat v94help vill_ric v94dry v94phone, cluster (vill94)

collin m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill1355 v_migrat v94help vill_ric v94dry v94phone

** Save estimates for Pred Prob's **

est store m2000_r

** "Selection Model" - Grew Rice **

probit grewrice m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 equip00 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill_ric v94dry v94phone, cluster(vill94)

** Save estimates for Pred Prob's **

est store m2000_s

** Calculate Predicted Probabilities: 00 coefficients 00 data **

est for m2000_r: predict p00c00dr, pr
est for m2000_s: predict p00c00ds, pr

sum p00c00dr p00c00ds


** Calculate Predicted Probabilities: 00 coefficients 94 data **

save temp, replace

use /trainee/jrhull/diss/ch3/c3data/c3_94_07

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


**------------------------------------------------**
** Descriptive Statistics for All Model Variables **
**------------------------------------------------**

capture clear

* set mem 100m

use /trainee/jrhull/diss/ch3/c3data/c3_00_07

sum helpdv5 grewrice m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 plantnum equip00 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill1355 v_migrat  v94help vill_ric v94dry v94phone

sum helpdv5 grewrice m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 plantnum equip00 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill1355 v_migrat v94help vill_ric v94dry v94phone if helpdv5~=.


