***********************************************************************
* File Location: trainee/jrhull/diss/ch3/c3prog/c3_94_00_01.do
* Programmer: james r. hull
* Date: 2007 September 8
*
* Purpose: Generate a number of descriptive statistics for 1994 and 2000
*          Rice Harvest Labor Data
***********************************************************************

capture log close

log using c3_94_00_01, text replace

/*1994*/

clear

use c3_94_01

*persons

sum paid_p_2 paid_p_v paid_p_o free_p_2 free_p_v free_p_o exch_p_2 exch_p_v exch_p_o if rice==1

sum paid_p free_p exch_p all_p if rice==1

*person-days

sum paidpd_2 paidpd_v paidpd_o freepd_2 freepd_v freepd_o exchpd_2 exchpd_v exchpd_o if rice==1

sum paidpd freepd exchpd all_pd if rice==1

*wages

sum paid_t_2 paid_t_v paid_t_o if rice==1

sum paid_t if rice==1

*centile paid_p_2 paid_p_v paid_p_o free_p_2 free_p_v free_p_o exch_p_2 exch_p_v exch_p_o if rice==1
*centile paid_p free_p exch_p all_p if rice==1
*centile paidpd_2 paidpd_v paidpd_o freepd_2 freepd_v freepd_o exchpd_2 exchpd_v exchpd_o if rice==1
*centile paidpd freepd exchpd all_pd if rice==1
*centile paid_t_2 paid_t_v paid_t_o if rice==1
*centile paid_t if rice==1

tab ccatalla if rice==1


/*2000*/

clear

use c3_00_01

*persons

sum paid_p_2 paid_p_v paid_p_o free_p_2 free_p_v free_p_o exch_p_2 exch_p_v exch_p_o if rice==1

sum paid_p free_p exch_p all_p if rice==1

*centile paid_p_2 paid_p_v paid_p_o free_p_2 free_p_v free_p_o exch_p_2 exch_p_v exch_p_o if rice==1
*centile paid_p free_p exch_p all_p if rice==1

tab ccatalla if rice==1


/*****************************************************/ 
/*also used collapse (sum) varlist to generate totals*/
/*****************************************************/ 


/* Aggregate across labor types just like I did above across sources */

/*1994*/

clear

use c3_94_01

tab ccatallf if rice==1
tab ccatallf if rice==1, mis


/*2000*/

clear

use c3_00_01

tab ccatallf if rice==1
tab ccatallf if rice==1, mis
