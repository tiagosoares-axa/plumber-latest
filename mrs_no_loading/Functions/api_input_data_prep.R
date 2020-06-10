
api_input_data_prep <-
  function(veh_lookup) {

    veh_yr <- PolData.Vehicle.Vehicle_DateManufactured.Val
    veh_yr <- as.Date(veh_yr,format = "%d/%m/%Y")
    
    veh_age <- as.numeric(floor(Sys.Date() - veh_yr)) / 365
    
    
    # veh group: 
    
    # veh_mdl <- gsub("0+$","",customer_data$Vehicle$Vehicle_Model)
    veh_mdl <- gsub("0+$","",PolData.Vehicle.Vehicle_Model.Val)
    
    
    colnames(veh_lookup) <- c("model","s50")
    
    veh_s50 <- veh_lookup$s50[match(veh_mdl,veh_lookup$model)]
    
    # #age diff:
    # drivers_list <- customer_data[names(customer_data) %in% "Driver"]
    drivers_list <- list("Driver1"=list("Driver_DateOfBirth"=PolData.Driver.Driver_DateOfBirth.Val),
                         "Driver2"=list("Driver_DateOfBirth"=PolData.Driver.Driver_DateOfBirth.Val.1))
    # 
    # #assume first for now: 
    # main_driver_dob <- as.Date(drivers_list[[1]]$Driver_DateOfBirth, format = "%d/%m/%Y")
    main_driver_dob <- as.Date(PolData.Driver.Driver_DateOfBirth.Val, format = "%d/%m/%Y")
    
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
