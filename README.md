
[![Travis-CI Build Status](https://travis-ci.org/hypertidy/ncmeta.svg?branch=master)](https://travis-ci.org/hypertidy/ncmeta) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/hypertidy/ncmeta?branch=master&svg=true)](https://ci.appveyor.com/project/hypertidy/ncmeta) [![Coverage Status](https://img.shields.io/codecov/c/github/hypertidy/ncmeta/master.svg)](https://codecov.io/github/hypertidy/ncmeta?branch=master)

<!-- README.md is generated from README.Rmd. Please edit that file -->
ncmeta
======

Straightforward NetCDF metadata for use in building interfaces to this format.

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
junk <- capture.output(a <- microbenchmark(nc_open = ncdf4::nc_open(f), 
               ncdump = ncdump::NetCDF(f), 
               ncmeta = nc_meta(f) ,
               RNetCDF = RNetCDF::print.nc(RNetCDF::open.nc(f)), 
                times = 10)
)
print(a)
#> Unit: milliseconds
#>     expr      min       lq      mean    median        uq       max neval
#>  nc_open 14.15938 14.23332 112.95724  14.98906  21.33014 656.46713    10
#>   ncdump 93.73832 95.89619 134.31769 101.12352 107.68589 370.77173    10
#>   ncmeta 59.67635 61.19443  62.97108  61.91249  62.57958  70.01173    10
#>  RNetCDF 32.97361 33.77285  52.62526  35.87184  40.15188 135.59934    10
```
