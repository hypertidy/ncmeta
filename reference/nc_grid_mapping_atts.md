# Get Grid Mapping

Get the grid mapping from a NetCDF file

## Usage

``` r
nc_grid_mapping_atts(x, data_variable = NULL)

# S3 method for class 'character'
nc_grid_mapping_atts(x, data_variable = NULL)

# S3 method for class 'NetCDF'
nc_grid_mapping_atts(x, data_variable = NULL)

# S3 method for class 'data.frame'
nc_grid_mapping_atts(x, data_variable = NULL)
```

## Arguments

- x:

  open NetCDF object, character file path or url to be opened with
  RNetCDF::open.nc, or data.frame as returned from ncmeta::nc_atts

- data_variable:

  character variable of interest

## Value

tibble containing attributes that make up the file's grid_mapping. A
data_variable column is included to indicate which data variable the
grid mapping belongs to.

## Examples

``` r

nc_grid_mapping_atts(system.file("extdata/daymet_sample.nc", package = "ncmeta"))
#> # A tibble: 11 × 5
#>       id name                          variable              value data_variable
#>    <int> <chr>                         <chr>                 <nam> <chr>        
#>  1     0 grid_mapping_name             lambert_conformal_co… <chr> prcp         
#>  2     1 longitude_of_central_meridian lambert_conformal_co… <dbl> prcp         
#>  3     2 latitude_of_projection_origin lambert_conformal_co… <dbl> prcp         
#>  4     3 false_easting                 lambert_conformal_co… <dbl> prcp         
#>  5     4 false_northing                lambert_conformal_co… <dbl> prcp         
#>  6     5 standard_parallel             lambert_conformal_co… <dbl> prcp         
#>  7     6 semi_major_axis               lambert_conformal_co… <dbl> prcp         
#>  8     7 inverse_flattening            lambert_conformal_co… <dbl> prcp         
#>  9     8 longitude_of_prime_meridian   lambert_conformal_co… <dbl> prcp         
#> 10     9 _CoordinateTransformType      lambert_conformal_co… <chr> prcp         
#> 11    10 _CoordinateAxisTypes          lambert_conformal_co… <chr> prcp         
```
