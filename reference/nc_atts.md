# NetCDF attributes

All attributes in the file, globals are treated as if they belong to
variable 'NC_GLOBAL'. Attributes for a single variable may be returned
by specifying 'variable' - 'NC_GLOBAL' can stand in to return only those
attributes.

## Usage

``` r
nc_atts(x, variable = NULL, ...)

# S3 method for class 'NetCDF'
nc_atts(x, variable = NULL, ...)

# S3 method for class 'character'
nc_atts(x, variable = NULL, ...)
```

## Arguments

- x:

  filename or handle

- variable:

  optional single name of a variable, or 'NC_GLOBAL'

- ...:

  ignored

## Value

data frame of attributes

## Examples

``` r
f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
nc_atts(f)
#> # A tibble: 87 × 4
#>       id name          variable value       
#>    <int> <chr>         <chr>    <named list>
#>  1     0 long_name     chlor_a  <chr [1]>   
#>  2     1 units         chlor_a  <chr [1]>   
#>  3     2 standard_name chlor_a  <chr [1]>   
#>  4     3 _FillValue    chlor_a  <dbl [1]>   
#>  5     4 valid_min     chlor_a  <dbl [1]>   
#>  6     5 valid_max     chlor_a  <dbl [1]>   
#>  7     6 display_scale chlor_a  <chr [1]>   
#>  8     7 display_min   chlor_a  <dbl [1]>   
#>  9     8 display_max   chlor_a  <dbl [1]>   
#> 10     9 scale_factor  chlor_a  <dbl [1]>   
#> # ℹ 77 more rows
```
