predict_propensity <- function(model_data_propensity,
                               CV_propensity)
{
  model_data_propensity <- data_prep_propensity(model_data_propensity)
  
  
  
  CV_propensity_coefs <- coef(CV_propensity,s="lambda.1se")[,1]
  
  # assuming model has the additional 400+ variables of mock data prep
  additional_coef_cols <- setdiff(colnames(model_data_propensity),names(CV_propensity_coefs))
  additional_coef_vals <- runif(length(additional_coef_cols))
  
  CV_propensity_coefs_orig <- names(CV_propensity_coefs)
  CV_propensity_coefs <- append(CV_propensity_coefs,additional_coef_vals)
  names(CV_propensity_coefs) <- c(CV_propensity_coefs_orig,additional_coef_cols)
  
  # find premium variables
  CV_propensity_coefs_premiumvars <- CV_propensity_coefs[grepl("LST_ANN",names(CV_propensity_coefs))]
  CV_propensity_coefs_nonpremiumvars <- CV_propensity_coefs[setdiff(names(CV_propensity_coefs),names(CV_propensity_coefs_premiumvars))]
  
  
  # creating mock premium variable
  model_data_propensity[,"LST_ANN"] <- 1 
  
  
  # adding Intercept column and ensuring correct column/coefficient order
  model_data_propensity[,"(Intercept)"] <- 1
  model_data_propensity <- model_data_propensity[,names(CV_propensity_coefs)]
  
  model_data_propensity_premiumvars <- model_data_propensity[,names(CV_propensity_coefs_premiumvars)]
  model_data_propensity_nonpremiumvars <- model_data_propensity[,names(CV_propensity_coefs_nonpremiumvars)]
  
  # computing premium and non premium components of linear predictions to be used in Polaris
  delta_nonpremiumvars <- predict_delta_from_matrix(onehotenc_data = model_data_propensity_nonpremiumvars,
                                                    coefs = CV_propensity_coefs_nonpremiumvars)
  
  delta_premiumvars <- predict_delta_from_matrix(onehotenc_data = model_data_propensity_premiumvars,
                                                 coefs = CV_propensity_coefs_premiumvars)
  
  return(list("delta_nonpremiumvars"=delta_nonpremiumvars,
              "delta_premiumvars"=delta_premiumvars))
}