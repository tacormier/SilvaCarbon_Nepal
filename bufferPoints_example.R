# Buffers shapefiles by a given radius
# Tina Cormier
# December, 2016

library(raster)
library(rgeos)

# Enter file path for your points shapefile
pt.shapefile <- "/Users/tcormier/Documents/capacity_building/lidar_workshop_Nepal_20161202/Alicia/for_Tina/Final_plots_all_blocks_TAL_from_Arbonaut/Final_plots_all_blocks.shp"

# Enter the path where you want to save the buffered shapefile (remember to keep
# the trailing slash)
outdir <- "/Users/tcormier/Documents/test/"

# Enter radius for buffer
rad <- 20

########################################
# Open shapefile
pts <- shapefile(pt.shapefile)

# Buffer
buff <- gBuffer(pts, byid = T, width=20, quadsegs=20)

# Write output shapefile
outshp <- paste0(outdir, unlist(strsplit(basename(pt.shapefile), "\\."))[1], "_buffer_", rad, "m.shp")
shapefile(buff, outshp, overwrite=T)
