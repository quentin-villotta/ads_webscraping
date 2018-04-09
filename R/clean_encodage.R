clean_encodage<-function(x)
{
  x <- as.character(x)
  x<- str_replace_all(x,"<U\\+00E9>","e")
  x<- str_replace_all(x,"<U\\+00F4>","o")
  x<- str_replace_all(x,"<U\\+00E8>","e")
  x<- str_replace_all(x,"<U\\+00E7>","c")
  x<- str_replace_all(x,"<U\\+00CE>","i")
  return(x)
}


clean_encodage_df <- function(df)
{
  n <- ncol(df)
  for(index in 1:n)
  {
   df[,index] <-  clean_encodage(df[,index])
  }
  return(df)
}  
