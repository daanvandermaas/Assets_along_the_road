library(EBImage)
library(pbapply)

path = 'db/images/gehendicapt_P'
path_out ='db/images_pieces/gehandicapte_P'
w = 512
h = 64


files = list.files(path)
files_full = file.path(path, files)
files = unlist(lapply(files, function(file){
  strsplit( as.character(file), '[.]')[[1]][1]
}))

pblapply( c(1:length(files)), function(i){
  im = readImage( as.character(files_full[i]))
  
  im = im[,300:800,] #voor middenberm vanaf 500 voor andere vanaf 300. middenberm en niet_inrijden w = 512 h = 64 4 pieces, gehandicapte full resolution w = 256, 7 pieces
  
 # im = resize( im, w, h)
  
  im_1 = im[1:256,,]
  im_2 = im[257:512,,]
  im_3 = im[513:768,,]
  im_4 = im[769:1024,,]
  im_5 = im[1025:1280,,]
  im_6 = im[1281:1536,,]
  im_7 = im[1537:1792,,]
  
  writeImage(im_1, file.path(path_out, paste0(files[i], '_1.jpg')) )
  writeImage(im_2, file.path(path_out, paste0(files[i], '_2.jpg')) )
  writeImage(im_3, file.path(path_out, paste0(files[i], '_3.jpg')) )
  writeImage(im_4, file.path(path_out, paste0(files[i], '_4.jpg')) )
  writeImage(im_5, file.path(path_out, paste0(files[i], '_5.jpg')) )
  writeImage(im_6, file.path(path_out, paste0(files[i], '_6.jpg')) )
  writeImage(im_7, file.path(path_out, paste0(files[i], '_7.jpg')) )
})