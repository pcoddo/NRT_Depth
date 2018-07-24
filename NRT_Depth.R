####################################################
### Filename: NRT_Depth.R
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

# Initialize
source("Scripts/Initialize.R")

### Polygonize Raster
# Set Parameters
flood_poly = run_qgis(alg = "gdalogr:polygonize",
                     INPUT = flood_tiff,
                     OUTPUT = "Layers/flood_poly.shp",
                     load_output = TRUE)



### Select flooded attributes (DN = 1)
run_qgis(alg = "qgis:extractbyattribute",
         INPUT = flood_poly,
         FIELD = "DN",
         OPERATOR = "=",
         VALUE = 1,
         OUTPUT = "Layers/flood_select.shp",
         load_output = FALSE)


### Read in shapefile and reclassify with unique DN
flood_select = readOGR("Layers/flood_select.shp")
npoly = length(flood_select$DN)
flood_select@data$DN = 1:npoly
writeOGR(flood_select, dsn = "C:/Users/poddo/Documents/GitHub/NRT_Depth", 
         layer = "flood_select", 
         driver = "ESRI Shapefile", 
         overwrite_layer = T)


### Convert polygon to polyline
flood_line = run_qgis(alg = "qgis:polygonstolines",
                      INPUT = flood_select,
                      OUTPUT = file.path(tempdir(), "flood_line.shp"),
                      load_output = TRUE)


### Create points along line
run_qgis(alg = "qgis:createpointsalonglines",
         Lines = flood_line,
         Distance = "100",
         Startpoint = "0",
         Endpoint = "0",
         output = "Layers/flood_chain.shp",
         load_output = FALSE)



### Extract raster data from overlying polygon
flood_chain = readOGR("Layers/flood_chain.shp")
dem = raster("Data/DEM/srtm_23_09.tif")
result <- extract(dem, flood_chain, fun = mean, na.rm=TRUE, df=TRUE)


### Reproject dem
run_qgis(alg = "gdalogr:warpreproject",
         INPUT = "Data/DEM/srtm_23_09.tif",
         DEST_SRS = "EPSG:32620",
         OUTPUT = "Layers/dem_proj.tif")



### Append result to .dbf file of oringinal points
out.dbf <- read.dbf("Layers/flood_chain.dbf", as.is = TRUE)
out.dbf$Elevation <- result$srtm_23_09
write.dbf(out.dbf, "Layers/flood_chain.dbf")



### Produce Triangular Iterpolated network
# Find extent of shape
run_qgis(alg = "qgis:polygonfromlayerextent",
        INPUT_LAYER = flood_chain,
        BY_FEATURE = "False",
        OUTPUT = "Layers/extent.shp")

extent = readOGR("Layers/extent.shp")
extent_box = bbox(extent)



# Subset by flooded shape
flood_chain = readOGR("Layers/flood_chain.shp")

# Loop over each shape to produce a TIN
run_qgis(alg = "saga:triangulation",
         SHAPES = flood_chain,
         FIELD = 'Elevation',
         OUTPUT_EXTENT = sprintf("%s,%s,%s,%s", extent_box[1], extent_box[3], extent_box[2], extent_box[4]), 
         TARGET_USER_SIZE = "90",
         TARGET_USER_FITS = "0",
         TARGET_OUT_GRID = "Layers/tin_out.tif")



### Use raster calculator to subtract from underlying DEM
# Clip dem to extent
run_qgis(alg = "saga:clipgridwithpolygon",
         INPUT = "Layers/dem_proj.tif",
         POLYGONS = "Layers/extent.shp",
         OUTPUT = "Layers/dem_clip.tif") 


# Raster calculator
run_qgis(alg = "saga:rastercalculator",
         GRIDS = "Layers/tin_out.tif",
         XGRIDS = "Layers/dem_clip.tif",
         FORMULA = "a-b",
         USE_NODATA = "False",
         TYPE = "7",
         RESULT = "Results/depth_full.tif")



### Clip depth raster to flood polygon
run_qgis(alg = "saga:clipgridwithpolygon",
         INPUT = "Results/depth_full.tif",
         POLYGONS = "Layers/flood_select.shp",
         OUTPUT = "Results/depth_clip.tif")
