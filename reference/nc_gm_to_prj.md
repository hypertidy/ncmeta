# Get projection from NetCDF-CF Grid Mapping

Takes NetCDF-CF grid mapping attributes and returns a proj4 string.

## Usage

``` r
nc_gm_to_prj(x)

# S3 method for class 'data.frame'
nc_gm_to_prj(x)

# S3 method for class 'list'
nc_gm_to_prj(x)
```

## Arguments

- x:

  list or data.frame of attributes of the grid mapping variable as
  returned by ncdf or ncdf4's get attributes functions or ncmeta's
  nc_grid_mapping_atts.

## Value

A proj4 string.

## Details

The WGS84 datum is used as a default if one os not provided in the grid
mapping.

If only a semi_major axis is provided, a sperical earth is assumed.

## References

1.  <https://en.wikibooks.org/wiki/PROJ.4>

2.  <https://trac.osgeo.org/gdal/wiki/NetCDF_ProjectionTestingStatus>

3.  <http://cfconventions.org/cf-conventions/cf-conventions.html#appendix-grid-mappings>

## Examples

``` r

crs <- list(grid_mapping_name="latitude_longitude",
            longitude_of_prime_meridian = 0,
            semi_major_axis = 6378137,
            inverse_flattening = 298)
nc_gm_to_prj(crs)
```
