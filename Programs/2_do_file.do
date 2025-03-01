

*
* 3. Construct a Stata data set that contains for each crime type, year and département : The numbers of crimes reported to PN, the number of crimes reported to GN, and the sum of both.
******************************************************************

forvalues annee = 2012(1)2021{
clear
*
* Import the data set for "`annee'"
**********************************************
import excel using "Data\Source\crimes-et-delits-enregistres-par-les-services-de-gendarmerie-et-de-police-depuis-2012.xlsx" ,sheet("Services PN `annee'") cellrange(A1)  firstrow  clear
br

drop if _n==1 | _n==2 // supprimer les deux premières lignes

rename Année`annee'servicesdepolice index
rename Départements crime
 
 * recuperer les labels des variables indiquant les départements.
 
 * Puisque les variables sont encodées en chaine de caractère, nous allons convertir les variables à regrouper en numerique
 

local string "index crime" 

* Le code ci-dessus permet de stocker les variables "Index" et "libelléindex" afin des les exclure lors de la convection.

* Convertion

    foreach vars of varlist * {
        if strpos("`string'", "`vars'") == 0 { 
            destring `vars', replace force
        }
    }
	
 
 * Le code suivant pour recuperer les départements de façon uniques
	
    local ident ""
    foreach var of varlist * {
        if strpos("`string'", "`var'") == 0 {
            local values : variable label `var'
            if "`values'" != "" & strpos("`ident'", "`values'") == 0 {
                local ident "`ident' `values'"
            }
        }
    }

 
 * Nous allons procceder au aggragation par département
 /* Cela revient à prendre chaque identifiant dans "local ident" et à parcourir toutes les variables de dataset tout en testant si les labels de ces variables correspondent à cet identifiant. Si c'est le cas, on fait la somme des colonnes de ces variables.Bien sur, sans "Index" et "libelléindex" qui sont exclures*/
 
  foreach values of local ident{
        gen pn_`values' = 0
        foreach var of varlist * {
            if strpos("`string'", "`var'") == 0 {
                local var_label : variable label `var'
                if "`var_label'" == "`values'" {
                    replace pn_`values' = pn_`values' + `var'
                }
            }
        }
    }
 
 
 ** Supprimons alors les colonnes ayant servie au somme
 
  foreach values of local ident {
    foreach var of varlist * {
        local var_labels : variable label `var'
        if "`var_labels'" == "`values'" {
            drop `var'
            di "🚀 Variable supprimée : `var'"
        }
    }
}

* Reshape

reshape long pn_, i(index crime) j(dep_code) string

* rennormons la nouvelle variable "pn_"

rename pn_ pn
gen annee = `annee'
sort index

save "Data\Temp\pn_`annee'", replace

}


*Conbinaison des dataset 

clear
forvalues annee = 2012(1)2021{
append using "Data\Temp\pn_`annee'"
erase "Data\Temp\pn_`annee'.dta" // pour eclaser le dataset temporel
}

order index crime dep_code annee pn

drop ZD

save "Data\Temp\pn_crime", replace

br

