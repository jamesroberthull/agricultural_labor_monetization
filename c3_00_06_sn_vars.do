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

drop if m_13_55==. | f_13_55==. | numdepch==. | numdepel==. | codetwo==. | meanage==. | migrem_y==. | migrem_n==. | rai_rice==. | riceprop==. | plantnum==. | cassava==. | cottage==. | stock==. | charcoal==. | casset==. | passet==. | pcasset==. | workwage==. | pipe_wat==. | wind_0_1==. | fuel_new==. | vill1355==. | vill_ric==. | v94dry==. | v94phone==. | ru00_2==. | ru00_3==. | equip00==. | vill_rai==. | v94help==. | hg_rsr00==. | hg_ror00==. | hg_rir00==. | h00rpcnt==. | h00rpavg==. | hg_rss00==. | hg_ros00==. | hg_ris00==. | h00spcnt==. | h00spavg==.

gen grewrice = 0
recode grewrice (0=1) if helpdv5 ~= .

save /trainee/jrhull/diss/ch3/c3data/c3_00_06, replace

**------------------------------**
** Unconditioned Probit Models  **
**------------------------------**

capture clear

* set mem 100m

use /trainee/jrhull/diss/ch3/c3data/c3_00_06

** Main Model - Paid Labor **

probit helpdv5 m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill1355 v94help vill_ric v94dry v94phone hg_ror00 hg_rir00 h00rpcnt h00rpavg hg_ros00 hg_ris00 h00spcnt h00spavg, cluster (vill94)

** Collinearity TEST **

collin (m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 plantnum cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill1355 v94help vill_ric v94dry v94phone hg_ror00 hg_rir00 h00rpcnt h00rpavg hg_ros00 hg_ris00 h00spcnt h00spavg)


** "Selection Model" - Grew Rice **

probit grewrice m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 equip00 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill_ric v94dry v94phone hg_ror00 hg_rir00 h00rpcnt h00rpavg hg_ros00 hg_ris00 h00spcnt h00spavg, cluster(vill94)

** Collinearity TEST **

collin(m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 equip00 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill_ric v94dry v94phone hg_ror00 hg_rir00 h00rpcnt h00rpavg hg_ros00 hg_ris00 h00spcnt h00spavg)


**------------------------------------------------**
** Descriptive Statistics for All Model Variables **
**------------------------------------------------**

capture clear

* set mem 100m

use /trainee/jrhull/diss/ch3/c3data/c3_00_06

sum helpdv5 grewrice m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 plantnum equip00 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill1355 v94help vill_ric v94dry v94phone hg_ror00 hg_rir00 h00rpcnt h00rpavg hg_ros00 hg_ris00 h00spcnt h00spavg

sum helpdv5 grewrice m_13_55 f_13_55 numdepch numdepel codetwo migrem_y migrem_n meanage ru00_2 ru00_3 plantnum equip00 cassava cottage stock charcoal pipe_wat wind_0_1 fuel_new casset passet pcasset workwage vill1355 v94help vill_ric v94dry v94phone hg_ror00 hg_rir00 h00rpcnt h00rpavg hg_ros00 hg_ris00 h00spcnt h00spavg if helpdv5~=.


