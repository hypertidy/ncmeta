
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

This is a basic example which shows you how to find out the basic information on structures in a NetCDF file:

``` r
library(ncmeta)
filename <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
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
#>     expr       min        lq      mean    median        uq        max
#>  nc_open  13.56007  14.02879  15.02549  15.12102  15.55856   16.83026
#>   ncdump 105.62757 113.08354 239.31455 114.77067 119.17370 1295.12378
#>   ncmeta  65.10995  66.00702  88.36383  69.92109  77.57083  197.78369
#>  RNetCDF  36.96346  39.16939  47.54083  41.58221  44.08432  103.96997
#>  neval
#>     10
#>     10
#>     10
#>     10
```
