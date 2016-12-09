# Learning R
# exercise.R
# Tina Cormier
# December, 2016

# First, start a new R session. Then, write a program that does the following tasks: 

1. Read the iris.csv file into R (assign the file to a variable of your choice), and answer the following questions.

2. How many rows and columns does the table have?

3. What are the column names?

4. What value is located in row 49, column 5? HINT: Use an index.

5. What is the range of values (min - max) of the column named "Petal.Length"?

6. What is the mean Sepal.Length?

7. What is the mean Sepal.Length by species?   HINT: Use one of the apply functions.

8. Add a column to your "iris" data frame, and name it "cut". Populate it with "NA" for now.

9. EXTRA CREDIT: For every record, if the Petal.Length is greater than 3, populate the "cut" field with the word "yes." For all other values of Petal.Length, "cut" should have the value "no".

10a. EXTRA EXTRA CREDIT: Add another columne to the "iris" data frame, and name it "index."  Values in this column should range from 1 - number of rows. 

10b. Next, for every record in the "iris" data frame, print the sentence "Plant [value in Index column] is an iris [value in the Species column]." 

Hints: for 10b., use a loop with a print/paste statement. Output will look like this:
  
[1] "Plant 1 is an iris setosa"
[1] "Plant 2 is an iris setosa"
[1] "Plant 3 is an iris setosa"
[1] "Plant 4 is an iris setosa"
. . . .
[1] "Plant 149 is an iris virginica"
[1] "Plant 150 is an iris virginica"