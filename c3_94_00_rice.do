********************************************************************************
**
**  Program Location: /trainee/jrhull/diss/ch3/c3prog/c3_94_0)_rice.do
**  Programmer: james r. hull
**  Date: 2009 10 21
**  Purpose: QUick and dirty analysis of rice harvest labor use
**  Data used: /trainee/jrhull/diss/ch3/c3data/c3_94_06.dta
**             /trainee/jrhull/diss/ch3/c3data/c3_00_06.dta
**
********************************************************************************


capture clear
use /trainee/jrhull/diss/ch3/c3data/c3_94_06.dta

scatter rice_yld rai_rice || lfit rice_yld rai_rice
graph export /afs/isis.unc.edu/home/j/r/jrhull/a_data/graph/c3_94_rice_yld_rai_rice.png, replace

scatter rice_yld tothelp || lfit rice_yld tothelp
graph export /afs/isis.unc.edu/home/j/r/jrhull/a_data/graph/c3_94_rice_yld_tothelp.png, replace

scatter rai_rice tothelp || lfit rai_rice tothelp
graph export /afs/isis.unc.edu/home/j/r/jrhull/a_data/graph/c3_94_rai_rice_tothelp.png, replace

scatter plantnum tothelp || lfit plantnum tothelp
graph export /afs/isis.unc.edu/home/j/r/jrhull/a_data/graph/c3_94_plantnum_tothelp.png, replace



gen rai_100=rai_rice/100
gen rice_100=rice_yld/100
gen tot_100=tothelp/100

reg tot_100 rai_100 rice_100 if grewrice==1, cluster (vill94)

reg rice_100 rai_100 tot_100 if grewrice==1, cluster (vill94)

gen h_per10=tothelp/(rai_rice/10)

sum h_per10 if grewrice==1


capture clear
use /trainee/jrhull/diss/ch3/c3data/c3_00_06.dta

scatter rice_yld rai_rice || lfit rice_yld rai_rice
graph export /afs/isis.unc.edu/home/j/r/jrhull/a_data/graph/c3_00_rice_yld_rai_rice.png, replace

scatter rice_yld tothelp || lfit rice_yld tothelp
graph export /afs/isis.unc.edu/home/j/r/jrhull/a_data/graph/c3_00_rice_yld_tothelp.png, replace

scatter rai_rice tothelp || lfit rai_rice tothelp
graph export /afs/isis.unc.edu/home/j/r/jrhull/a_data/graph/c3_00_rai_rice_tothelp.png, replace

scatter plantnum tothelp || lfit plantnum tothelp
graph export /afs/isis.unc.edu/home/j/r/jrhull/a_data/graph/c3_00_plantnum_tothelp.png, replace



gen rai_100=rai_rice/100
gen rice_100=rice_yld/100
gen tot_100=tothelp/100

reg tot_100 rai_100 rice_100 if grewrice==1, cluster (vill94)

reg rice_100 rai_100 tot_100 if grewrice==1, cluster (vill94)

gen h_per10=tothelp/(rai_rice/10)

sum h_per10 if grewrice==1
