# NetCDF extended dimension attributes

Generate a table of all extended dimension attributes. For now that
means interpretation of any "time" dimension.

## Usage

``` r
nc_extended(x, ...)

# S3 method for class 'character'
nc_extended(x, ...)

# S3 method for class 'NetCDF'
nc_extended(x, ...)

# S3 method for class 'ncdf4'
nc_extended(x, ...)
```

## Arguments

- x:

  filename or handle

- ...:

  ignored currently

## Value

data frame of extended dimension attribute information

## Examples

``` r
f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
nc_extended(f)
#> # A tibble: 4 × 3
#>   dimension name          time     
#>       <int> <chr>         <list>   
#> 1         0 lat           <lgl [1]>
#> 2         1 lon           <lgl [1]>
#> 3         2 rgb           <lgl [1]>
#> 4         3 eightbitcolor <lgl [1]>
```
