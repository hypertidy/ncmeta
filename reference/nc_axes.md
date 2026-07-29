# NetCDF axes

An `axis` is an instance of a dimension.

## Usage

``` r
nc_axes(x, variables = NULL, ...)

# S3 method for class 'character'
nc_axes(x, variables = NULL, ...)

# S3 method for class 'NetCDF'
nc_axes(x, variables = NULL, ...)
```

## Arguments

- x:

  NetCDF source

- variables:

  names of vars to query

- ...:

  ignored

## Value

data frame of axis instances, with columns 'axis', 'variable',
'dimension'

## Details

Each data source has a set of dimensions available for use by variables.
Each axis is a 1-dimensional instance.

## Examples

``` r
f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
nc_axes(f)
#> # A tibble: 6 × 3
#>    axis variable dimension
#>   <int> <chr>        <int>
#> 1     1 chlor_a          1
#> 2     2 chlor_a          0
#> 3     3 lat              0
#> 4     4 lon              1
#> 5     5 palette          3
#> 6     6 palette          2
```
