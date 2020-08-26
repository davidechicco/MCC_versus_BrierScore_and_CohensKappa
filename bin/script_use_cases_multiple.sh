#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#
set -o nounset -o pipefail # -o errexit
set -o xtrace

random_number=$(shuf -i1-10000 -n1)
this_number_of_ones=""
this_number_of_zeros=""
thisRatioA=""
thisRatioB=""
thisRatioC=""

# neg imb
configutation="neg_imb"
outputFile="../results/"$configutation"_"$random_number
echo $outputFile

this_number_of_ones="100"
this_number_of_zeros="1000"
thisRatioA="0.7"
thisRatioB="0.3"
thisRatioC="1"

Rscript use_cases_multiple_parametric.r $this_number_of_ones $this_number_of_zeros $thisRatioA $thisRatioB $thisRatioC > $outputFile 2>  $outputFile;


# pos imb
configutation="pos_imb"
outputFile="../results/"$configutation"_"$random_number
echo $outputFile

this_number_of_ones="1000"
this_number_of_zeros="100"
thisRatioA="0.7"
thisRatioB="0.3"
thisRatioC="1"

Rscript use_cases_multiple_parametric.r $this_number_of_ones $this_number_of_zeros $thisRatioA $thisRatioB $thisRatioC > $outputFile 2>  $outputFile;


# balanced
configutation="balanced"
outputFile="../results/"$configutation"_"$random_number
echo $outputFile

this_number_of_ones="100"
this_number_of_zeros="100"
thisRatioA="0.7"
thisRatioB="0.3"
thisRatioC="1"

Rscript use_cases_multiple_parametric.r $this_number_of_ones $this_number_of_zeros $thisRatioA $thisRatioB $thisRatioC > $outputFile 2>  $outputFile;



echo -e "\nThe real end\n"

