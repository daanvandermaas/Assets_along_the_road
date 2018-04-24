library(EBImage)
library(keras)
library(data.table)

source('read_files.r')

train = readRDS('db/train_new.rds')
test = readRDS('db/test_new.rds')
train$file = as.character( file.path('db', 'images_pieces', train$class, train$file))
test$file = as.character( file.path('db', 'images_pieces', test$class, test$file))


w = 128
h = 64


input_img = layer_input(shape = c(w, h, 3)) 


l = layer_conv_2d( filter=32, kernel_size=c(3,3),padding="same",     activation = 'relu' )(input_img) 
l = layer_conv_2d( filter=32, kernel_size=c(3,3),padding="same",     activation = 'relu' )(l) 
l = layer_max_pooling_2d(pool_size = c(2,2))(l)
l = layer_conv_2d( filter=32, kernel_size=c(3,3),padding="same",     activation = 'relu' )(l) 
l = layer_conv_2d( filter=32, kernel_size=c(3,3),padding="same",     activation = 'relu' )(l) 
l = layer_max_pooling_2d(pool_size = c(2,2))(l)
l = layer_conv_2d( filter=32, kernel_size=c(3,3),padding="same",     activation = 'relu' )(l) 
l = layer_conv_2d( filter=32, kernel_size=c(3,3),padding="same",     activation = 'relu' )(l) 
l = layer_max_pooling_2d(pool_size = c(2,2))(l)
# l = layer_conv_2d( filter=32, kernel_size=c(3,3),padding="same",     activation = 'relu' )(l) 
# l = layer_conv_2d( filter=64, kernel_size=c(3,3),padding="same",     activation = 'relu' )(l) 
# l = layer_max_pooling_2d(pool_size = c(2,2))(l)
l = layer_flatten(l)
l = layer_dense(units = 512, activation = 'relu')(l)
out = layer_dense(units = 2, activation = 'softmax')(l)


model = keras_model(inputs = input_img, outputs = out)

opt<-optimizer_adam( lr= 0.0001 , decay = 0 )

compile(model, loss="categorical_crossentropy", optimizer=opt, metrics = "accuracy")

#model = keras::load_model_hdf5('db/model')







#Train the network
for (i in 1:2000000) {
  
  
  files = read_files(data = train, w, h, n = 16)
  print(i)
  model$fit( x= files[[1]], y= files[[2]], batch_size = dim(files)[1], epochs = 1L  )
  
  if(i%%200 == 0 ){
    
    files = read_files(data = test, w, h, n = 100)
    
    ev =   model$evaluate(x = files[[1]], y = files[[2]] )
    
print(paste('test evaluation:',     ev ))
if(ev[[2]] > 0.96){
    model$save( 'db/model' )
}
  }
  
  
}


