###### Multiple linear regression

### Import the data
Data<-read.delim("C:\\Users\\apeduzzi\\Documents\\Nepal project\\Materials for Stats workshop\\treeData.txt",header=TRUE)
names(Data)

### set up the data 
Data$AB<-Data$diameter*Data$diameter*0.005454154
names(Data)
attach(Data)
subData<-data.frame(height,diameter,AB,Ht_to_Live_Crown,CrRatio,Slope)
subData2<-na.omit(subData)
names(subData2)

### Scatterplot matrix
library(car)
scatterplotMatrix(subData2)

### Fit the model with all variables
model <- lm(height~diameter+AB+Ht_to_Live_Crown+CrRatio+Slope,data=subData)
summary(model)

### look at a plot of the residuals for each variable in the model
residualPlots(model, main="Residuals")

#graph of the residuals vs the predicated variables
model.res = rstandard(model)
apre = fitted.values(model)
model.pre = (apre-mean(apre))/sd(apre)
plot(model.pre, model.res,ylab="Res Std", xlab="Pre Std") 
abline(0, 0)   

### distribution of studentized residuals
library(MASS)
sresid <- studres(model) 
hist(sresid, freq=FALSE, 
   main="Distribution of Studentized Residuals")
xmodel<-seq(min(sresid),max(sresid),length=40) 
ymodel<-dnorm(xmodel) 
lines(xmodel, ymodel) 

### graph of the residuals
qqnorm(model.res,ylab="Res Sdt", xlab="Normal Scores") 
abline(0,1)

### Pearsons correlation coefficients
cor(subData2)

### Correlations with significance levels
library(Hmisc)
rc <- corr(subData2, type="pearson")

### Other useful functions 
coefficients(model) # model coefficients
confint(model, level=0.95) # CIs for model parameters 
fitted(model) # predicted values
residuals(model) # residuals
anova(model) # anova table  


### Stepwise Regression
library(MASS)
model <- lm(height~diameter+AB+Ht_to_Live_Crown+CrRatio+Slope, data=subData)
step <- stepAIC(model, direction="both")
step2 <- stepAIC(model, direction="forward")
step3 <- stepAIC(model, direction="backward")
# display results
step$anova 
step2$anova 
step3$anova  


### All Subsets Regression
library(leaps)
leaps<-regsubsets(AB~diameter+height+Ht_to_Live_Crown+CrRatio+Slope,data=subData,nbest=10)
### view results 
summary(leaps)

### plot a table of models showing variables in each model.
### models are ordered by the selection statistic.
plot(leaps,scale="r2")
plot(leaps,scale="Cp")
plot(leaps,scale="adjr2")
### plot statistic by subset size 
library(car)
subsets(leaps, statistic="adjr2")


### Evaluate extreme observations
outlierTest(model) # Bonferonni p-value for most extreme observations
qqPlot(model, main="QQ Plot") #qq plot for studentized residuals 
leveragePlots(model) # leverage plots 


### Infuential points
### added variable plots 
avPlots(model)
### Cook's D plot
### identify D values > 4/(n-k-1) 
cutoff <- 4/((nrow(Data)-length(model$coefficients)-2)) 
plot(model, which=4, cook.levels=cutoff)
### Influence Plot 
influencePlot(model, scale=10, xlab="Hat-Values", ylab="Studentized Residuals")


### Criteria indicators
library(stats)
AIC(model)
BIC(model)
library(locfit)
cp(model)

### Predictions
library(stats)
predict(model,se.fit=TRUE,interval="confidence",level=0.95)

### PRESS statistic
library(qpcR)
press<-PRESS(model)
barplot(press$residuals)

### Colinearity VIF 
library(car)
vif(model)
sqrt(vif(model))>2  #indicates which are greater than 2

library(perturb)
condIn<-colldiag(model,add.intercept=FALSE,center=TRUE)
print(condIn,dec.places=5)
colldiag(model,add.intercept=FALSE)


###### Additional Examples

### Adding an exponential to the regression 
ModelDiameterHeight<-lm(subData$height~subData$diameter)
summary(ModelDiameterHeight)
subData$diameter2<-subData$diameter**2

ModelDiameterHeight2<-lm(subData$height~subData$diameter+subData$diameter2)
summary(ModelDiameterHeight2)
plot(subData$height~subData$diameter,xlim=c(0,30), ylim=c(0,70),ylab="Height (ft)", xlab="Diameter (in)",col="black")
abline(a=coef(ModelDiameterHeight)[1],b=coef(ModelDiameterHeight)[2],col="red")
dbh<-unique(sort(subData$diameter))
fitted2<-coef(ModelDiameterHeight2)[1]+coef(ModelDiameterHeight2)[2]*dbh+coef(ModelDiameterHeight2)[3]*dbh**2
lines(dbh,fitted2,col="blue")


### Working with class variables
ModelDiameterHeight3<-lm(subData$height~subData$diameter+subData$Slope)
summary(ModelDiameterHeight3)
plot(subData$height~subData$diameter,xlim=c(0,30), ylim=c(0,70),ylab="Height (ft)", xlab="Diameter (in)",col=ifelse(subData$Slope==3,"green","blue"))
fitted3<-coef(ModelDiameterHeight3)[1]+coef(ModelDiameterHeight3)[2]*dbh+coef(ModelDiameterHeight3)[3]*2
lines(dbh,fitted3,col="blue")
fitted4<-coef(ModelDiameterHeight3)[1]+coef(ModelDiameterHeight3)[2]*dbh+coef(ModelDiameterHeight3)[3]*3
lines(dbh,fitted4,col="green")
abline(a=coef(ModelDiameterHeight3)[1],b=coef(ModelDiameterHeight3)[2],col="red")


