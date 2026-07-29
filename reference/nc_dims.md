# NetCDF dimension

Get information about the dimensions in a NetCDF source.

## Usage

``` r
nc_dims(x, ...)

# S3 method for class 'character'
nc_dims(x, ...)

# S3 method for class 'NetCDF'
nc_dims(x, ...)

# S3 method for class 'ncdf4'
nc_dims(x, ...)
```

## Arguments

- x:

  file address or handle

- ...:

  ignored

## Value

data frame of dimension information, one row per dimension, with columns
'id', 'name', 'length', 'unlim'

## Examples

``` r
f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
nc_dims(f)
#> # A tibble: 4 × 4
#>      id name          length unlim
#>   <int> <chr>          <dbl> <lgl>
#> 1     0 lat             2160 FALSE
#> 2     1 lon             4320 FALSE
#> 3     2 rgb                3 FALSE
#> 4     3 eightbitcolor    256 FALSE
```
