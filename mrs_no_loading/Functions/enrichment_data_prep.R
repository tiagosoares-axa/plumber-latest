enrichment_data_prep = function(CV,model_data) {
  
  model_factors <- row.names(CV$HDtweedie.fit$beta)
  
  knots_to_build <- model_factors[grepl("_[0-9]+$",model_factors)]
  
  #loop over all knots and construct: 
  for (i in knots_to_build) { 
    
    factor <- gsub("_[0-9]+$","",i)
    knot_val <- gsub(paste0(factor,"_"),"",i)
    
    #assign the new knot to data (pmin may well be wrong): 
    model_data[[i]] <- as.numeric(pmin(knot_val,model_data[[factor]]))
    
  }
  
  #reorder: 
  model_data <- model_data[,model_factors]
  
  return(model_data)
  
}