vgg = keras::application_vgg16(weights = 'imagenet', include_top = FALSE, input_shape=c(w, h, 3))


for(i in 1:6){
  vgg$layers[[i]]$trainable = FALSE
}

vgg_out = vgg$output


flat = layer_flatten()(vgg_out)
fc1 = layer_dense(units = 16L, activation = 'relu')(flat)
fc2 = layer_dense(units = 8L, activation = 'relu')(fc1)
output = layer_dense(units= 2L, activation = 'softmax')(fc2)
  
  
model = keras_model(inputs = vgg$input, outputs = output)



