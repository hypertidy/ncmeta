# Get NetCDF-CF grid mapping from projection

Takes a proj4 string and returns a NetCDF-CF projection as a named list
of attributes.

## Usage

``` r
nc_prj_to_gridmapping(prj)
```

## Arguments

- prj:

  character PROJ string as used in raster, sf, sp, proj4, and rgdal
  packages.

## Value

A named list containing attributes required for that grid_mapping.

## References

1.  <https://en.wikibooks.org/wiki/PROJ.4>

2.  <https://trac.osgeo.org/gdal/wiki/NetCDF_ProjectionTestingStatus>

3.  <https://cfconventions.org/cf-conventions/cf-conventions.html>

## Examples

``` r
prj <- "+proj=longlat +datum=NAD27 +no_defs"
nc_prj_to_gridmapping(prj)
#> # A tibble: 4 × 2
#>   name                        value    
#>   <chr>                       <list>   
#> 1 grid_mapping_name           <chr [1]>
#> 2 semi_major_axis             <dbl [1]>
#> 3 inverse_flattening          <dbl [1]>
#> 4 longitude_of_prime_meridian <dbl [1]>
p1 <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96"
p2 <- "+x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
prj2 <- sprintf("%s %s", p1, p2) 
nc_prj_to_gridmapping(prj2)
#> # A tibble: 9 × 2
#>   name                          value    
#>   <chr>                         <list>   
#> 1 grid_mapping_name             <chr [1]>
#> 2 longitude_of_central_meridian <dbl [1]>
#> 3 latitude_of_projection_origin <dbl [1]>
#> 4 false_easting                 <dbl [1]>
#> 5 false_northing                <dbl [1]>
#> 6 standard_parallel             <dbl [2]>
#> 7 semi_major_axis               <dbl [1]>
#> 8 inverse_flattening            <dbl [1]>
#> 9 longitude_of_prime_meridian   <dbl [1]>

nc_prj_to_gridmapping("+proj=longlat +a=6378137 +f=0.00335281066474748 +pm=0 +no_defs")
#> # A tibble: 4 × 2
#>   name                        value    
#>   <chr>                       <list>   
#> 1 grid_mapping_name           <chr [1]>
#> 2 semi_major_axis             <dbl [1]>
#> 3 inverse_flattening          <dbl [1]>
#> 4 longitude_of_prime_meridian <dbl [1]>
```
