
[![Build Status](http://badges.herokuapp.com/travis/hypertidy/ncmeta?branch=master&env=BUILD_NAME=trusty_release&label=ubuntu)](https://travis-ci.org/hypertidy/ncmeta) [![Build Status](http://badges.herokuapp.com/travis/hypertidy/ncmeta?branch=master&env=BUILD_NAME=osx_release&label=osx)](https://travis-ci.org/hypertidy/ncmeta) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/hypertidy/ncmeta?branch=master&svg=true)](https://ci.appveyor.com/project/mdsumner/ncmeta) [![CRAN status](http://www.r-pkg.org/badges/version/ncmeta)](https://cran.r-project.org/package=ncmeta) ![cranlogs](http://cranlogs.r-pkg.org./badges/ncmeta) [![Coverage Status](https://img.shields.io/codecov/c/github/hypertidy/ncmeta/master.svg)](https://codecov.io/github/hypertidy/ncmeta?branch=master)

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
#>     expr      min       lq      mean   median       uq        max neval
#>  nc_open 12.23307 12.68172  13.18967 13.13182 13.37033   15.17942    10
#>   ncdump 45.11056 45.41336 164.88877 47.93322 49.72675 1154.20297    10
#>   ncmeta 36.42950 36.70403  39.09354 38.45877 41.60416   43.67622    10
#>  RNetCDF 28.18936 29.05753  39.88902 29.43358 32.54862  127.04060    10
```
