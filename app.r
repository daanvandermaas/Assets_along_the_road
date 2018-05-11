library(jsonlite)
library(EBImage)
library(keras)
library(pbapply)
library(data.table)

#find all panoramas
max = 10000
pages =  sample(c(1:max), 1000)


res = pblapply(pages, function(i){
  
  url = paste0('https://api.data.amsterdam.nl/panorama/recente_opnames/2017/?page=', i)  
  res = fromJSON(url)
  
  data.frame('pano_id' = res$results$pano_id, 'geometrie' = res$results$geometrie, 'url' =  res$results$image_sets$equirectangular$small )

})

res = rbindlist(res)

saveRDS(res, 'db/panoramas.rds')

#saveRDS(res, 'db/panoramas_quite_good.rds')
#res = readRDS('db/panoramas_quite_good.rds')

#Download image in forloop
res = readRDS('db/panoramas.rds')
model = keras::load_model_hdf5('db/model_1')
table_locations = list()
w = 512
 h = 64
 
 w2 = 128
 h2 = 64

 
for(i in 1:nrow(res)){

  
  im_full = try( readImage(  as.character(res$url[i]) ))
  
 
  
    if(class(im_full) == 'try-error' ){ print('caught an error')}else{
  
      print(i)
  
  
  
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
  if(klassen[j,1] >0.98){
    writeImage(im_parts[[j]], file.path('db', 'images_from_api', 'middenberm', paste0('8_', res$pano_id[i] , '.jpg')) )
 table_locations = c( table_locations, data.frame('pano_id' = res$pano_id[i], 'geometry' = paste(res$geometrie.coordinates[i][[1]][1], res$geometrie.coordinates[i][[1]][2]  ),  'direction' = j)) 
    }else{
    writeImage(im_parts[[j]], file.path('db', 'images_from_api', 'niks', paste0('8_', res$pano_id[i] ,'.jpg')) )
  }
  }
    }
  
  }

 table_locations = rbindlist(table_locations)
 saveRDS(table_locations, 'db/table_locations.rds')
