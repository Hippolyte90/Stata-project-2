*
*  b) Plot the yearly series of theft-related crimes in these 3 départements and in 2 other randomly selected departments.
**************************************************************************************

clear

* Définition des codes des départements à filtrer
local number "13 59 69"


foreach code in `number' {
	clear
    use "Data\Temp\filter_vol", clear
    keep if dep_code == "`code'"
    collapse (sum) sum_pn_gn, by(annee)
    tsset annee
    tsline sum_pn_gn, title("Série annuelle des délits de vol - Département `code'") xtitle("Années") ytitle("Nombre de délits de vol") xlabel(2012(1)2021) 
    graph export "Output\delits_vol_dept_`code'.png", replace
}

* 
*Two yearly series plot of theft-related in randomly selected department
*************************************************************************

clear
use "Data\Temp\filter_vol", clear  // Charger la base de données

br 

* Sélectionner deux départements au hasard, en excluant 13, 59 et 69
preserve
    sort dep_code
    by dep_code: gen count = _n == 1  // Identifier les départements uniques
    keep if count
    drop if inlist(dep_code, "13", "59", "69")  // Exclure les départements 13, 59 et 69
    sample 2  // Sélectionner deux départements au hasard
    local random_deps ""  // Initialiser la variable locale
    forvalues i = 1/2 {
        local random_deps "`random_deps' `=dep_code[`i']'"  // Ajouter les valeurs
    }
restore

display "Départements sélectionnés : `random_deps'"

* Traçer les séries temporelles

foreach code in `random_deps' {
	clear
    use "Data\Temp\filter_vol", clear
    keep if dep_code == "`code'"
    collapse (sum) sum_pn_gn, by(annee)
    tsset annee
    tsline sum_pn_gn, title("Série annuelle des délits de vol - Département `code'") xtitle("Années") ytitle("Nombre de délits de vol") xlabel(2012(1)2021) 
    graph export "Output\delits_vol_dept_`code'.png", replace
}







