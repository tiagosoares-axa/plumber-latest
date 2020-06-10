predict_delta_from_matrix <- function(onehotenc_data,
                                coefs)
{
  if (length(coefs)>1)
  {
    delta <- as.matrix(onehotenc_data) %*% diag(as.numeric(coefs))
    delta <- rowSums(delta)
  }else{
    delta <- onehotenc_data * as.numeric(coefs)
  }

  # predictions <- 1/(1+exp(-delta))
  # 
  # return(list("delta"=delta,
  #             "predictions"=predictions))
  
  return(delta)
}