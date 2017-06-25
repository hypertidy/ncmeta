u <- "https://oceandata.sci.gsfc.nasa.gov/cgi/getfile/S2008001.L3b_DAY_CHL.nc"
download.file(u, file.path("inst/extdata", basename(u)), mode = "wb")
system.file("extdata", "S2008001.L3b_DAY_CHL.nc", package = "ncmeta")
