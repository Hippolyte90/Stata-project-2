*
* d) Plot the national-level yearly series of all crimes in numbers
********************************************************************************
clear

use "Data\Final\pn_gn_crime_data", clear

* Supprimer les variables non importantes

drop crime pn gn index dep_code

* Regroupement par année

collapse (sum) sum_pn_gn, by(annee)

* Save as temporary dataset

save "Data\Temp\sum_pn_gn_by_years", replace

tsset annee

tsline sum_pn_gn, title("Série annuelle de nombre de crimes au niveau national") xtitle("Années") ytitle("Nombre de crimes") xlabel(2012(1)2021) 
 graph export "Output\anual_natinal_crimes_evolution.png", replace
 
 *
 * Plot the national-level yearly series of all crimes in normalized by population.
 **********************************************************************************
 
 clear
 
 * importons la base données contenant les départements, la taille de la population et les années 
 *****************************************************************************************
 
 use "Data\Temp\pop", clear

 drop dep_code // supprimer les départements
 
 br 
 
 collapse (sum) Pop, by(annee) // aggégation par année
 
 destring annee, replace
 
 * Fusionner les deux jeux de données en fonction d'une clé commune (par exemple, dep_code, annee)

merge 1:1 annee  using "Data\Temp\sum_pn_gn_by_years"

drop _merge


* Statistique sur Pop

summarize Pop
display r(sum)

* crimes in normalized by population

gen crime_normalized = sum_pn_gn/ r(sum)

* supprimer les variables moins importantes

drop Pop sum_pn_gn

* Plot the anual series 

tsset annee

tsline crime_normalized, title("Série annuelle du taux de criminalité au niveau national") xtitle("Années") ytitle("Taux de criminalité") xlabel(2012(1)2021) 
graph export "Output\anual_natinal_rate_crimes_evolution.png", replace
 





 