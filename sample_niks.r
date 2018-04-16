library(jpeg)

files = list.files('/media/daniel/6DA3F120567E843D/FotosAmsterdam', full.names = TRUE)

files = sample(files, 3000)

for(i  in 1:length(files) ){
  file = files[i]
file =   readJPEG(file)
writeJPEG(file, paste0('db/niks/', i, '.jpg'))
}