library(jsonlite)
library(EBImage)
library(keras)
library(pbapply)
library(data.table)

dir = 'db/images_from_api/middenberm'
dir_out = 'db/threshold_check'
model = load_model_hdf5('db/model')
threshold = 0.998


files = list.files(dir)


for(file in files){
im =   readImage(file.path(dir,file))
ar = array(im, dim = c(1, dim(im)))
pred =   model$predict(x = ar)

if(pred[[1]] > threshold){
  writeImage(im, file.path(dir_out, 'middenberm', file))
}else{ 
  writeImage(im, file.path(dir_out, 'niks', file))
}
}
