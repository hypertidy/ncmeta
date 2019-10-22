library(RNetCDF)
library(dplyr)
files <- raadfiles:::get_raw_raad_filenames() %>% 
  dplyr::filter(grepl("\\.nc$", file) | grepl("\\.netcdf$", file) | grepl("\\.nc4$", file) | grepl("\\.h5", file)) %>% 
  dplyr::transmute(fullname = file.path(root, file))
# files %>% mutate(ex = substr(fullname, nchar(fullname) - 2, nchar(fullname))) %>% distinct(ex)
# # A tibble: 4 x 1
# ex
# <chr>
#   1   .nc
# 2   cdf
# 3   .h5
# 4   nc4

read_and_churn <- function(x) {
  #nc <- RNetCDF::open.nc(x)
  #on.exit(RNetCDF::close.nc(nc))
  #RNetCDF::print.nc(nc)
  ncmeta::nc_meta(x)
  
}
i <- 0
con <- file("writedLines", open = "wt")
while(TRUE) {
  i <- i + 1
  fname <- files %>% sample_n(1) %>% pull(fullname)
  catch <- try(read_and_churn(fname))
  if (inherits(catch, "try-error")) {
    writeLines(c(i, fname), con)
  }
}
close(con)