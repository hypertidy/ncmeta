library(tidync)

## I found an old stale oscar.nc in my legacy public_html/R/ directory
## so I found this OpenDAP source to revisit

## we have Copernicus these days but Oscar was an early 
u <- "https://podaac-opendap.jpl.nasa.gov:443/opendap/allData/oscar/preview/L4/oscar_third_deg/oscar_vel1992.nc.gz"
(tnc <- tidync(u))

tnc %>% hyper_filter()
library(dplyr)
d <- tnc %>% hyper_filter(longitude = between(longitude, 120, 220),
                     latitude = between(latitude, -60, -30), 
                     time = index < 7) %>% 
  hyper_tibble()

library(ggplot2)
ggplot(d, aes(x  = longitude, y = latitude, fill = sqrt(u*u + v * v))) + 
  geom_raster() + scale_fill_gradient2() + facet_wrap(~time)



ggplot(d %>% dplyr::filter(longitude %in% seq(120, 220, by = 10)), 
       aes(y = time, x = latitude, fill = sqrt(u* u + v * v))) + 
  geom_raster() + scale_fill_gradient2() + facet_wrap(~longitude)

## old style
library(RNetCDF)
print.nc(open.nc(u))
