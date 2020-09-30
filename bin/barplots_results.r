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

# # # BS1, BS2, BS3
# # 
# # normMCC	complBS
# # 0.079	0.586
# # 0.135	0.556
# # 0.069	0.500
# # 
# # 
# selected_predictions <- c(0.079, 0.586, 0.135	, 0.556, 0.069, 0.500)

# # # BS4, BS5, BS6
# # 
# # complBS	normMCC
# # 0.581	0.080
# # 0.558	0.116
# # 0.524	0.085
# selected_predictions <- c(0.080, 0.581,   0.116,  0.558, 0.085, 0.524)

selected_predictions <- c(0.080, 0.581,   0.116,  0.558, 0.085, 0.524, 0.079, 0.586, 0.135, 0.556, 0.069, 0.500)


test_title <- "use_cases"
myPlotTitle <- "normMCC and complBS comparison"

# www.sthda.com/english/wiki/ggplot2-barplots-quick-start-guide-r-software-and-data-visualization



results_dataframe <- data.frame(
                cases=rep(c("balanced\nBS1", "neg imbal\nBS2", "pos imbal\nBS3", "balanced\nBS4", "neg imbal\nBS5", "pos imbal\nBS6"), each=2),
                rates=rep(c("normMCC", "complBS"), 6),
 
                values=selected_predictions
                )
                
num_to_return <- 1
upper_num_limit <- 1000
exe_num <- sample(1:upper_num_limit, num_to_return)

#  results_dataframe$"method" <- factor(results_dataframe$"method", level=c(1:length(results_dataframe$"method")))

print(results_dataframe)
                
# head(results_dataframe)
# 
# method rate         value
#1 RF              MCC       0.810 
#2 criterion   MCC      0.771
#3 RF               F1         0.828

# bal normMCC 0.079
# bal complBS   0.586
# neg_imbal normMCC 0.135
# neg_imbal complBS   0.556
# pos_imbal normMCC   0.069
# pos_imbal complBS 0.5


myTextSize <- 8

p <- ggplot(data=results_dataframe, aes(x=cases, y=values, fill=rates)) + geom_bar(stat="identity", position=position_dodge()) +
  scale_x_discrete(limits=results_dataframe$"cases") + ggtitle(myPlotTitle) + theme(text=element_text(size=myTextSize), axis.text=element_text(size=myTextSize), axis.title=element_text(size=myTextSize), plot.title = element_text(hjust = 0.5)) + 
  ylim(0, 1)

p

plot_height <- 6

general_file <- paste("../plots/", test_title, "_rand", exe_num,  ".pdf", sep="")
SAVE_GENERAL_PLOT <- TRUE
    
if (SAVE_GENERAL_PLOT) {
      ggsave(p, file=general_file, height = plot_height, width = 16, units = "cm", dpi = 150)
      cat("saved file: ", general_file, "\n",  sep="")
}

computeExecutionTime()
