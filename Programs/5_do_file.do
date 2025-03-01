

*Combinons les deux  dataset "gn_crime_2012_2020" et "gn_2021"
********************************************************************************

clear

use "Data\Temp\gn_crime_2012_2020", clear 

append using "Data\Temp\gn_2021"

save "Data\Temp\gn_crime", replace

br

* 
*Associons les deux bases de données 
********************************************************************************


clear

use "Data\Temp\pn_crime", clear

merge 1:1 index crime dep_code  annee using "Data\Temp\gn_crime"
	
drop _merge  // Supprime la variable générée par merge

* Sauvegarder la base de données

save "Data\Temp\pn_crime_data", replace


* Supprimer les valeurs manquantes 

drop if missing(pn) | missing(gn)

* Faisons la somme des deux colonnes 

gen sum_pn_gn = pn + gn 

* Sauvegarder les données finales 

save "Data\Final\pn_gn_crime_data", replace





