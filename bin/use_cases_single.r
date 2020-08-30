setwd(".")
options(stringsAsFactors = FALSE)
cat("\014")
set.seed(11)
options(repos = list(CRAN="http://cran.rstudio.com/"))

list.of.packages <- c("easypackages", "ggplot2", "lubridate")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library("easypackages")
libraries(list.of.packages)

source("./utils.r")
source("./confusion_matrix_rates.r")

global_print <- 0


ONE <- 1
ZERO <- 0


# rates computation
rates_computator <- function(ratio1stChunk, ratio2ndChunk, ratio3rdChunk, shapeA1, shapeA2, shapeB1,  shapeB2,  shapeC1,  shapeC2, number_of_ones, number_of_zeros, keyword)
{

   cat("\n\nuse case: ", thisKeyword, "\n", sep="")

  cat("ratio1stChunk, ratio2ndChunk, ratio3rdChunk:\n")
  cat(ratio1stChunk, " ", ratio2ndChunk, " ", ratio3rdChunk, "\n")

  cat("thisShapeA1, thisShapeA2, thisShapeB1,  thisShapeB2, thisShapeC1, thisShapeC2:\n")
  cat(thisShapeA1, " ", thisShapeA2, " ", thisShapeB1,  " ", thisShapeB2, " ", thisShapeC1, " ", thisShapeC2, "\n")

  
  response <- c(rep(ONE, number_of_ones), rep(ZERO, number_of_zeros))

  positive_perc <- number_of_ones * 100 / (number_of_ones + number_of_zeros)
  negative_perc <- number_of_zeros * 100 / (number_of_ones + number_of_zeros)

  if(global_print == 0) {
    cat("Imbalance of the dataset:\n")
    cat("  positive percentage ", dec_two(positive_perc), "%\n", sep="")
    cat("  negative percentage ", dec_two(negative_perc), "%\n\n", sep="")
    global_print <- global_print + 1
  }

  num_observations_1st_chunk <- round(ratio1stChunk * number_of_ones)
  num_observations_2nd_chunk <- round(ratio2ndChunk * number_of_ones)
  num_observations_3rd_chunk <- round(ratio3rdChunk * number_of_zeros)


  predictor <- c(rbeta(num_observations_1st_chunk, shapeA1, shapeA2), rbeta(num_observations_2nd_chunk, shapeB1, shapeB2), rbeta(num_observations_3rd_chunk, shapeC1, shapeC2))

  stopifnot( (num_observations_1st_chunk + num_observations_2nd_chunk + num_observations_3rd_chunk) == (number_of_ones + number_of_zeros))

  cf_output <- confusion_matrix_rates(response, predictor, " ")
  
  diff_BS_MCC <- abs(as.data.frame(cf_output)$"normMCC" - as.data.frame(cf_output)$"complBS")
  cat("difference between normMCC and complBS:", dec_three(diff_BS_MCC),"\n")
  
  if(diff_BS_MCC >= 0.5) cat("High difference between normMCC and complBS:", dec_three(diff_BS_MCC), "\t**************\n")

}

thisRatioA <- 0.3
thisRatioB <- 0.7
thisRatioC <- 1


# thisKeyword <- "bal01"
# this_number_of_ones <-  50
# this_number_of_zeros <- 50
# thisShapeA1 <- 9 
# thisShapeA2 <- 15
# thisShapeB1  <- 9
# thisShapeB2 <- 15
# thisShapeC1 <- 12
# thisShapeC2 <- 7

# thisKeyword <- "neg_imbal_02"
# this_number_of_ones <-  10
# this_number_of_zeros <- 90
# thisShapeA1 <- 3
# thisShapeA2 <- 8
# thisShapeB1  <- 6
# thisShapeB2 <- 15
# thisShapeC1 <- 15
# thisShapeC2 <- 7

# thisKeyword <- "neg_imbal_03"
# # 7   15   8   14   15   8 
# this_number_of_ones <-  10
# this_number_of_zeros <- 90
# thisShapeA1 <- 7
# thisShapeA2 <- 15
# thisShapeB1  <- 8
# thisShapeB2 <- 14
# thisShapeC1 <- 15
# thisShapeC2 <- 8

thisKeyword <- "pos_imbal_04"
# 7   15   7   15   14   6 
this_number_of_ones <-  90
this_number_of_zeros <- 10
thisShapeA1 <- 7
thisShapeA2 <- 15
thisShapeB1  <- 7
thisShapeB2 <- 15
thisShapeC1 <- 14
thisShapeC2 <- 6




rates_computator(thisRatioA, thisRatioB, thisRatioC, thisShapeA1, thisShapeA2, thisShapeB1,  thisShapeB2, thisShapeC1, thisShapeC2, this_number_of_ones, this_number_of_zeros, thisKeyword)

computeExecutionTime()
