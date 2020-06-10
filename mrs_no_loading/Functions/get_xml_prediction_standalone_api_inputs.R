
##################################################################################
# PREPARE MOCK API JSON INPUT WITH SINGLE INPUT ELEMENTS
##################################################################################
# library(XML)
# library(RJSONIO)
# xml_path <- "D:/PricingDeployment/POC_step3/Pumber_xmls/Resources/XMLs/00AD57270F1AF4DF11CEAC6A96F76213.xml"
# xml_in <- XML::xmlParse(xml_path)
# xml_list <- xmlToList(xml_in)
# xml_single_inputs_df <- data.frame(name = make.unique(names(unlist(xml_list))), value = unlist(xml_list))
# 
# # send inputs to environment to simulate server reading
# for (i in 1:nrow(xml_single_inputs_df))
# {
#   assign(as.character(xml_single_inputs_df$name[i]),as.character(xml_single_inputs_df$value[i]))
# }
# peril = "F"
# m_type = "Severity"


##################################################################################
# STANDALONE FUNCTION TO BE DEPLOYED IN ML SERVER
##################################################################################
get_xml_prediction_standalone_api_inputs <- function()
{
  library(HDtweedie)
  library(glmnet)
  
  parent_path <- "D:/PricingDeployment/POC_step3/Pumber_xmls/"
  # setwd(parent_path)
  
  
  #### Fixed path locations
  riskcost_model_location = paste0(parent_path,'Resources/Risk_Models/')
  propensity_model_location = paste0(parent_path,'Resources/Propensity_Models/CV_propensity.RDS')
  veh_grp_path = paste0(parent_path,'Resources/veh_grp_lookup.csv')
  
  model_path <-  file.path(parent_path,riskcost_model_location, peril, m_type, "CV.RDS")
  
  for (i in list.files(paste0(parent_path,"Functions/"),full.names = T)) source(i)
  
  
  #### Data Prep 
  
  
  model_data <- api_input_data_prep(veh_grp_path = veh_grp_path)
  
  #### Knots etc
  
  model_data <- enrichment_data_prep(model_path = model_path,
                                     model_data = model_data)
  
  
  riskcost_prediction <- predict_riskcost(model_path = model_path,
                                          model_data = model_data)
  
  propensity_prediction <- predict_propensity(model_data_propensity = model_data,
                                              propensity_model_location = propensity_model_location)
  
  return(c(riskcost_prediction,
           propensity_prediction$delta_nonpremiumvars,
           propensity_prediction$delta_premiumvars))
}
