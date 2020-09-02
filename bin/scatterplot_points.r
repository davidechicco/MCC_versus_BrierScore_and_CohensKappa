setwd(".")
options(stringsAsFactors = FALSE)
cat("\014")
set.seed(11)

input_file_name <- NULL

args = commandArgs(trailingOnly=TRUE)
ARGS_DIM <- 1


if (length(args) < ARGS_DIM) {
  stop("At least ", ARGS_DIM," argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==ARGS_DIM) {

  input_file_name <-  toString(args[1])
}

SAVE_GENERAL_PLOT <- TRUE


list.of.packages <- c("easypackages", "ggplot2")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library("easypackages")
libraries(list.of.packages)

#source("./confusion_matrix_rates.r")
source("./utils.r")

fileName <- input_file_name
myPlotTitle <- NULL
tag <- NULL


if(grepl("pos_imb", fileName)) {

	myPlotTitle <- "positively imbalanced dataset"
	tag <- "pos_imb"
}

if(grepl("bal", fileName)) {

        myPlotTitle <- "balanced dataset"
        tag <- "bal"
}

if(grepl("neg_imb", fileName)) {

        myPlotTitle <- "negatively imbalanced dataset"
        tag <- "neg_imb"
}

cat("fileName: ", fileName, "\n", sep="")
cat("myPlotTitle: ", myPlotTitle, "\n", sep="")
cat("tag: ", tag, "\n\n", sep="")

# fileName <- "../results/pos_imb_8189_only_values.csv"
# myPlotTitle <- "positively imbalanced dataset"
# tag <- "pos_imb"

# fileName <- "../results/balanced_8189_only_values.csv"
# myPlotTitle <- "balanced dataset"
# tag <- "bal"

# fileName <- "../results/neg_imb_8189_only_values.csv"
# myPlotTitle <- "negatively imbalanced dataset"
# tag <- "neg_imb"

values_data_original <- read.csv(file=fileName, head=FALSE, sep="\t", stringsAsFactors=FALSE)
cat("fileName = ", fileName, "\n", sep="")

colnames(values_data_original) <- c("K",  "BS",  "binBS",  "MCC",  "normMCC",  "complBS")

loop_num <- 1
for(i in 1:loop_num) {

    # shuffle the rows
    values_data_original <- values_data_original[sample(nrow(values_data_original)),]

    # let's plot first a subset of the points
    # LIM <-200000
    # values_data <- values_data_original[1:LIM,]
    values_data <- values_data_original

    colnames(values_data) <- c("K",  "BS",  "binBS",  "MCC",  "normMCC",  "complBS")
    
    myPointSize <- 0.2
    
    x_axis_start <- 0
    x_axis_end <- 1
    y_axis_start <- 0
    y_axis_end <- 1
    
    myTextSize <- 12

    
    p <- ggplot(values_data, aes(x=normMCC, y=complBS)) + geom_point(size=myPointSize) + xlim(x_axis_start,x_axis_end) + ylim(y_axis_start,y_axis_end) + ggtitle(myPlotTitle) + theme(text=element_text(size=myTextSize), axis.text=element_text(size=myTextSize), axis.title=element_text(size=myTextSize), plot.title = element_text(hjust = 0.5)) 
    # p

    num_to_return <- 1
    upper_num_limit <- 1000
    exe_num <- sample(1:upper_num_limit, num_to_return)

    plot_height <- 16
    plot_width <- 16

    test_title <- "normMCC_versus_complBS"

    general_file <- paste("../plots/", tag, "_", test_title, "_rand", exe_num,  ".png", sep="")
        
    if (SAVE_GENERAL_PLOT) {
        ggsave(p, file=general_file, height = plot_height, width = plot_width, units = "cm", dpi = 150)
        cat("saved file: ", general_file, "\n",  sep="")
    }

}

computeExecutionTime()
