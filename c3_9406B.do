********************************************************************************
**
**  Program Location: /trainee/jrhull/diss/ch3/c3prog/c3_9406B.do
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

use /trainee/jrhull/diss/ch3/c3data/c3_94_05

drop if m_13_55==. | f_13_55==. | numdepch==. | numdepel==. | codetwo==. | meanage==. | migrem_y==. | migrem_n==. | rai_rice==. | riceprop==. | plantnum==. | cassava==. | cottage==. | stock==. | charcoal==. | casset1==. | passet1==. | pcasset1==. | workwage==. | pipe_wat==. | wind_0_1==. | fuel_new==. | vill1355==. | vill_ric==. | v_toodry==. | v_phone==. | ro94_2==. | ro94_3==. | equip94==. | vill_rai==. | v_help==.

gen grewrice = 0
recode grewrice (0=1) if helpdv5 ~= .

save /trainee/jrhull/diss/ch3/c3data/c3_94_06, replace

capture clear

use /trainee/jrhull/diss/ch3/c3data/c3_9405b

drop if m_13_55==. | f_13_55==. | numdepch==. | numdepel==. | codetwo==. | meanage==. | migrem_y==. | migrem_n==. | rai_rice==. | riceprop==. | plantnum==. | cassava==. | cottage==. | stock==. | charcoal==. | casset1==. | passet1==. | pcasset1==. | workwage==. | pipe_wat==. | wind_0_1==. | fuel_new==. | vill1355==. | vill_ric==. | v_toodry==. | v_phone==. | ro94_2==. | ro94_3==. | equip94==. | vill_rai==. | v_help==.

gen grewrice = 0
recode grewrice (0=1) if helpdv5 ~= .

save /trainee/jrhull/diss/ch3/c3data/c3_9406b, replace

**------------------------------**
** Unconditioned Probit Models  **
**------------------------------**

capture clear

use /trainee/jrhull/diss/ch3/c3data/c3_94_06

** Main Model - Paid Labor **

probit helpdv5 m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ro94_2 ro94_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset1 passet1 pcasset1 workwage vill1355 v_help vill_ric v_toodry v_phone, cluster (vill94)

**------------------------------**
** Unconditioned Probit Models  **
**------------------------------**

capture clear

use /trainee/jrhull/diss/ch3/c3data/c3_9406b

** Main Model - Paid Labor **

probit helpdv5 m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ro94_2 ro94_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset1 passet1 pcasset1 workwage vill1355 v_help vill_ric v_toodry v_phone, cluster (vill94)




**------------------------------------------------**
** Descriptive Statistics for All Model Variables **
**------------------------------------------------**

capture clear

use /trainee/jrhull/diss/ch3/c3data/c3_9406b

sum helpdv5 grewrice m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ro94_2 ro94_3 plantnum equip94 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset1 passet1 pcasset1 workwage vill1355 v_help vill_ric v_toodry v_phone

sum helpdv5 grewrice m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ro94_2 ro94_3 plantnum equip94 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset1 passet1 pcasset1 workwage vill1355 v_help vill_ric v_toodry v_phone if helpdv5~=.

tab hhtype94 helpdv5, mis
