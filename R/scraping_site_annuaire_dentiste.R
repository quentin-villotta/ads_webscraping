# Fonction récupérant pour un département donné (Numéro) l'ensemble des sur les dentistes de ce département
# site scrappe : "http://www.ordre-chirurgiens-dentistes.fr/annuaire/"

scrap_data_by_dep <- function(num_dep, nom_dep)
{
  # Saisie formulaire avec num/nom departement
  ecriture_formulaire <-remDr$findElement(using = "css", "#zip")
  ecriture_formulaire$sendKeysToElement(list(num_dep))
  # Clique sur le boutton de validation 
  validation_formulaire<- remDr$findElement(using = "css", "#btSubmit")
  validation_formulaire$clickElement()
  # Recupéation de l'information
  liste_dentiste <-remDr$findElement(using = "css", "#DivRes .text-left")
  page_source <- liste_dentiste$getPageSource()
  read_page <- read_html(page_source[[1]])
  
  # Recuperation de l'information
  ## Nom de famille medecin
  nom_medecin <-  read_page %>% 
    html_nodes(css = "#DivRes .text-left")  %>% 
    html_nodes(css = "h4") %>% 
    html_nodes(css = "span") %>% 
    html_text()
  ## Prenom
  ### Pas récupérable directement via une balise
  ### On recupere donc le nom complet et on va soustraire le nom de famille
  #### Recuperation nom complet
  nom_complet <-read_page %>% 
    html_nodes(css = "#DivRes strong") %>% 
    html_text() 
  nom_complet = str_match(nom_complet, pattern = 'Dr (.*)')[,2]
  ##### Recupération du prenom par soustraction du nom de famille par rapport au nom complet
  prenom_medecin <- c()
  for(i in 1: length(nom_complet))
  {
  prenom <- substr(nom_complet[i], start = nchar(nom_medecin[i]) +1, stop =  nchar(nom_complet[i]))
  prenom_medecin <- c(prenom_medecin, prenom)
  }
  ## Adresse
  adresse_medecin <- read_page %>%
    html_nodes(css = "#DivRes p") %>% 
    html_text()  
  adresse_medecin <- str_match(adresse_medecin, pattern = '[: ]{2,}(.*)')[,2] 
  ## Numéro RPPS
  rpps_brut = read_page %>%
         html_nodes(css = "#DivRes .text-left")   
  rpps = str_match(rpps_brut, pattern = 'RPPS : (.*)<br>D')[,2] 
  ## Mode d'execercice du praticien
  mode_exercice_brut = read_page %>%
                  html_nodes(css = "#DivRes .text-left")  
  mode_exercice = str_match(mode_exercice_brut, pattern = 'exercice :  (.*)<br><p>')[,2] 
  
  # Creation du data frame consolide
  df <- data.frame(prenom_medecin,
             nom_medecin,
             rpps,
             mode_exercice,
             adresse_medecin,
             num_dep = rep(x =num_dep, length(rpps)),
             nom_dep = rep(x =nom_dep, length(rpps))
             )
return(df)
}


