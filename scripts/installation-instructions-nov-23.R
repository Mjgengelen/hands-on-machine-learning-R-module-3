packages <- c("keras", "tensorflow", "reticulate", "tidyverse", "rstudioapi", "gridExtra", "rsample", "mgcv", "recipes")

# install all the needed R packages
new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

if(sum(!(packages %in% installed.packages()[, "Package"]))) {
  stop(paste('The following required packages are not installed:\n', 
             paste(packages[which(!(packages %in% installed.packages()[, "Package"]))], collapse = ', ')));
} else {
  message("All R packages are installed, part 1/2 completed!")
}

# the following instructions work on my system, with Python 3.11 locally installed
library(keras)
library(tensorflow)
library(reticulate)
# you should replace the path below with the path that leads to your local Python installation
# path_to_python <- "/usr/local/bin/python3" 
# virtualenv_create("r-reticulate")#, python = path_to_python
# install_tensorflow(envname = "r-reticulate")
conda_create(condaenv = "r-reticulate")
use_condaenv(condaenv = "r-reticulate")
tensorflow::install_tensorflow(condaenv = "r-reticulate")
# use_condaenv(condaenv = "r-reticulate")
install_keras(condaenv = "r-reticulate")
use_virtualenv("r-tensorflow")
# use_condaenv(condaenv = "r-reticulate")

# alternatively, you can follow the installation steps outlined here
# https://tensorflow.rstudio.com/install/

# run the following set of instructions as a test
# warning: the first time you run these instructions you may get some warnings/errors
#          then run the instructions a second time and verify if the ' ... part 2/2 completed!' message appears
if(as.array(tensorflow::tf$abs(-10)) == as.array(keras::k_abs(-10))){
  message('Installation of tensorflow and keras went well, part 2/2 completed!')
} else {
  stop('Something went wrong with installation of tensorflow and/or keras')
}

  