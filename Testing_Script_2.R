library(tidyverse)
library(raster)
library(rgdal)
library(rgeos)
library(RColorBrewer)

folder <- "Inputs"
filez <- as.list(list.files(folder, full.names = TRUE))
trefry_study <- c(readOGR("Study_Areas/trefry_study.shp"))

Calculate_NDVI <- function(NIR_band, Red_band){
  NDVI <- (NIR_band - Red_band) / (NIR_band + Red_band)
  return(NDVI)
}

NDVI_from_filename <- function(filename, study_area){
  #getting new filename using the date of the original image
  date <- gsub(".*/", "", filename)
  date <- gsub("_.*", "", date)
  new_filename <- paste("NDVI_points", date, sep = "_")
  
  #convert from filename to a brick raster as these are apparently faster for calculation
  multi <- filename %>% stack() %>% brick()
  print(1)
  #clip the raster by the input study area
  multi <- crop(multi, study_area)
  print(2)
  #calculating NDVI
  #apparently using overlay with a premade function is faster, but this is the same as calling the function
  NDVI <- overlay(multi[[4]], multi[[3]], fun = Calculate_NDVI)
  print(3)
  #convert from raster to point, add date in the second column
  NDVI_points <- rasterToPoints(NDVI, spatial = TRUE)
  
  NDVI_points$Date <- date
  print(4)
  #save into outputs folder
  #writeOGR(NDVI_points, dsn = "Outputs", layer = new_filename, driver = "ESRI Shapefile")
  
  return(NDVI_points)
}

working_NDVI <- NDVI_from_filename(filez[[1]], trefry_study)
NDVI_points <- map2(filez, trefry_study, NDVI_from_filename)
