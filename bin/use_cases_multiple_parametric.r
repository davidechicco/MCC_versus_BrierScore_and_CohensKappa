setwd(".")
options(stringsAsFactors = FALSE)
cat("\014")
set.seed(11)
options(repos = list(CRAN="http://cran.rstudio.com/"))


this_number_of_ones <-  NULL
this_number_of_zeros <- NULL
thisRatioA <- NULL
thisRatioB <- NULL
thisRatioC <- NULL

args = commandArgs(trailingOnly=TRUE)
ARGS_DIM <- 2

if (length(args) < ARGS_DIM) {
  stop("At least ", ARGS_DIM," argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==ARGS_DIM) {

  this_number_of_ones <-  as.numeric(args[1])
  this_number_of_zeros <- as.numeric(args[2])
#  thisRatioA <- as.numeric(args[3])
#  thisRatioB <- as.numeric(args[4])
#  thisRatioC <- as.numeric(args[5])
}

print(args)

cat("this_number_of_ones: ", this_number_of_ones, "\n")
cat("this_number_of_zeros: ", this_number_of_zeros, "\n\n")
#cat("thisRatioA: ", thisRatioA, "\n")
#cat("thisRatioB: ", thisRatioB, "\n")
#cat("thisRatioC: ", thisRatioC, "\n\n\n")



list.of.packages <- c("easypackages",  "lubridate")
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
rates_computator <- function(shape_ones_alpha, shape_ones_beta, shape_zeros_alpha,  shape_zeros_beta, number_of_ones, number_of_zeros, keyword)
{


  cat("thisShapeA1, thisShapeA2, thisShapeB1,  thisShapeB2:\n")
  cat(thisShapeA1, " ", thisShapeA2, " ", thisShapeB1,  " ", thisShapeB2, "\n")

  
  response <- c(rep(ONE, number_of_ones), rep(ZERO, number_of_zeros))

  positive_perc <- number_of_ones * 100 / (number_of_ones + number_of_zeros)
  negative_perc <- number_of_zeros * 100 / (number_of_ones + number_of_zeros)

  num_observations_ones_chunk <- number_of_ones
  num_observations_zeros_chunk <- number_of_zeros


  predictor <- c(rbeta(num_observations_ones_chunk, shape_ones_alpha, shape_ones_beta), rbeta(num_observations_zeros_chunk, shape_zeros_alpha, shape_zeros_beta))

  stopifnot( (num_observations_ones_chunk + num_observations_zeros_chunk) == (number_of_ones + number_of_zeros))

  cf_output <- confusion_matrix_rates(response, predictor, " ")
  
  diff_BS_MCC <- abs(as.data.frame(cf_output)$"normMCC" - as.data.frame(cf_output)$"complBS")
  cat("normMCC and complBS = delta =", dec_three(diff_BS_MCC),"\n")
  
  # if(diff_BS_MCC >= 0.5) cat("High difference between normMCC and complBS:", dec_three(diff_BS_MCC), "\t**************\n")

}



# this_number_of_ones <-  1000 
# this_number_of_zeros <- 10000

# this_number_of_ones <-  1000
# this_number_of_zeros <- 100
# thisRatioA <- 0.3
# thisRatioB <- 0.7
# thisRatioC <- 1


thisKeyword <- "test aaa00"

upper_limit <- 15

this_response <- c(rep(ONE, this_number_of_ones), rep(ZERO, this_number_of_zeros))

this_positive_perc <- this_number_of_ones * 100 / (this_number_of_ones + this_number_of_zeros)
this_negative_perc <- this_number_of_zeros * 100 / (this_number_of_ones + this_number_of_zeros)

cat("Imbalance of the dataset:\n")
cat("  positive percentage ", dec_two(this_positive_perc), "%\n", sep="")
cat("  negative percentage ", dec_two(this_negative_perc), "%\n\n", sep="")

count <- 1

for(thisShapeA1 in 1:upper_limit)  for(thisShapeA2 in 1:upper_limit)  for(thisShapeB1 in 1:upper_limit) for(thisShapeB2 in 1:upper_limit) {
    
    completedPerc <- dec_three((count*100) / (upper_limit^4))
    cat("\ncompleted: ", completedPerc, "%\n", sep="")
    
    rates_computator(thisShapeA1, thisShapeA2, thisShapeB1,  thisShapeB2, this_number_of_ones, this_number_of_zeros, thisKeyword)
    count <- count + 1
}

computeExecutionTime()
