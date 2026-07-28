# NetCDF variables Obtain information about a single dimension by index.

NetCDF variables Obtain information about a single dimension by index.

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

## See also

`nc_vars` to obtain information about all dimensions, `nc_inq` for an
overview of the file
