data_prep_propensity <- function(model_data_propensity_input)
{
  
  # Square of several variables
  
  vars_to_square <- colnames(model_data_propensity_input)
  
  for (i in 1:10)
  {
    for (col in vars_to_square)
    {
      sqr_name <- paste0(col,"_sqrt_",i) 
      model_data_propensity_input[,sqr_name] <- model_data_propensity_input[,col]^2
    }
  }
  
  # Cap of several variables
  
  vars_to_cap <- colnames(model_data_propensity_input)
  
  for (i in 1:10)
  {
    for (col in vars_to_cap)
    {
      cap_name <- paste0(col,"_cap_",i) 
      model_data_propensity_input[,cap_name] <- pmin(model_data_propensity_input[,col],i)
    }
  }
  
  model_data_propensity_treated <- model_data_propensity_input

  
  return(model_data_propensity_treated)
}