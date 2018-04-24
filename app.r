library(jsonlite)
library(EBImage)
library(keras)
library(pbapply)

#find all panoramas
max = 21246
pages = sample(c(1:max), 300)


res = unlist(pblapply(pages, function(i){
  
  url = paste0('https://api.data.amsterdam.nl/panorama/recente_opnames/2017/?page=', i)  
  res = fromJSON(url)
  res$results$image_sets$equirectangular$small
}))

saveRDS(res, 'db/panoramas.rds')




#Download image in forloop
res = readRDS('db/panoramas.rds')
w = 512
h = 64
model = load_model_hdf5('db/model_96')

klassen = c()

pblapply( c(1:length(res)), function(i){
  im_full = readImage(res[i])
  im = im_full[,500:800,]
  im = resize( im, w, h)
  im_1 = im[1:128,,]
  im_2 = im[129:256,,]
  im_3 = im[257:384,,]
  im_4 = im[385:512,,]
  
  a = array(0, dim = c(4,w,h,3))
  a[1,,,] =  im_1
  a[2,,,] =  im_2
  a[3,,,] =  im_3
  a[4,,,] =  im_4
  
  klasse = model$predict_classes(a)
  if(klasse == 1){
    #writeImage(im_full, file.path('db', 'images_from_api', 'niks', paste0('2_', i, '.jpg')) )
  }else{
    writeImage(im_full, file.path('db', 'images_from_api', 'middenberm', paste0('2_', i, '.jpg')) )
  }
  })




