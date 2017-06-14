
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
#>     expr       min       lq      mean   median       uq       max neval
#>  nc_open  9.377792 10.28603  10.54871 10.58718 10.73256   11.7029    10
#>   ncdump 78.430394 80.77171 220.25889 82.48041 94.45352 1384.1578    10
#>   ncmeta 69.983725 70.21157  84.56027 71.86467 78.69532  175.5543    10
#>  cld
#>    a
#>    a
#>    a
               #RNetCDF = RNetCDF::print.nc(RNetCDF::open.nc(f)))
#sink(NULL)


system.time(ncdf4::nc_open(f))
#>    user  system elapsed 
#>   0.012   0.000   0.011
system.time(nc_meta(f))
#>    user  system elapsed 
#>   0.068   0.000   0.068
system.time({
 nc_dims(f)

  nc_vars(f)

  nc_atts(f)
})
#>    user  system elapsed 
#>   0.076   0.000   0.077

system.time(ncdump::NetCDF(f))
#>    user  system elapsed 
#>   0.088   0.000   0.089
```
