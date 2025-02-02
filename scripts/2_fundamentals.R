##############################################
# Neural network fundamentals
##############################################



## --------------------------------------------------------------------------------------------------------------------------------------------------
#mnist <- keras::dataset_mnist()
setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) 
load('../data/mnist.RData')


## --------------------------------------------------------------------------------------------------------------------------------------------------
input <- mnist$train$x
output <- mnist$train$y
test_input <- mnist$test$x
test_output <- mnist$test$y


## --------------------------------------------------------------------------------------------------------------------------------------------------
class(input)
dim(input)


## --------------------------------------------------------------------------------------------------------------------------------------------------
input[1, , ]

## --------------------------------------------------------------------------------------------------------------------------------------------------
input <- tensorflow::array_reshape(input,
                                   c(nrow(input), 28*28)) / 255
test_input <- tensorflow::array_reshape(test_input,
                                        c(nrow(test_input), 28*28)) / 255


## --------------------------------------------------------------------------------------------------------------------------------------------------
output <- keras::to_categorical(output, 10)
test_output <- keras::to_categorical(test_output, 10)


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

plot_image(input[17, ], legend = FALSE)


## --------------------------------------------------------------------------------------------------------------------------------------------------
library(keras)
model <- keras_model_sequential() %>%
  layer_dense(units = 512, 
              activation = 'sigmoid', 
              input_shape = c(784)) %>%
  layer_dense(units = 10, 
              activation = 'softmax')


## --------------------------------------------------------------------------------------------------------------------------------------------------
summary(model)


## --------------------------------------------------------------------------------------------------------------------------------------------------
model <- model %>% compile(loss = 'categorical_crossentropy',
                           optimize = optimizer_rmsprop(),
                           metrics = c('accuracy'))


## --------------------------------------------------------------------------------------------------------------------------------------------------
model %>% fit(input, 
              output, 
              batch_size = 128,
              epochs = 10,
              validation_split = 0.2)

## Your Turn!
## --------------------------------------------------------------------------------------------------------------------------------------------------
#Total number of parameters (784+1)*512+(512+1)*10
your_model <- keras_model_sequential() %>%
  layer_dense(units = 512,
              activation = 'relu',
              input_shape = c(784)) %>%
  layer_dense(units = 10,
              activation = 'softmax')

summary(your_model)

your_model <- your_model %>% compile(loss = 'categorical_crossentropy',
                                     optimize = optimizer_rmsprop(),
                                     metrics = c('accuracy'))

your_model %>% fit(input,
                   output,
                   batch_size = 512, 
                   epochs = 10, 
                   validation_split = 0.2)

## --------------------------------------------------------------------------------------------------------------------------------------------------
model %>% evaluate(test_input, test_output, verbose = 0)


## --------------------------------------------------------------------------------------------------------------------------------------------------
prediction <- model %>% predict(test_input)
round(prediction[1, ], 3)


## --------------------------------------------------------------------------------------------------------------------------------------------------
category <- apply(prediction, 1, which.max) - 1
actual_category <- apply(test_output, 1, which.max) - 1
head(which(actual_category != category))


## --------------------------------------------------------------------------------------------------------------------------------------------------
index <- 9
plot_image(test_input[index, ]) +
  ggtitle(paste('actual: ', actual_category[index], 
                ' predicted: ', category[index], sep='')) +
  theme(legend.position = 'none', 
        plot.title = element_text(hjust = 0.5))


## --------------------------------------------------------------------------------------------------------------------------------------------------
prob_correct <- prediction[cbind(1:nrow(prediction), actual_category + 1)]
which(rank(prob_correct) <= 5)


## --------------------------------------------------------------------------------------------------------------------------------------------------
index <- which(rank(prob_correct) <= 5)[1]
plot_image(test_input[index, ]) +
  ggtitle(paste('actual: ', actual_category[index], 
                ' predicted: ', category[index], sep='')) +
  theme(legend.position = 'none', 
        plot.title = element_text(hjust = 0.5))


## Your Turn!
## --------------------------------------------------------------------------------------------------------------------------------------------------
your_model %>% evaluate(test_input, test_output, verbose = 0)

prediction_model <- your_model %>% predict(test_input)
round(prediction_model[1, ], 3)

category_model <- apply(prediction_model, 1, which.max) - 1
head(which(actual_category != category_model))

index <- 248
plot_image(test_input[index, ]) +
  ggtitle(paste('actual: ', actual_category[index], 
                ' predicted: ', category_model[index], sep='')) +
  theme(legend.position = 'none', 
        plot.title = element_text(hjust = 0.5))

prob_correct_model <- prediction_model[cbind(1:nrow(prediction_model), actual_category + 1)]
which(rank(prob_correct_model) <= 5)

index <- which(rank(prob_correct_model) <= 5)[1]
plot_image(test_input[index, ]) +
  ggtitle(paste('actual: ', actual_category[index], 
                ' predicted: ', category_model[index], sep='')) +
  theme(legend.position = 'none', 
        plot.title = element_text(hjust = 0.5))




## --------------------------------------------------------------------------------------------------------------------------------------------------
set.seed(543)
random <- matrix(runif(28^2), nrow = 1)
plot_image(random[1, ], legend = FALSE)


## --------------------------------------------------------------------------------------------------------------------------------------------------
round(predict(model, random), 3)


## --------------------------------------------------------------------------------------------------------------------------------------------------
node <- 9
layer <- 1
weights <- model$get_weights()[[2 * (layer - 1) + 1]][, node]

## --------------------------------------------------------------------------------------------------------------------------------------------------
plot_image(weights)
