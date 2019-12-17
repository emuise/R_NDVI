folder <- "Inputs"
filez <- as.list(list.files(folder, full.names = TRUE))
filename <- filez[[1]]

multi <- filename %>% stack() %>% brick()

Calculate_NDVI <- function(NIR_band, Red_band){
  NDVI <- (NIR_band - Red_band) / (NIR_band + Red_band)
  return(NDVI)
}

NDVI_from_filename <- function(filename){
  #getting new filename using the date of the original image
  date <- gsub(".*/", "", filename)
  date <- gsub("_.*", "", date)
  new_filename <- paste("NDVI", date, sep = "_")
  
  
  #calculating NDVI
  multi <- filename %>% stack() %>% brick()
  NDVI <- overlay(multi[[4]], multi[[3]], fun = Calculate_NDVI)
  plot(NDVI)
  
  
  return(NDVI)
}

NDVI_from_filename(filez[[2]])