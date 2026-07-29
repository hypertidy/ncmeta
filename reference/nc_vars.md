# NetCDF variables

Generate a table of all variables.

## Usage

``` r
nc_vars(x, ...)

# S3 method for class 'character'
nc_vars(x, ...)

# S3 method for class 'NetCDF'
nc_vars(x, ...)
```

## Arguments

- x:

  filename or handle

- ...:

  ignored currently

## Value

data frame of variable information

## Examples

``` r
f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
nc_vars(f)
#> # A tibble: 4 × 5
#>      id name    type     ndims natts
#>   <int> <chr>   <chr>    <int> <int>
#> 1     0 chlor_a NC_FLOAT     2    12
#> 2     1 lat     NC_FLOAT     1     5
#> 3     2 lon     NC_FLOAT     1     5
#> 4     3 palette NC_UBYTE     2     0
```
