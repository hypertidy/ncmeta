# NetCDF variable

Return a data frame about the variable at index `i`.

## Usage

``` r
nc_var(x, i)

# S3 method for class 'character'
nc_var(x, i)

# S3 method for class 'NetCDF'
nc_var(x, i)
```

## Arguments

- x:

  file name or handle

- i:

  variable index (zero based)

## Value

data frame of variable information

## See also

`nc_vars` to obtain information about all variables, `nc_inq` for an
overview of the file
