

model<-keras_model_sequential()

#configuring the Model

model %>%  
  layer_conv_2d(filter=4, kernel_size=c(3,3),padding="same",    input_shape=c(w,h,3) , activation = 'relu') %>%  
  layer_conv_2d(filter=4, kernel_size=c(3,3),padding="same",    input_shape=c(w,h,3) , activation = 'relu') %>%  
  layer_max_pooling_2d(pool_size=c(2,2)) %>%  
  layer_conv_2d(filter=4, kernel_size=c(3,3),padding="same",    input_shape=c(w,h,3) , activation = 'relu') %>%  
  layer_conv_2d(filter=4, kernel_size=c(3,3),padding="same",    input_shape=c(w,h,3) , activation = 'relu') %>%  
  layer_max_pooling_2d(pool_size=c(2,2)) %>%  
  layer_conv_2d(filter=8, kernel_size=c(3,3),padding="same",    input_shape=c(w,h,3) , activation = 'relu') %>%  
  layer_max_pooling_2d(pool_size=c(2,2)) %>%  
  layer_flatten() %>%  
  layer_dense(32, activation = 'relu') %>%  
  layer_dropout(0.5) %>%  
  layer_dense(2) %>%  
  layer_activation("softmax") 
