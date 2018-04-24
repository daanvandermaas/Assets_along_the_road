library(EBImage)

path = 'db/images_new/niks'
path_out ='db/images_pieces/niks'
w = 512
h = 64


files = list.files(path)
files_full = file.path(path, files)
files = unlist(lapply(files, function(file){
  strsplit( as.character(file), '[.]')[[1]][1]
}))

for(i in 1:length(files)){
  im = readImage( as.character(files_full[i]))
  
  im = im[,500:800,]
  
  im = resize( im, w, h)
  
  im_1 = im[1:128,,]
  im_2 = im[129:256,,]
  im_3 = im[257:384,,]
  im_4 = im[385:512,,]
  
  writeImage(im_1, file.path(path_out, paste0(files[i], '_1.jpg')) )
  writeImage(im_2, file.path(path_out, paste0(files[i], '_2.jpg')) )
  writeImage(im_3, file.path(path_out, paste0(files[i], '_3.jpg')) )
  writeImage(im_4, file.path(path_out, paste0(files[i], '_4.jpg')) )
}