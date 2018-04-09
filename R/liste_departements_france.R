# Fonction de récupération de la liste des département français (metropole)
# site scrappe : "https://fr.wikipedia.org/wiki/Num%C3%A9rotation_des_d%C3%A9partements_fran%C3%A7ais"  

extract_liste_dep_fr <- function(save)
{
# Url site wikipedia ou scrappe la liste des departements français  
url_site =  "https://fr.wikipedia.org/wiki/Num%C3%A9rotation_des_d%C3%A9partements_fran%C3%A7ais"  
#Parse Html page  
liste_dep_wiki <- read_html(x = url_site,
                            encoding =  "UTF-8")
### Recuperation des departements
df_int_liste_dep <- liste_dep_wiki %>%
  html_node(css = ".colonnes:nth-child(11)")  %>% 
  html_nodes(css = "ul")  %>% 
  html_nodes(css = "li")  %>% 
  html_text()
# Split entre le numéro de departement et le nom du departement
df_int_liste_dep <- data.frame( do.call(rbind, strsplit( df_int_liste_dep, ': ' ))) 
colnames(df_int_liste_dep) <- c("num_dep", 'nom_dep')
# Fix tmp pb encoding site (Character unicode)
df_int_liste_dep$num_dep <- as.numeric(df_int_liste_dep$num_dep)
# Num dep passe en character et ajout d'un 0 devant pour les numeros de departement < 10
df_int_liste_dep$num_dep <- as.character(df_int_liste_dep$num_dep)
df_int_liste_dep$num_dep  <- ifelse(nchar(df_int_liste_dep$num_dep) ==1,
                                    paste0('0',df_int_liste_dep$num_dep),
                                    df_int_liste_dep$num_dep)
# Save rds file
saveRDS(object = df_int_liste_dep, file = save)
return(df_int_liste_dep)
}
