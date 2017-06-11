
[![Travis-CI Build Status](https://travis-ci.org/hypertidy/ncmeta.svg?branch=master)](https://travis-ci.org/hypertidy/ncmeta) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/hypertidy/ncmeta?branch=master&svg=true)](https://ci.appveyor.com/project/hypertidy/ncmeta) [![Coverage Status](https://img.shields.io/codecov/c/github/hypertidy/ncmeta/master.svg)](https://codecov.io/github/hypertidy/ncmeta?branch=master)

<!-- README.md is generated from README.Rmd. Please edit that file -->
ncmeta
======

Straightforward NetCDF metadata.

To stand in stead of RNetCDF or ncdf4 for metadata extraction when speed and simplicity is required.

Installation
------------

You can install ncmeta from github with:

``` r
# install.packages("devtools")
devtools::install_github("hypertidy/ncmeta")
```

Example
-------

This is a basic example which shows you how to solve a common problem:

``` r
nc_inq(filename) # one-row summary of file

nc_dim(filename, 0)  ## first dimesion
nc_dims(filename)  ## all dimensions
```

Compare timings.

``` r
library(ncmeta)
f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
u <- "https://upwell.pfeg.noaa.gov/erddap/tabledap/FRDCPSTrawlLHHaulCatch"

library(microbenchmark)
#tf <- "/dev/null"
#sink(tf)
microbenchmark(nc_open = ncdf4::nc_open(f), 
               ncdump = ncdump::NetCDF(f), 
               ncmeta = nc_meta(f) , times = 10)
#> Unit: milliseconds
#>     expr        min         lq      mean    median        uq      max
#>  nc_open   9.432109   9.995843  92.33632  10.57890  12.55095 521.8955
#>   ncdump 100.277510 104.792988 134.62141 109.81531 112.07907 309.3730
#>   ncmeta  79.238553  82.633048 111.10907  83.97404  88.53951 336.8737
#>  neval cld
#>     10   a
#>     10   a
#>     10   a
               #RNetCDF = RNetCDF::print.nc(RNetCDF::open.nc(f)))
#sink(NULL)


system.time(ncdf4::nc_open(f))
#>    user  system elapsed 
#>   0.012   0.000   0.012
system.time(nc_meta(f))
#>    user  system elapsed 
#>   0.076   0.000   0.077
system.time({
 nc_dims(f)

  nc_vars(f)

  nc_atts(f)
})
#>    user  system elapsed 
#>   0.096   0.000   0.095

system.time(ncdump::NetCDF(f))
#>    user  system elapsed 
#>   0.092   0.000   0.092
```
