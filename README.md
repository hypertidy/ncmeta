
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
