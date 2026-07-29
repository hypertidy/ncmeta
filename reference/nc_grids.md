# NetCDF grids

A `grid` is a discretized space, defined by a set of dimensions. These
are the spaces used by one or more variables in a source. Traditional
summaries are organized by variable, but when organized by space or grid
we can treat multiple variables together using standard database
techniques.

## Usage

``` r
nc_grids(x, ...)

# S3 method for class 'character'
nc_grids(x, ...)

# S3 method for class 'NetCDF'
nc_grids(x, ...)

# S3 method for class 'tidync'
nc_grids(x, ...)
```

## Arguments

- x:

  NetCDF source

- ...:

  ignored

## Value

data frame of grid information, one row per grid, with columns 'grid' (a
label of the dimensions in the grid), 'ndims', 'variables' (a nested
data frame of the variables defined on the grid), 'nvars'

## Details

Each data source has a set of dimensions available for use by variables.
Each grid is an n-dimensional space available for use by 0, 1 or more
variables. A grid only really exists if variable is defined for it, and
'grid' is an implicit entity not an explicit part of the NetCDF API
definition. The Unidata pages refer to "shape", which is more or less
what we mean by "grid".

## Examples

``` r
f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
nc_grids(f)
#> # A tibble: 4 × 4
#>   grid  ndims variables        nvars
#>   <chr> <int> <list>           <int>
#> 1 D1,D0     2 <tibble [1 × 1]>     1
#> 2 D3,D2     2 <tibble [1 × 1]>     1
#> 3 D0        1 <tibble [1 × 1]>     1
#> 4 D1        1 <tibble [1 × 1]>     1
```
