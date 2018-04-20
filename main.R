library(RSelenium)
library(rvest)
library(stringr)
library(magrittr)
library(stringi)

# Source files
source(file = 'R/liste_departements_france.R')
source(file = 'R/scraping_site_annuaire_dentiste.R')
source(file = 'R/clear_formulaire.R')
source(file = 'R/clean_encodage.R')


# Recuperation de la liste des departements francais 
liste_dep = extract_liste_dep_fr(save = 'data/liste_departements_france.RDS')
head(liste_dep)

# Initialisation du serveur Selenium
remDr <- remoteDriver(remoteServerAddr = "localhost" ,
                      port = 4445L,
                      browserName = "chrome")

remDr$open()

url_site_dentiste = "http://www.ordre-chirurgiens-dentistes.fr/annuaire/"

# Ouvertue de la navigation 
remDr$navigate(url_site_dentiste)
head(remDr$sessionInfo)


# Clique sur le boutton commencer du site
Sys.sleep(1)
boutton_start <- remDr$findElement(using = "css", "#top .btn-lg")
boutton_start$highlightElement() 
boutton_start$clickElement()

# Remplissage du formulaire pour chaque numéro de département
for(index in 1:nrow(liste_dep))
{
  # Recuperation du numero et nom de departement dans le data frame 
  num_dep = liste_dep[index,"num_dep"]
  nom_dep = liste_dep[index,"nom_dep"]
  # Scrap data de l'ensemble des dentiste du département
  Sys.sleep(1)
  data = scrap_data_by_dep(num_dep = num_dep ,
                    nom_dep = nom_dep)
  # Clean encodage 
  data_clean = clean_encodage_df(df = data)
  # Clear forumlaire
  clear_formulaire()
  # Save result in CSV file (append mode)
  if(index == 1)
  {init = TRUE}else{init = FALSE}
  write.table(x = data_clean, 
        file = "data/base_dentiste_consolidee.csv",
        append = TRUE,
        col.names = init,
        row.names = FALSE,
        sep = ';'
        )
}



data_conso <- read.csv(file = 'data/base_dentiste_consolidee.csv', 
                       header = TRUE,
                       sep =';')
df = clean_encodage_df(data_conso)
View(df)



