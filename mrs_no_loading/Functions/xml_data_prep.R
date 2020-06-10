
xml_data_prep <-
  function(xml_path, 
           veh_grp_path = 'D:/Projects/Plumber_xmls_Local/Resources/veh_grp_lookup.csv'
           ) {
    
  
  # extract: 
  
  xml_in <- XML::xmlParse(xml_path)
  xml_list <- xmlToList(xml_in)
  customer_data <- xml_list[[5]]
  
  if(grepl("UKHouse",xml_list[[1]][1])) stop("xml is for a home quote")
  # veh_age:
  
  veh_yr <- customer_data$Vehicle$Vehicle_DateManufactured
  veh_yr <- as.Date(veh_yr,format = "%d/%m/%Y")
  
  veh_age <- as.numeric(floor(Sys.Date() - veh_yr)) / 365
  
  
  # veh group: 
  
  veh_mdl <- gsub("0+$","",customer_data$Vehicle$Vehicle_Model)
  
  veh_lookup <- read.csv(veh_grp_path)
  colnames(veh_lookup) <- c("model","s50")
  
  veh_s50 <- veh_lookup$s50[match(veh_mdl,veh_lookup$model)]
  
  #age diff:
  drivers_list <- customer_data[names(customer_data) %in% "Driver"]
  
  #assume first for now: 
  main_driver_dob <- as.Date(drivers_list[[1]]$Driver_DateOfBirth, format = "%d/%m/%Y")
  
  youngest_driver_dob <- 
    
    if (length(drivers_list) > 1 ) {
      
      if (length(drivers_list) > 2 ) {
        max(unlist(
          lapply(drivers_list[-1],function(x) {
            as.Date(x$Driver_DateOfBirth, format = "%d/%m/%Y")
          })
        ))
      } else {
        
        as.Date(drivers_list[[2]]$Driver_DateOfBirth, format = "%d/%m/%Y") 
        
      }
    } else {
      youngest_driver_dob <- main_driver_dob
    }
  
  age_diff <- floor(as.numeric(main_driver_dob - youngest_driver_dob) / 365)
  
  # combine:
  
  model_data <- data.frame(VEH_veh_age_clean = veh_age,
                           EXTVEHI_VEH_GROUP_S50_C_clean = veh_s50,
                           PER_Age_Diff_clean = age_diff)


}
