setwd(".")
options(stringsAsFactors = FALSE)
cat("\014")
# set.seed(11)
options(repos = list(CRAN="http://cran.rstudio.com/"))

list.of.packages <- c("easypackages", "ggplot2", "lubridate")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library("easypackages")
libraries(list.of.packages)

source("./utils.r")
source("./confusion_matrix_rates.r")

ONE <- 1
ZERO <- 0

number_of_ones <-   1000
number_of_zeros <- 10000

response <- c(rep(ONE, number_of_ones), rep(ZERO, number_of_zeros))

positive_perc <- number_of_ones * 100 / (number_of_ones + number_of_zeros)
negative_perc <- number_of_zeros * 100 / (number_of_ones + number_of_zeros)

cat("Imbalance of the dataset:\n")
cat("  positive percentage ", dec_two(positive_perc), "%\n", sep="")
cat("  negative percentage ", dec_two(negative_perc), "%\n\n", sep="")

ratioA <- 0.3
ratioB <- 0.7
ratioC <- 1

num_observationsA <- round(ratioA * number_of_ones)
num_observationsB <- round(ratioB * number_of_ones)
num_observationsC <- round(ratioC * number_of_zeros)

shapeA1 <- 12
shapeA2 <- 2

shapeB1 <- 3
shapeB2 <- 4

shapeC1 <- 2
shapeC2 <- 3

predictor <- c(rbeta(num_observationsA, shapeA1, shapeA2), rbeta(num_observationsB, shapeB1, shapeB2), rbeta(num_observationsC, shapeC1, shapeC2))

stopifnot( (num_observationsA + num_observationsB + num_observationsC) == (number_of_ones + number_of_zeros))

cf_output <- confusion_matrix_rates(response, predictor, " ")

# 
# # 2nd use case
# response <- c(0, 0, 0, 0, 0, 1, 1, 1, 1, 1)
# predictor <- c(0.1, 0.1, 0.1, 0.1, 0.1, 0.9, 0.9, 0.9, 0.9, 0.9)
# cf_output <- confusion_matrix_rates(response, predictor, "2nd use case")
# 
# # 3rd use case
# response <- c(0, 0, 0, 0, 0, 1, 1, 1, 1, 1)
# predictor <- c(0.1, 0.8, 0.1, 0.1, 0.1, 0.9, 0.9, 0.9, 0.2, 0.9)
# cf_output <- confusion_matrix_rates(response, predictor, "3rd use case")
