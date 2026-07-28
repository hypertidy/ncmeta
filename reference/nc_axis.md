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

## Details

Each data source has a set of dimensions available for use by variables.
Each axis is a 1-dimensional instance.
