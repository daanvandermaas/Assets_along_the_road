library(jsonlite)
library(EBImage)
library(keras)
library(pbapply)

#find all panoramas
max = 21246
pages =  sample(c(1:max), 100)


res = unlist(pblapply(pages, function(i){
  
  url = paste0('https://api.data.amsterdam.nl/panorama/recente_opnames/2017/?page=', i)  
  res = fromJSON(url)
  res$results$image_sets$equirectangular$small
}))

saveRDS(res, 'db/panoramas.rds')

#saveRDS(res, 'db/panoramas_quite_good.rds')
#res = readRDS('db/panoramas_quite_good.rds')

#Download image in forloop
res = readRDS('db/panoramas.rds')
model = load_model_hdf5('db/model_all')
w = 512
 h = 64
 
 w2 = 128
 h2 = 64

 #1683
for( i in 2143:length(res) ){

  
  possible <-  class(try(readImage(res[i]))) == 'try-error'
  
  
    if(possible ){ print('caught an error')}else{
  
      print(i)
  
  im_full = readImage(res[i])
  
  
  
  im = im_full[,500:800,]
  im = resize( im, w, h)
  im_parts = list()
  im_parts[[1]] = im[1:128,,]
  im_parts[[2]] = im[129:256,,]
  im_parts[[3]]= im[257:384,,]
  im_parts[[4]] = im[385:512,,]
  
  a = array(0, dim = c(4,w2,h2,3))
  a[1,,,] =  im_parts[[1]]
  a[2,,,] =  im_parts[[2]]
  a[3,,,] =  im_parts[[3]]
  a[4,,,] =  im_parts[[4]]
  
  klassen = model$predict(a)
  for(j in 1:nrow(klassen)){
  if(klassen[j,1] >0.9){
    writeImage(im_parts[[j]], file.path('db', 'images_from_api', 'middenberm', paste0('7_', i, '_', j, '.jpg')) )
  }else{
    writeImage(im_parts[[j]], file.path('db', 'images_from_api', 'niks', paste0('7_', i, '_', j, '.jpg')) )
  }
  }
    }
  
  }




