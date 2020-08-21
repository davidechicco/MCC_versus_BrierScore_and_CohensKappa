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

global_print <- 0


# rates computation
rates_computator <- function(ratioA, ratioB, ratioC, shapeA1, shapeA2, shapeB1,  shapeB2,  shapeC1,  shapeC2, number_of_ones, number_of_zeros, keyword)
{

  cat("thisRatioA, thisRatioB, thisRatioC, thisShapeA1, thisShapeA2, thisShapeB1,  thisShapeB2, thisShapeC1, thisShapeC2:\n")
  cat(thisRatioA, " ", thisRatioB, " ", thisRatioC, " ", thisShapeA1, " ", thisShapeA2, " ", thisShapeB1,  " ", thisShapeB2, " ", thisShapeC1, " ", thisShapeC2, "\n")

  response <- c(rep(ONE, number_of_ones), rep(ZERO, number_of_zeros))

  positive_perc <- number_of_ones * 100 / (number_of_ones + number_of_zeros)
  negative_perc <- number_of_zeros * 100 / (number_of_ones + number_of_zeros)

  if(global_print == 0) {
    cat("Imbalance of the dataset:\n")
    cat("  positive percentage ", dec_two(positive_perc), "%\n", sep="")
    cat("  negative percentage ", dec_two(negative_perc), "%\n\n", sep="")
    global_print <- global_print + 1
  }

  num_observationsA <- round(ratioA * number_of_ones)
  num_observationsB <- round(ratioB * number_of_ones)
  num_observationsC <- round(ratioC * number_of_zeros)


  predictor <- c(rbeta(num_observationsA, shapeA1, shapeA2), rbeta(num_observationsB, shapeB1, shapeB2), rbeta(num_observationsC, shapeC1, shapeC2))

  stopifnot( (num_observationsA + num_observationsB + num_observationsC) == (number_of_ones + number_of_zeros))

  cf_output <- confusion_matrix_rates(response, predictor, " ")
  
  diff_BS_MCC <- abs(as.data.frame(cf_output)$"normMCC" - as.data.frame(cf_output)$"complBS")
  cat("difference between normMCC and complBS:", dec_three(diff_BS_MCC),"\n")
  
  if(diff_BS_MCC >= 0.5) cat("High difference between normMCC and complBS:", dec_three(diff_BS_MCC), "\t**************\n")

}


ONE <- 1
ZERO <- 0

# this_number_of_ones <-  1000 
# this_number_of_zeros <- 10000

this_number_of_ones <-  10000
this_number_of_zeros <- 1000


thisRatioA <- 0.3
thisRatioB <- 0.7
thisRatioC <- 1

thisShapeA1 <- 12
thisShapeA2 <- 2

thisShapeB1 <- 3
thisShapeB2 <- 4

thisShapeC1 <- 2
thisShapeC2 <- 3

thisKeyword <- "test 00"

for(thisShapeA1 in 1:15)  for(thisShapeA2 in 1:15)  for(thisShapeB1 in 1:15) for(thisShapeB2 in 1:15) for(thisShapeC1 in 1:15)  for(thisShapeC2 in 1:15)  rates_computator(thisRatioA, thisRatioB, thisRatioC, thisShapeA1, thisShapeA2, thisShapeB1,  thisShapeB2, thisShapeC1, thisShapeC2, this_number_of_ones, this_number_of_zeros, thisKeyword)
