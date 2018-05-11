
t = readRDS('db/table_locations.rds')

data = data.frame('file' = t[[1]], 'coordinates' = t[[2]], 'direction' = t[[3]])

for(i in 3:(length(t)-3) ){
  print(i)
  if(i%%3 == 0){
    data_extra = data.frame('file' = t[[i+1]], 'coordinates' = t[[i+2]], 'direction' = t[[i+3]])
    data = rbind(data, data_extra)
  }
  
}


View(data)

write.csv(data, 'locations.csv')