library(EBImage)
library(keras)
library(data.table)

source('read_files.r')

train = readRDS('db/train.rds')
test = readRDS('db/test.rds')
train$file = as.character( file.path('db', 'images', train$class, train$file))
test$file = as.character( file.path('db', 'images', test$class, test$file))


w = 512
h = 64


source('model.r')
opt<-optimizer_adam( lr= 0.0001 , decay = 0 )

compile(model, loss="categorical_crossentropy", optimizer=opt, metrics = "accuracy")









#Train the network
for (i in 1:2000000) {
  
  
  files = read_files(data = train, w, h, n = 3)
  print(i)
  model$fit( x= files[[1]], y= files[[2]], batch_size = dim(files)[1], epochs = 1L  )
  
  if(i%%200 == 0 ){
    
    files = read_files(data = test, w, h, n = 50)
    
print(paste('test evaluation:',     model$evaluate(x = files[[1]], y = files[[2]] )))
    model$save( 'db/model' )
    
  }
  
  
}


