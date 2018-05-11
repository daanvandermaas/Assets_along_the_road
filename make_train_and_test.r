files = list.files('db/images_pieces', full.names = TRUE, recursive = TRUE, pattern = '.jpg')

class = unlist(lapply(files, function(x){
  strsplit(x,'[/.]')[[1]][3]
}))

files = unlist(lapply(files, function(x){
  strsplit(x,'[/]')[[1]][4]
}))


data = data.frame('file' = files, 'class' = class)

data$label = as.numeric(as.factor(data$class))

samp = sample(c(1:nrow(data)), round(0.95*nrow(data)))
train = data[samp,]
test = data[-samp,]

saveRDS(train, 'db/train_new.rds')
saveRDS(test, 'db/test_new.rds')
