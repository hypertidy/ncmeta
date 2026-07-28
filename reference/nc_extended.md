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
