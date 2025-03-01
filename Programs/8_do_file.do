
*
*
** c)  The 10 départements with the highest average crime rate (i.e., number of all crimes normalized by population)

* Importons les données contenant les population
********************************************************************************
********************************************************************************
clear

* Import the data set for "`annee'"
**********************************************
import excel using "Data\Source\base-pop-historiques-1876-2022.xlsx" ,sheet("pop_1876_2022") cellrange(A5:Q34943)  firstrow  clear
br

drop in 1

* Suppression des variables moins importantes

drop Populationen2011 Région Codegéographique Populationen2022 Populationen2010 Libellégéographique

rename Département dep_code
 
 * conversion en int 
 local string "dep_code" 

* Convertion

    foreach vars of varlist * {
        if strpos("`string'", "`vars'") == 0 { 
            destring `vars', replace force
        }
    }
 
 * Regrouper par département
collapse (sum) Populationen2012 Populationen2013 Populationen2014 Populationen2015 Populationen2016 Populationen2017 Populationen2018 Populationen2019 Populationen2020 Populationen2021, by(dep_code)
 
* Reshape

reshape long Populationen, i(dep_code) j(annee) string 

 
 rename Populationen Pop
 
 save "Data\Temp\pop", replace
 
 
 
 

 
 