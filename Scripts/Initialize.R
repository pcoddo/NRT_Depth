####################################################
### Filename: Initialize.R
####################################################
### Description: 
##  Checks data inputs and package requirements
##  for depth estimation functions
##
### Author: 
##  Perry Oddo [perry.oddo@nasa.gov]
##
### Last Modified:
##  7.19.18 
####################################################

### Clear all stored variables
rm(list = ls())
graphics.off()
gc()


### Load required libraries
library("raster")
library("rgdal")
library("RQGIS")
library("foreign")


### Set path to QGIS environment
set_env("C:/Program Files/QGIS 2.18")


### Load flood extent
flood_tiff = raster("Data/maria_flood.tif")


### Get desired coordinate reference system
location = "Myanmar" 
          # Thailand 
          # Cambodia 
          # Vietnam 
          # Laos_PDR
          # Myanmar

country_df = dget("Data/Projections/country_df")

crs = crs(flood_tiff)





