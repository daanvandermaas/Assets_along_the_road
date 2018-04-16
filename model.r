model<-keras_model_sequential()



model %>%  
  layer_conv_2d(filter=32, kernel_size=c(4,4),padding="same",    input_shape=c(w,h,3) , activation = 'relu') %>%  
  layer_conv_2d(filter=64 ,kernel_size=c(4,4), padding = 'same', activation = 'relu')  %>%  
  layer_max_pooling_2d(pool_size=c(2,2)) %>%  
  layer_conv_2d(filter=64 ,kernel_size=c(3,3), padding = 'same', activation = 'relu')  %>%  
  layer_conv_2d(filter=64 ,kernel_size=c(3,3), padding = 'same', activation = 'relu')  %>%  
  layer_max_pooling_2d(pool_size=c(2,2)) %>%  
  layer_conv_2d(filter=64 ,kernel_size=c(3,3), padding = 'same', activation = 'relu')  %>%  
  layer_conv_2d(filter=64 , kernel_size=c(3,3),padding="same", activation = 'relu') %>%
  layer_max_pooling_2d(pool_size=c(2,2)) %>%  
  layer_conv_2d(filter=64 ,kernel_size=c(3,3), padding = 'same', activation = 'relu')  %>%  
  layer_conv_2d(  filters = 64 , kernel_size=c(3,3) , padding="same", activation = 'relu') %>%
  layer_flatten() %>%
  layer_dropout(0.5) %>%
  layer_dense(units = 500L , activation = 'relu') %>%
  layer_dense(units = 2L , activation = 'softmax')

