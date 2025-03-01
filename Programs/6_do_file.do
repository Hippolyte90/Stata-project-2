

* 5. En limitant l'analyse à la France métropolitaine, répondons aux questions suivantes :
******************************************************************************************

*  The 3 departments with the highest total number of crimes that relate to thefts (vols)
******************************************************************************************


clear

* Import la base de donnée

use "Data\Final\pn_gn_crime_data", clear

* Rechercher le mot "Vol" et remplacer les types correspondants

* Assurons-nous que tout est en minuscule pour la recherche
gen crime_lower = lower(crime)

* Remplacer les occurrences de "vol" et "recel" par "Vol"
replace crime = "vol" if strpos(crime_lower, "vol") > 0 | strpos(crime_lower, "recel") > 0

* Filtrer les données relatives au "vol"

* Garder uniquement les lignes où "vol" est présent

keep if strpos(crime, "vol") > 0

* supprimer "crime_lower"

drop crime_lower

* Sauvegarder  une copie 

save "Data\Temp\filter_vol", replace


* Calculer le nombre total de crimes liés aux vols pour chaque département
collapse (sum) crimes_vol = sum_pn_gn, by(dep_code)

* Trier les départements par nombre total de crimes liés aux vols (en ordre décroissant)
gsort -crimes_vol

* Afficher les 3 départements avec le plus grand nombre de crimes liés aux vols
list dep_code crimes_vol in 1/3

/*
Nous avons les codes de départements 13, 59 et 69 qui montre un grands nombre de vols. Donc, les trois départements sont Bouches-du-Rhône, Nord et Rhône.
*/











