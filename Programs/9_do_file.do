
*
* Population totale pour chaque département 
********************************************************************************
 
clear

use "Data\Temp\pop", clear

destring annee, replace

collapse (sum) Pop, by(dep_code)

save "Data\Temp\group_pop", replace 


*
*
* Regroupement du nombre de crime par département 
******************************************************************************
clear

use "Data\Final\pn_gn_crime_data", clear

drop crime pn gn index

collapse (sum) sum_pn_gn, by(dep_code)

save "Data\Temp\group_dep_crime", replace 


* Fusionner les deux jeux de données en fonction d'une clé commune (par exemple, dep_code, annee)
********************************************************************************
clear

use "Data\Temp\group_dep_crime", clear

merge 1:1 dep_code  using "Data\Temp\group_pop" 

drop _merge

* Supprimer les valeurs manquantes 

drop if missing(sum_pn_gn) | missing(Pop)

br

*
* The highest average crime rate
*

gen crime_rate = sum_pn_gn/Pop 


* Ordre décroissant

gsort -crime_rate

* Afficher les 10 départements avec le plus grand taux de criminarité liés.

list dep_code crime_rate in 1/10


/*
The department code such as 973, 13, 69, 06, 95, 34, 31, 971, 66 and 59 matching to the ten department that have the highest crime rate. 

Denote:
973 : Guyane
13 : Bouches-du-Rhône
69 : Rhône
06 : Alpes-Maritimes
95 : Val-d'Oise
34 : Hérault
31 : Haute-Garonne
971 : Guadeloupe
66 : Pyrénées-Orientales
59 : Nord
*/
















