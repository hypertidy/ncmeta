u1 <- "https://www.unidata.ucar.edu/software/netcdf/examples/test_hgroups.nc"
curl::curl_download(u1, file.path("inst/extdata/unidata", basename(u1)), mode = "wb")
