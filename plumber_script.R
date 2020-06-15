library(HDtweedie)
library(glmnet)

parent_path <- "/app/mrs_no_loading/"

# parent_path <- "H:/Plumber/plumber/mrs_no_loading/"
# setwd(parent_path)


#### Fixed path locations
riskcost_model_location = paste0(parent_path,'Resources/Risk_Models/')
propensity_model_location = paste0(parent_path,'Resources/Propensity_Models/CV_propensity.RDS')
veh_grp_path = paste0(parent_path,'Resources/veh_grp_lookup.csv')
model_path <-  file.path(riskcost_model_location, "F", "Severity", "CV.RDS")

#hard code; 
HC_CV_propensity <- readRDS(propensity_model_location)
HC_CV <- readRDS(model_path)
HC_veh_lookup <- read.csv(veh_grp_path)
HC_CV_propensity_coefs <- coef(HC_CV_propensity,s="lambda.1se")[,1]

for (i in list.files(paste0(parent_path,"Functions/"),full.names = T)) source(i)

PolData.Vehicle.Vehicle_DateManufactured.Val <<- "01/01/2015"
PolData.Vehicle.Vehicle_Model.Val <<- "90700000"
PolData.Driver.Driver_DateOfBirth.Val <<- "05/07/1953"
PolData.Driver.Driver_DateOfBirth.Val.1 <<- "09/10/1946"


#* @get /get_prediction
function(input_integer = 1){ 	

    test_noload <-
      function(veh_lookup = HC_veh_lookup,
       CV = HC_CV,
       CV_propensity_coefs = HC_CV_propensity_coefs) {
    
      #return(PolData.Vehicle.Vehicle_DateManufactured.Val)
      start_time <- Sys.time()
      
      #### Data Prep 
      
      model_data <- api_input_data_prep(veh_lookup = veh_lookup)
      
      #### Knots etc
      
      model_data <- enrichment_data_prep(CV = CV,
                                 model_data = model_data)
      
      
      for (i in 1:10)
      {
    riskcost_prediction <- predict_riskcost(CV = CV,
                                        model_data = model_data)
      }
    
    
      for (i in 1:10)
      {
    propensity_prediction <- predict_propensity_no_feature_simulation(model_data_propensity = model_data,
                                                                  CV_propensity_coefs = CV_propensity_coefs)
      }
    
      end_time <- Sys.time()
      time_taken <- end_time-start_time
      
      return(c(round(as.numeric(time_taken),3),
	   as.numeric(substr(utils::packageVersion("glmnet"),1,1)),
       riskcost_prediction,
       propensity_prediction$delta_nonpremiumvars,
       propensity_prediction$delta_premiumvars))
    }
      
    test_noload()

}
