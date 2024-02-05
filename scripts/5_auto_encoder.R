##############################################
# Auto encoder
##############################################



## --------------------------------------------------------------------------------------------------------------------------------------------------
setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) 
load('../data/mnist.RData')


## --------------------------------------------------------------------------------------------------------------------------------------------------
input_train <- mnist$train$x
input_test <- mnist$test$x


## --------------------------------------------------------------------------------------------------------------------------------------------------
input_train <- tensorflow::array_reshape(input_train,
                                         c(nrow(input_train), 28*28)) / 255

input_test <- tensorflow::array_reshape(input_test,
                                        c(nrow(input_test), 28*28)) / 255


## --------------------------------------------------------------------------------------------------------------------------------------------------
library(tidyverse)
plot_image <- function(data, legend = TRUE) {
  dimension <- sqrt(length(data))
  df <- data.frame(col = rep(1:dimension, dimension), row = rep(dimension:1, each = dimension), value = data);
  figure <- ggplot(df) +
    theme_void() +
    xlab('') + ylab('') +
    geom_raster(aes(x = col, y = row, fill = value))
  
  if(all(data >= 0)) {
    figure <- figure + scale_fill_gradient(high = 'white', low = 'black')
  } else {
    figure <- figure + scale_fill_gradient2(low = 'red', mid = 'white', high = 'green', midpoint = 0)
  }
  
  if(!legend) {
    figure <- figure + theme(legend.position = 'none')
  }
  
  return(figure)
}



## Your Turn!
## --------------------------------------------------------------------------------------------------------------------------------------------------

library(keras)
encoder <- keras_model_sequential() %>%
  layer_dense(units = 128, 
              activation = 'sigmoid', 
              input_shape = c(784)) %>%
  layer_dense(units = 32,
              activation = 'sigmoid')

model <- encoder %>%
  layer_batch_normalization() %>%
  layer_dense(units = 128,
              activation = 'sigmoid') %>%
  layer_dense(units = 784,
              activation = 'sigmoid') %>%
  compile(loss = 'binary_crossentropy',
          optimize = optimizer_rmsprop(),
          metrics = c('mse'))

model %>% fit(input_train, 
              input_train, 
              epochs = 10, 
              batch_size = 256, 
              shuffle = TRUE, 
              validation_split = 0.2)


## --------------------------------------------------------------------------------------------------------------------------------------------------
index <- 11
result <- predict(model, input_test[index, , drop = FALSE])
plot_image(input_test[index, ]) # the original image
plot_image(result[1, ]) # the reconstruction of the model


## --------------------------------------------------------------------------------------------------------------------------------------------------
random <- matrix(runif(28^2), nrow = 1)

gridExtra::grid.arrange(
  plot_image(random[1, ]) + theme(legend.position = 'none'),
  plot_image(predict(model, random)[1, ]) + theme(legend.position = 'none'),
  nrow = 1)

