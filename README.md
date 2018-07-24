# NRT Depth

This code intakes a detected flood extent and applies the method described in [Cham et al. 2011](https://www.witpress.com/elibrary/wit-transactions-on-the-built-environment/168/34837) to estimate inundation depth:

![Workflow](https://github.com/pcoddo/NRT_Depth/blob/master/Images/Workflow.png)

### Instructions
1. Requires installation of [R](https://www.r-project.org/) and [QGIS](https://www.qgis.org/en/site/) on local machine. Software version information used here is as follows:
2. Place flood extent raster in `/Data` folder
3. Place digital elevation model in `/Data/DEM` folder
...

### Required R Packages
* [RQGIS](https://github.com/jannes-m/RQGIS)
* rgdal
* raster
* foreign

To install packages:
`install.packages("raster")`

To load packages:
`library(raster)`

### Software Version:
#### R
R version 3.3.3 (2017-03-06)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows >= 8 x64 (build 9200)

locale:
[1] LC_COLLATE=English_United States.1252  LC_CTYPE=English_United States.1252   
[3] LC_MONETARY=English_United States.1252 LC_NUMERIC=C                          
[5] LC_TIME=English_United States.1252    

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

loaded via a namespace (and not attached):
[1] tools_3.3.3

#### QGIS
|                           | Version          |   |                           | Version                |
|---------------------------|------------------|---|---------------------------|------------------------|
| QGIS version              | 2.18.9           |   | Running against GEOS      | 3.5.0-CAPI-1.9.0 r4084 |
| QGIS code revision        | 3a16a4e          |   | PostgreSQL Client Version | 9.2.4                  |
| Compiled against Qt       | 4.8.5            |   | SpatiaLite Version        | 4.3.0                  |
| Running against Qt        | 4.8.5            |   | QWT Version               | 5.2.3                  |
| Compiled against GDAL/OGR | 2.2.0            |   | PROJ.4 Version            | 493                    |
| Running against GDAL/OGR  | 2.2.0            |   | QScintilla2 Version       | 2.7.2                  |
| Compiled against GEOS     | 3.5.0-CAPI-1.9.0 |   |                           |                        |


### Contact:
Author: [Perry Oddo](mailto:perry.oddo@nasas.gov)
