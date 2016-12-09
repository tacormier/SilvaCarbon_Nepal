# Learning R
# 09_reading_and_writing_files.R
# Tina Cormier
# December, 2016

# When writing directory paths in R using Windows, "\\" is the same as "/."


# Reading csv files or other tables as a variable
flowers <- read.csv(file="/Users/tcormier/Documents/capacity_building/lidar_workshop_Nepal_20161202/tcormier_intro_to_R/iris.csv", header=TRUE)

dim(flowers)
str(flowers)
head(flowers)
summary(flowers)

# Reading other formats 
auto <- read.table(file="/Users/tcormier/Documents/capacity_building/lidar_workshop_Nepal_20161202/tcormier_intro_to_R/cars.txt", header=TRUE, sep=" ")

dim(auto)
str(auto)
head(auto)
summary(auto)

# READING IMAGES INTO R. 
# Read in single band images
# Load raster package
library(raster)
hh <- raster("/Users/tcormier/Documents/capacity_building/lidar_workshop_Nepal_20161202/tcormier_intro_to_R/ALPSRP127346900_29266_fbd_fr_pwr_nofil_HH.tif")

hh
nlayers(hh)
projection(hh)
dim(hh)
dataType(hh)

# Read a multi-band image. 
fbd <- brick("/Users/tcormier/Documents/capacity_building/lidar_workshop_Nepal_20161202/tcormier_intro_to_R/ALPSRP127346900_29266_fbd_fr_dB_whrc.tif")

fbd
nlayers(fbd)
dim(fbd)
dataType(fbd)
NAvalue(fbd)

# # # # # # # # # # # # # # # # # # # #  WRITING DATA # # # # # # # # # # # # # # # # # # # # 

# Writing a csv file
head(flowers)
write.csv(flowers, file="/Users/tcormier/Documents/capacity_building/lidar_workshop_Nepal_20161202/tcormier_intro_to_R/flowers_new.csv", row.names=FALSE, quote=FALSE)

# Write other table files (can also append to existing tables)
head(auto)
write.table(auto, file="/Users/tcormier/Documents/capacity_building/lidar_workshop_Nepal_20161202/tcormier_intro_to_R/cars_new.txt", quote=FALSE, sep=" ", row.names=FALSE)

# Writing image data.  NOTE that some images will be large and 
# should be written out in blocks. See the following functions 
# in the Raster package: "blockSize," "writeValues," "writeStart," 
# and "writeStop."

# Also, some of the functions in the Raster package have a built-in
# file output option - be on the lookout for those.

# Some settings for the output image.
type <- dataType(fbd)
# Set nd value to 0 (or whatever you want)
nd <- NAvalue(fbd) <- 0

writeRaster(fbd, filename="/Users/tcormier/Documents/capacity_building/lidar_workshop_Nepal_20161202/tcormier_intro_to_R/TEST.tif", format="GTiff", overwrite=TRUE, datatype=type, NAflag=nd)


