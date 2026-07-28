# NetCDF attributes

Variable attributes are number 0:(n-1). Global attributes are indexed by
-1 or the label "NC_GLOBAL".

## Usage

``` r
nc_att(x, variable, attribute, ...)

# S3 method for class 'NetCDF'
nc_att(x, variable, attribute, ...)

# S3 method for class 'character'
nc_att(x, variable, attribute, ...)
```

## Arguments

- x:

  or file handle

- variable:

  name or index (zero based) of variable

- attribute:

  name or index (zero based) of attribute

- ...:

  ignored

## Value

data frame of attribute with numeric id, character attribute name,
character or numeric variable id or name depending on input, and
attribute value.

## Details

`nc_inq` includes the number of global attributes `nc_vars` includes the
number of variable attributes

## Examples

``` r
f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
nc_att(f, 0, 0)
#> # A tibble: 1 × 4
#>      id name      variable value       
#>   <int> <chr>        <dbl> <named list>
#> 1     0 long_name        0 <chr [1]>   
```
