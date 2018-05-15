library(leaflet)
library(htmlwidgets)

weesper = read.csv('db/locations.csv')
weesper = table_locations


m = leaflet()
m = addTiles(m)
m = addMarkers(m, lat = weesper$y, lng = weesper$x )
m = addProviderTiles(m, providers$OpenStreetMap)
saveWidget(m, file="m.html")
m
