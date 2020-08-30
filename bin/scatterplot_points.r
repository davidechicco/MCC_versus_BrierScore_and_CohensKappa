setwd(".")
options(stringsAsFactors = FALSE)
cat("\014")
# set.seed(11)

list.of.packages <- c("easypackages", "ggplot2")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library("easypackages")
libraries(list.of.packages)

#source("./confusion_matrix_rates.r")
source("./utils.r")

fileName <- "../results/pos_imb_1879_only_values.csv"
myPlotTitle <- "positively imbalanced dataset"
tag <- "pos_imb"

# fileName <- "../results/balanced_1879_only_values.csv"
# myPlotTitle <- "balanced dataset"
# tag <- "bal"

# fileName <- "../results/neg_imb_1879_only_values.csv"
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
    LIM <-100000
    values_data <- values_data_original[1:LIM,]


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
    SAVE_GENERAL_PLOT <- TRUE
        
    if (SAVE_GENERAL_PLOT) {
        ggsave(p, file=general_file, height = plot_height, width = plot_width, units = "cm", dpi = 150)
        cat("saved file: ", general_file, "\n",  sep="")
    }

}

computeExecutionTime()
