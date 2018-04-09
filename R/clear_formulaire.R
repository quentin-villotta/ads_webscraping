clear_formulaire <- function()
{
  formulaire_num_dep <-remDr$findElement(using = "css", "#zip")
  formulaire_num_dep$clearElement()
}