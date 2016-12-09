##########################################################################################
# Date: December, 2016
# Authors: Tina Cormier 
# Purpose: Looping over a list of directories and stacking all TIFs in each directory
#   
##########################################################################################

library(raster)

#Set directory containing directories for each image/scene.
master.dir <- "/Users/tcormier/Documents/capacity_building/lidar_workshop_Nepal_20161202/tcormier_intro_to_R/scripting_example/data/"

#create list of directories within master directory
dirs <- dir(master.dir)

#for testing
i=1

#loop over each directory and stack all TIFs within each one.
for (i in c(1:length(dirs))) {
  #create name for output stack.
  out.name <- paste(master.dir, dirs[i], "/", dirs[i], "_stack.tif", sep="")
  #list images within directory.
  imgs <- list.files(paste(master.dir,dirs[i], sep=""), pattern="*.TIF$", full.names=T)
  #Stack layers into a raster brick object - not yet written to disk.
  img.stack <- stack(imgs)
  #Find the data type of the stack.
  dt <- dataType(img.stack)[1]
  
  #write image stack to disk - a few minutes on my mac
  print(paste0("writing ", out.name, " to disk. . ."))
  img.file <- writeRaster(img.stack, filename=out.name, format="GTiff", datatype=dt, overwrite=TRUE) 
  
} #End loop.