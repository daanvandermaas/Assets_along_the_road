library(jsonlite)
library(EBImage)
library(keras)
library(pbapply)
library(data.table)


panos = read.csv('db/weesper2.csv')
panos$url =  gsub(panos$url, pattern = '8000', replacement = '2000')
  



model = keras::load_model_hdf5('db/model_nietinrijden_1')
table_locations = list()
w = 512
h = 64

w2 = 128
h2 = 64


for(i in 1:nrow(panos)){
  
  
  im_full = try( readImage(  as.character(panos$url[i]) ))
  
  
  
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
      if(klassen[j,1] >0.5){
        print('yep')
        writeImage(im_parts[[j]], file.path('db', 'images_from_api', 'middenberm', paste0( panos$display[i] , '.jpg')) )
        table_locations = append(table_locations, list( data.frame('pano_id' = panos$display[i], 'x' = panos$X[i], 'y'= panos$Y[i],  'direction' = j)))
        
        
      }else{
        writeImage(im_parts[[j]], file.path('db', 'images_from_api', 'niks', paste0( panos$display[i] ,'.jpg')) )
      }
    }
  }
  
}

table_locations = rbindlist(table_locations)

#   
# 
# for(i in 1:nrow(table_locations)){
# 
#   if(table_locations$direction[i]==1){ 
#     angle = 225}else if(table_locations$direction[i] == 2){
#       angle= 335
#     }else if(table_locations$direction[i] == 3){
#       angle = 45
#     }else if(table_locations$direction[i] == 4){
#       angle = 135
#     }
#   
#     
#   table_locations$x[i] = new_coords(phi = table_locations$y[i], theta = table_locations$x[i], angle = angle, max_dist = 10 )[1]
#   table_locations$y[i] = new_coords(phi = table_locations$y[i], theta = table_locations$x[i], angle = angle, max_dist = 10 )[2]
#   
# }



write.csv(table_locations, 'db/locations.csv')
