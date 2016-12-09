######## The Basics with tree data only

### Import the data
Data<-read.delim("C:\\Users\\apeduzzi\\Documents\\Nepal project\\Materials for Stats workshop\\treeData.txt",header=TRUE)
## Data<-Data[-21]
names(Data)

library(readxl)
TreeData <- read_excel("~/Nepal project/Materials for Stats workshop/TreeData.xlsx")
View(TreeData)

### basic summary statistics
length(Data$diameter)
min(Data$diameter)
max(Data$diameter)
mean(Data$diameter)
median(Data$diameter)
sort(Data$diameter)
quantile(Data$diameter, probs= c(0.25,0.5,0.75,1.00))
summary(Data$diameter)

### Create a boxplot
boxplot(Data$diameter~Data$species)

### Create a histogram with a smoothed curve and a normal distribution curve
hist (Data$diameter, breaks=5, freq=FALSE, xlim=c(0,25), ylim=c(0,.15),xlab="diameter",ylab="density",main="")
lines(density(Data$diameter),col="blue")
curve(dnorm(x, mean=mean(Data$diameter), sd=sqrt(var(Data$diameter))), col="red", lwd=2, add=TRUE, yaxt="n")

### Create a qq plot and conduct a Shapiro test for normality
qqnorm(Data$diameter)
abline(6,2.8)
shapiro.test(Data$diameter)

### Creata a pie chart 
speciesNumber<- c(length(subset(Data$species,Data$species==122)),length(subset(Data$species,Data$species==814)))
label<-c("Pinus","Quercus")
pie(speciesNumber,label)

### Calculate measures of variability
StandDev <-sd(Data$diameter, na.rm=TRUE)
Variance <-var(Data$diameter, na.rm=TRUE)
StandError <-sd(Data$diameter, na.rm=TRUE)/length(Data$diameter)^0.5
CV<- StandError/mean(Data$diameter)

### Conduct a two-sided t-test to see if the mean is equal to zero
t.test(Data$diameter,alternative="two.sided", mu=0, paired=FALSE, conf.level =0.95)


######## Simple Linear Regression

Data<-read.delim("C:\\Users\\apeduzzi\\Documents\\Nepal project\\Materials for Stats workshop\\treeData.txt",header=TRUE)

### Create a basic scatterplot of x and y with a lowess smooth curve and a straight line with intercept of 0 and a slope of 3
plot(Data$height~Data$diameter,xlim=c(0,30), ylim=c(0,70),ylab="Height (ft)", xlab="Diameter (in)",col="black")
abline(0,3)
sub<-subset(Data,Data$height!="NA")
lines(lowess(sub$diameter,sub$height),col="red")

### Calculate the Pearson's correlation coefficient
library(boot)
cor(cbind(sub$diameter, sub$height))
cor.test(sub$diameter, sub$height)
corr(cbind(sub$diameter, sub$height))

### Do a linear regression where height is the y-variable and diameter is the x-variable
lm(Data$height~Data$diameter)
ModelDiameterHeight<-lm(Data$height~Data$diameter)
summary(ModelDiameterHeight)
names(summary(ModelDiameterHeight))

### List of the fitted values and the residuals
fitted(ModelDiameterHeight)
residuals(ModelDiameterHeight)

### Create a scatterplot of the fitted and actual values and a straight line with intercept of 0 and a slope of 1
plot(fitted(ModelDiameterHeight),sub$height,xlim=c(0,60),ylim=c(0,60),ylab="Observed Height", xlab="Predicted Height",col="black")
abline(0,1)

### Create a residual plot, conduct a Shapiro test for normality, create a qq plot and a histogram for the residuals 
library(car)
residualPlots(ModelDiameterHeight)
shapiro.test(residualPlots(ModelDiameterHeight))
qqPlot(ModelDiameterHeight)

### Look leverage, outlier, and influence information for the observations
outlierTest(ModelDiameterHeight)
leveragePlots(ModelDiameterHeight) 
cooks.distance(ModelDiameterHeight)
influencePlot(ModelDiameterHeight, scale=10, xlab="Hat-Values", ylab="Studentized Residuals")

### Conduct a linear regression with the line going through the origin, create a scatterplot of the data with a line through the origin
lm(Data$height~Data$diameter+0)
summary(lm(Data$height~Data$diameter+0))
library(ape)
origin<-lmorigin(Data$height~Data$diameter, origin=TRUE)
plot(Data$diameter~Data$height,xlim=c(0,30), ylim=c(0,70),ylab="Height (ft)", xlab="Diameter (in)",col="black")
abline(0,3.2463)

### Conduct a linear regression with the line going through a fixed point
lm(I(Data$height-4.5)~0+Data$diameter)
summary(lm(I(Data$height-4.5)~0+Data$diameter))

#Look at the information without the one odd data point
outlier<-dim(1)
outlier$diameter<-Data$diameter[-38]
outlier$height<-Data$diameter[-38]
plot(Data$height~Data$diameter,xlim=c(0,30), ylim=c(0,70),ylab="Height (ft)", xlab="Diameter (in)",col="black")
Modeloutlier<-lm(outlier$height~outlier$diameter)
abline(Modeloutlier,col="red")
abline(ModelDiameterHeight,col="blue")

######## The Basics with plot data from Nepal

# Import the data
Data<-read.delim("C:\\Users\\apeduzzi\\Documents\\Nepal project\\Materials for Stats workshop\\plot_data.txt",header=TRUE)
names(Data)

### Create a basic scatterplot of x and y 
plot(Data$height_total~Data$diameter,xlim=c(0,100), ylim=c(0,30),ylab="Height (m)", xlab="Diameter (cm)",col="black")

### Calculate the Pearson's correlation coefficient
library(boot)
cor(cbind(sub$diameter, sub$height_total))
cor.test(sub$diameter, sub$height_total)
corr(cbind(sub$diameter, sub$height_total))

### Do a linear regression where height is the y-variable and diameter is the x-variable
lm(Data$height_total~Data$diameter)
ModelDiameterHeight<-lm(Data$height_total~Data$diameter)
summary(ModelDiameterHeight)
names(summary(ModelDiameterHeight))

### Create a scatterplot of the fitted and actual values and a straight line with intercept of 0 and a slope of 1
plot(fitted(ModelDiameterHeight),sub$height_total,xlim=c(0,60),ylim=c(0,60),ylab="Observed Height", xlab="Predicted Height",col="black")
abline(0,1)

### Create a residual plot, conduct a Shapiro test for normality, create a qq plot and a histogram for the residuals 
library(car)
residualPlots(ModelDiameterHeight)
shapiro.test(residualPlots(ModelDiameterHeight))
qqPlot(ModelDiameterHeight)

### Look leverage, outlier, and influence information for the observations
outlierTest(ModelDiameterHeight)
leveragePlots(ModelDiameterHeight) 
cooks.distance(ModelDiameterHeight)
influencePlot(ModelDiameterHeight, scale=10, xlab="Hat-Values", ylab="Studentized Residuals")



