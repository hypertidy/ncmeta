# NetCDF axes

An `axis` is an instance of a dimension.

## Usage

``` r
nc_axis(x, i)

# S3 method for class 'character'
nc_axis(x, i)

# S3 method for class 'NetCDF'
nc_axis(x, i)
```

## Arguments

- x:

  NetCDF source

- i:

  index of axis (1-based, 0 is "empty")

## Value

data frame of a single axis instance, with columns 'axis', 'variable',
'dimension'

## Details

Each data source has a set of dimensions available for use by variables.
Each axis is a 1-dimensional instance.

## Examples

``` r
f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
nc_axis(f, 1)
#> # A tibble: 1 × 3
#>    axis variable dimension
#>   <int> <chr>        <int>
#> 1     1 chlor_a          1
```
