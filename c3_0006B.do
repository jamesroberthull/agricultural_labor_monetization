********************************************************************************
**
**  Program Location: /trainee/jrhull/diss/ch3/c3prog/c3_0006B.do
**  Programmer: james r. hull
**  Date: 2009 10 12
**  Purpose: Heckman selection model for ch 3 on monetization
**  Data used: /trainee/jrhull/diss/ch3/c3data/c3_0006b.dta
**
********************************************************************************


**--------------------------------------------------------------**
** Remove cases with missing data - TEMP FIX - SHOULD DO IN SAS **
**--------------------------------------------------------------**capture clear

use /trainee/jrhull/diss/ch3/c3data/c3_00_05

drop if m_13_55==. | f_13_55==. | numdepch==. | numdepel==. | codetwo==. | meanage==. | migrem_y==. | migrem_n==. | rai_rice==. | riceprop==. | plantnum==. | cassava==. | cottage==. | stock==. | charcoal==. | casset==. | passet==. | pcasset==. | workwage==. | pipe_wat==. | wind_0_1==. | fuel_new==. | vill1355==. | vill_ric==. | v94dry==. | v94phone==. | ru00_2==. | ru00_3==. | equip00==. | vill_rai==. | v94help==.

gen grewrice = 0
recode grewrice (0=1) if helpdv5 ~= .

save /trainee/jrhull/diss/ch3/c3data/c3_00_06, replace


capture clear

use /trainee/jrhull/diss/ch3/c3data/c3_0005b

drop if m_13_55==. | f_13_55==. | numdepch==. | numdepel==. | codetwo==. | meanage==. | migrem_y==. | migrem_n==. | rai_rice==. | riceprop==. | plantnum==. | cassava==. | cottage==. | stock==. | charcoal==. | casset==. | passet==. | pcasset==. | workwage==. | pipe_wat==. | wind_0_1==. | fuel_new==. | vill1355==. | vill_ric==. | v94dry==. | v94phone==. | ru00_2==. | ru00_3==. | equip00==. | vill_rai==. | v94help==.

gen grewrice = 0
recode grewrice (0=1) if helpdv5 ~= .

save /trainee/jrhull/diss/ch3/c3data/c3_0006b, replace


**------------------------------**
** Unconditioned Probit Models  **
**------------------------------**

capture clear

use /trainee/jrhull/diss/ch3/c3data/c3_00_06

** Main Model - Paid Labor **

probit helpdv5 m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill1355 v94help vill_ric v94dry v94phone, cluster (vill94)


**------------------------------**
** Unconditioned Probit Models  **
**------------------------------**

capture clear

use /trainee/jrhull/diss/ch3/c3data/c3_0006b

** Main Model - Paid Labor **

probit helpdv5 m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill1355 v94help vill_ric v94dry v94phone, cluster (vill94)



**------------------------------------------------**
** Descriptive Statistics for All Model Variables **
**------------------------------------------------**

capture clear

* set mem 100m

use /trainee/jrhull/diss/ch3/c3data/c3_0006b

sum helpdv5 grewrice m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 plantnum equip00 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill1355 v94help vill_ric v94dry v94phone

sum helpdv5 grewrice m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 plantnum equip00 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill1355 v94help vill_ric v94dry v94phone if helpdv5~=.

tab hhtype00 helpdv5, mis


