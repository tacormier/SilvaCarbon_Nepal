# Learning R
# 10_SpatialR.R
# Tina Cormier
# December, 2016
# R has various packages for performing GIS 
# and remote sensing tasks. This script demonstrates a very
# small sample of what R can do with raster and vector datasets.
#

# First, we'll look at the documentation for the raster package to get an idea
# of some of the spatial functions available to us.
# Found in your tutorial directory and named "raster.pdf"

# Some packages (there are many others):
library(raster)
library(rgdal)
# library(maptools)

# So, we have one landsat image, but they were downloaded as individual bands - list the directory here:
ls.dir <- "/Users/tcormier/Documents/capacity_building/lidar_workshop_Nepal_20161202/tcormier_intro_to_R/data/"

# And one file of field points (example locations) for all of Nepal. *Note the .shp file extension is missing -
# we'll talk about that in a moment.
field.file <- "/Users/tcormier/Documents/capacity_building/lidar_workshop_Nepal_20161202/tcormier_intro_to_R/data/Nepal_country_samplePoints_utm45N"

# We also have a shapefile of the country boundaries
cb.file <- "/Users/tcormier/Documents/capacity_building/lidar_workshop_Nepal_20161202/tcormier_intro_to_R/data/Nepal_countryBounds"

# Feel free to open these layers in your desktop GIS if you want to "see"
# what we are doing!

# First thing - we need to stack the landsat bands. For this exercise, let's just use 
# bands 5, 4, and 3 - but you could do this same procedure with 1 or 100 bands.
# So, we have the directory, but we need to tell R which files - We'll look for all 
# of the tiff files in the directory using the list.files() command - NOTE the pattern
# is case sensitive, at least on linux and on a mac. 
ls.files <- list.files(ls.dir, "*.TIF$", full.names=T)
ls.files

# To open a multiband image as a stack when each band is a separate file (see documentation on
# using "stack" vs. "brick"):
ls.img <- stack(ls.files[c(3,2,1)])
# Note that you may see a warning message when you run this. Something changed
# in the last update of R that caused this warning. Note that a warning is different
# than an error. A warning will often still execute your code, while an error will not
# and causes the code to stop where the error occurred. In this particular case, there is
# no problem and the developers are working on it!

# Check out your image.
# To get info about the image just type the variable name:
ls.img

# Let's write this out to disk so you can look at it in your desktop GIS.
writeRaster(ls.img, filename = paste0(ls.dir, "LC81410412016315LGN00_sr_543.tif"), overwrite=T, datatype="INT1U")

# As GIS analysts, our tendency is to want to look at the image!
# You can do that in a GIS (ArcGIS, QGIS, etc.), or take a quick
# look at it here
plotRGB(ls.img, 1, 2, 3) # Well that's nice, but how about a little contrast stretch?
plotRGB(ls.img, 1, 2, 3, stretch='lin')

# Let's open the Nepal sample points and country boundaries.
# We can use maptools OR rgdal. We'll use rgdal because it preserves
# the projection information and maptools does not. 
#
# To open a shapefile with rgdal, you need the directory name where 
# the shapefile is located AND the shapefile name, without the file 
# extension (take off the ".shp")

# These points could theoretically have biomass or land cover or other
# data gathered from the field associated with them.
nepal.pts <- readOGR(dirname(field.file), basename(field.file))
nepal.pts
plot(nepal.pts)

nepal.bound <- readOGR(dirname(cb.file), basename(cb.file))
plot(nepal.bound)
# Try adding the points over the country polygon using the "add=T" argument:
plot(nepal.pts, col='red', add=T) # why didn't that work?

# What is the projection?
projection(nepal.pts)
projection(nepal.bound)

# let's reproject the country boundary to match the points:
nepal.reproj <- spTransform(nepal.bound, CRS(projection(nepal.pts))) 
# Now try your plotting code again
plot(nepal.reproj)
plot(nepal.pts, col='red', add=T)

# But we only need points that cover our image, so let's first get the extent
# of the image:
img.extent <- extent(ls.img)

# Let's start over with our plot. Our points are the whole country:
plot(nepal.reproj)
plotRGB(ls.img, stretch='lin', add=T)
# Plot the points over the image:
plot(nepal.pts, pch=20, col="red", add=T)
# A handy link for base colors in R: http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
plot(img.extent, add=T, col="aquamarine4", lwd=5)

# Your classic GIS intersection, but between points (vector) and a raster - uses whole extent.
int <- intersect(nepal.pts, ls.img)
plot(int, pch=20, col="blue", add=T)

# Now we have a more manageable field plot subset. 
# Let's extract the values from the raster for each point (same as Extract Values to Points in ArcGIS),
# but a little faster, right?
pts.ex <- extract(ls.img, nepal.pts)

# Now we can examine our extraction:
head(pts.ex) # first few lines
tail(pts.ex) # last few lines
summary(pts.ex)

# The extraction is interesting, but maybe we realize we meant to buffer the points by the size of
# a field plot and take the mean image values? If our points represent 200 m diameter plots, we set
# buffer to 100 (radius) and add the function we want to calculate for the cells that fall within the buffer.
# You can also do a weighted mean. You can use this tool to extract points, lines, or polygons.
# This will take a few moments to run, so we'll just extract band 1 (landsat band 5) of our stack as an example.
b5 <- ls.img[[1]]
pts.ex.buff <- extract(b5, nepal.pts, buffer=100, fun=mean, na.rm=T)

# compare our point extraction to the buffer extraction - are they different?
summary(pts.ex[,1])
summary(pts.ex.buff)

# We can look at the point extraction data in various ways:
# band 5 histogram (column 1)
hist(pts.ex[,1], breaks=100)

# Well, that's a bit ugly. Let's try ggplot (just a little introduction)
library(ggplot2)
library(reshape)
# first need to make pts.ex a data frame so ggplot understands the structure
pts.ex <- as.data.frame(pts.ex)
# Let's rename the fields to something shorter:
names(pts.ex) <- c("L5", "L4", "L3")
# Now we "melt" it into long format:
pts.ex.melt <- melt(pts.ex)
head(pts.ex.melt)
# Now we can see that what were formerly the column names are
# now repeated as rows for each entry. 

# A pretty plot
ggplot(data = pts.ex.melt) + geom_histogram(aes(x = value, y=(..count..)/sum(..count..), fill=variable), 
                   alpha=0.5, binwidth=5, position="identity")

# That's interesting, but maybe it would look better as a density curve.
ggplot(data = pts.ex.melt, aes(value, fill=variable)) + geom_density(alpha=0.4)

# Now we have linked field data with image data, and hopefully you see that, in 
# many cases, R can be used like your regular GIS software, but with the added 
# benefit of having full documentation of what you've done. 





