# Get Coordinate Variables for Given Variable

In NetCDF, variables are defined along dimensions and are said to have
"coordinate variables" that define the (typically spatio-temporal)
positions of the data's cells.

## Usage

``` r
nc_coord_var(x, variable = NULL, ...)

# S3 method for class 'character'
nc_coord_var(x, variable = NULL, ...)

# S3 method for class 'NetCDF'
nc_coord_var(x, variable = NULL, ...)
```

## Arguments

- x:

  NetCDF source

- variable:

  variable name of interest. If not included, all variables will be
  returned.

- ...:

  ignored

## Value

tibble with "variable", "X", "Y", "Z", "T", and "bounds" columns that
reference variables by name.

## Details

This function attempts to identify the X, Y, Z, and T coordinate
variables for each data variable in the provided NetCDF source. The
NetCDF-CF attribute conventions are used to make this determination.

All variables that can be related to a spatio-temporal axis, including
coordinate variables are returned. For coordinate variables, a "bounds"
column is included in the response indicating which variable contains
bounds information.

See
<http://cfconventions.org/cf-conventions/v1.6.0/cf-conventions.html#coordinate-system>
for more.

## Examples

``` r
f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
nc_coord_var(f, "chlor_a")
#> # A tibble: 1 × 6
#>   variable X     Y     Z     T     bounds
#>   <chr>    <chr> <chr> <chr> <chr> <chr> 
#> 1 chlor_a  lon   lat   NA    NA    NA    

f <- system.file("extdata", "guam.nc", package = "ncmeta")
nc_coord_var(f)
#> # A tibble: 5 × 6
#>   variable       X     Y     Z     T     bounds   
#>   <chr>          <chr> <chr> <chr> <chr> <chr>    
#> 1 RAINNC_present XLONG XLAT  NA    Time  NA       
#> 2 Time           NA    NA    NA    Time  time_bnds
#> 3 T2_present     XLONG XLAT  NA    Time  NA       
#> 4 U10_present    XLONG XLAT  NA    Time  NA       
#> 5 V10_present    XLONG XLAT  NA    Time  NA       
```
