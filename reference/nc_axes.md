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

## Details

Each data source has a set of dimensions available for use by variables.
Each axis is a 1-dimensional instance.
