get_xml_prediction = function(xml_location,
                              xml_name,
                              riskcost_model_location,
                              propensity_model_location,
                              peril,
                              m_type,
                              veh_grp_path) {
  
  xml_name <- gsub(".xml","",xml_name)
  xml_path <- paste0(xml_location,xml_name,".xml")
  model_path <-  file.path(riskcost_model_location, peril, m_type, "CV.RDS")
  
  #### Data Prep 
  
  
  model_data <- xml_data_prep(xml_path,
                              veh_grp_path = veh_grp_path)
  
  #### Knots etc
  
  model_data <- enrichment_data_prep(model_path = model_path,
                       model_data = model_data)
  
  for ( i in 1:10 ) {
    riskcost_prediction <- predict_riskcost(model_path = model_path,
                                            model_data = model_data)
  }
  
  propensity_prediction <- predict_propensity(model_data_propensity = model_data,
                                              propensity_model_location = propensity_model_location)
  
  return(c(riskcost_prediction,
           propensity_prediction$delta_nonpremiumvars,
           propensity_prediction$delta_premiumvars))
}
