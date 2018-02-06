
[![Travis-CI Build Status](https://travis-ci.org/hypertidy/ncmeta.svg?branch=master)](https://travis-ci.org/hypertidy/ncmeta) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/hypertidy/ncmeta?branch=master&svg=true)](https://ci.appveyor.com/project/hypertidy/ncmeta) [![CRAN status](http://www.r-pkg.org/badges/version/ncmeta)](https://cran.r-project.org/package=ncmeta) [![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/ncmeta)](http://cran.r-project.org/web/packages/ncmeta/index.html) [![Coverage Status](https://img.shields.io/codecov/c/github/hypertidy/ncmeta/master.svg)](https://codecov.io/github/hypertidy/ncmeta?branch=master) ![cranlogs](http://cranlogs.r-pkg.org./badges/ncmeta)

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
#>  nc_open 14.44572 14.66816  15.29592 15.21485 15.72261   16.97770    10
#>   ncdump 52.70860 53.37746 199.38398 54.13056 59.49784 1410.50251    10
#>   ncmeta 50.86547 51.30837  54.35841 53.47266 55.57209   65.05769    10
#>  RNetCDF 35.80927 36.25907  55.06898 40.37256 42.71180  125.24768    10
```
