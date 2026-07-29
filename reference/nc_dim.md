# NetCDF dimension

Obtain information about a single dimension by index.

## Usage

``` r
nc_dim(x, i, ...)

# S3 method for class 'character'
nc_dim(x, i, ...)

# S3 method for class 'NetCDF'
nc_dim(x, i, ...)

# S3 method for class 'ncdf4'
nc_dim(x, i, ...)
```

## Arguments

- x:

  filename or handle

- i:

  index of dimension (zero based)

- ...:

  ignored

## Value

data frame of dimension information, with columns 'id', 'name',
'length', 'unlim'

## See also

`nc_dims` to obtain information about all dimensions, `nc_inq` for an
overview of the file

## Examples

``` r
f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
nc_dim(f, 0)
#> # A tibble: 1 × 4
#>      id name  length unlim
#>   <int> <chr>  <dbl> <lgl>
#> 1     0 lat     2160 FALSE
```
