

* GN
******************************************************************

forvalues annee = 2012(1)2020{
clear
*
* Import the data set for "`annee'"
**********************************************
import excel using "Data\Source\crimes-et-delits-enregistres-par-les-services-de-gendarmerie-et-de-police-depuis-2012.xlsx" ,sheet("Services GN `annee'") cellrange(A1)  firstrow  clear
br

drop if _n==1 // supprimer la première ligne

rename Année`annee'compagniesdegenda index
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
        gen gn_`values' = 0
        foreach var of varlist * {
            if strpos("`string'", "`var'") == 0 {
                local var_label : variable label `var'
                if "`var_label'" == "`values'" {
                    replace gn_`values' = gn_`values' + `var'
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

reshape long gn_, i(index crime) j(dep_code) string

* rennormons la nouvelle variable "pn_"

rename gn_ gn

gen annee = `annee'

sort index

save "Data\Temp\gn_`annee'", replace

}


*Conbinaison des dataset 

clear
forvalues annee = 2012(1)2020{
append using "Data\Temp\gn_`annee'"
erase "Data\Temp\gn_`annee'.dta" // Erase temporary files to save some place
}


* Supprimons les colonnes "NM NN NO NK NL NJ"

drop NM NN NO NK NL NJ

* Ordonnons les colonnes

order index crime dep_code annee gn
save "Data\Temp\gn_crime_2012_2020", replace

br

