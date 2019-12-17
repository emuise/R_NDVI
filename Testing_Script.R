library(tidyverse)
library(raster)
library(rgdal)
library(rgeos)
library(RColorBrewer)

multi_20160701 <- stack("Imagery/20160701_172513_0c2b_1B_AnalyticMS_DN.tif")
multi_20160701 <- brick(multi_20160701)

Calculate_NDVI <- function(NIR_band, Red_band){
  NDVI <- (NIR_band - Red_band) / (NIR_band + Red_band)
  return(NDVI)
}

ndvi_20160701 <- overlay(multi_20160701[[4]], multi_20160701[[3]], fun = Calculate_NDVI)

plot(ndvi_20160701)
