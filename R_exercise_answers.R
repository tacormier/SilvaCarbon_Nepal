# 1. Read the iris.csv file into R (assign the file to a variable of your choice), and answer the following questions.

flwr <- read.csv("/Users/tcormier/Documents/capacity_building/lidar_workshop_Nepal_20161202/tcormier_intro_to_R/iris.csv", header=TRUE)

# 2. How many rows and columns does the table have? 
# answer: 150 rows, 5 columns

dim(flwr)

# 3. What are the column names? 
# answer: "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width"  "Species"

names(flwr)
# or
colnames(flwr)

# 4. What value is located in row 49, column 5?    HINT: Use an index.
# answer: setosa

flwr[49,5]

# 5. What is the range of values (min - max) of the column "Petal.Length"?
# answer: 1.0 - 6.9 

range(flwr$Petal.Length)
# or
summary(flwr$Petal.Length)

# 6. What is the mean Sepal.Length?
# answer: 5.843333

mean(flwr$Sepal.Length)

# 7. What is the mean Sepal.Length by species?
# answer: setosa versicolor  virginica 
#          5.006      5.936      6.588 

tapply(flwr$Sepal.Length, flwr$Species, mean)

# 8. Add a column to the "flowers" data frame, and name it "cut". Populate the column with NA for now.

flwr$cut <- NA
head(flwr)

# 9. EXTRA CREDIT: For every record, if the Petal.Length is greater than 3, populate the "cut" field with the word "yes." For all other values of Petal.Length, "cut" should have the value "no".

# use if/else statement
flwr$cut <- ifelse(flwr$Petal.Length > 3, "yes", "no")

# OR

# use indexing
flwr$cut[flwr$Petal.Length > 3] <- "yes"
flwr$cut[flwr$Petal.Length <= 3] <- "no"

# 10a. EXTRA EXTRA CREDIT: Add another columne to the "iris" data frame, and name it "index."  Values in this column should range from 1 - number of rows in "iris". 
flwr$index <- 1:nrow(flwr)

# 10b. Next, for every record in the "iris" data frame, print the sentence "Plant [value in Index column] is an iris [value in the Species column]." 

# Hints: for 10b., use a loop with a print/paste statement.

for (i in c(1:nrow(flwr))) {
	print(paste("Plant ", flwr$index[i], " is an iris ", flwr$Species[i], sep=""))
	}
