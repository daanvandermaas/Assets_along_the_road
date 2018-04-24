input_img = layer_input(shape = c(w, h, 3)) 


l0 = layer_conv_2d( filter=64, kernel_size=c(3,3),padding="same",     activation = 'relu' )(input_img) 

l1 =   layer_conv_2d( filter=64, kernel_size=c(3,3),padding="same",     activation = 'relu' )(l0) 

l2 = layer_flatten(l1)

out =   layer_dense(units = 2L, activation = 'softmax')(l2)

model = keras_model(inputs = input_img, outputs = out)
