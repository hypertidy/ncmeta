
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
#>     expr        min        lq      mean    median        uq      max neval
#>  nc_open   9.198085  10.13715  90.98336  10.43675  11.24926 505.7518    10
#>   ncdump  94.306848  96.49014 121.99407  99.54746 101.25061 258.5219    10
#>   ncmeta 167.109496 169.73257 195.98684 172.40020 180.82915 382.6214    10
#>  cld
#>    a
#>    a
#>    a
               #RNetCDF = RNetCDF::print.nc(RNetCDF::open.nc(f)))
#sink(NULL)


system.time(ncdf4::nc_open(f))
#>    user  system elapsed 
#>   0.008   0.000   0.011
system.time(nc_meta(f))
#>    user  system elapsed 
#>   0.176   0.040   0.214
system.time({
 nc_dims(f)

  nc_vars(f)

  nc_atts(f)
})
#>    user  system elapsed 
#>   0.176   0.000   0.177

system.time(ncdump::NetCDF(f))
#>    user  system elapsed 
#>   0.100   0.000   0.098
```
