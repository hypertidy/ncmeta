# File info

Get information about a NetCDF data source, may be a file path, or a
`RNetCDF` file handle, or an OpenDAP/Thredds server address.

## Usage

``` r
nc_inq(x, ...)

# S3 method for class 'NetCDF'
nc_inq(x, ...)

# S3 method for class 'character'
nc_inq(x, ...)
```

## Arguments

- x:

  filename or handle

- ...:

  ignored

## Examples

``` r
# \donttest{
if (FALSE) { # \dontrun{
 f <- raadfiles:::cmip5_files()$fullname[1]
 nc_inq(f)
 nc_var(f, 0)
 nc_dim(f, 0)
 } # }
# }
f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
nc_inq(f)
#> # A tibble: 1 × 5
#>   ndims nvars ngatts unlimdimid filename                                        
#>   <int> <int>  <int>      <int> <chr>                                           
#> 1     4     4     65         NA /home/runner/work/_temp/Library/ncmeta/extdata/…
nc_var(f, 0)
#> # A tibble: 1 × 18
#>      id name    type     ndims dimids natts chunksizes cache_bytes cache_slots
#>   <int> <chr>   <chr>    <int> <list> <int> <list>           <dbl>       <dbl>
#> 1     0 chlor_a NC_FLOAT     2 <int>     12 <dbl [2]>     16777216        4133
#> # ℹ 9 more variables: cache_preemption <dbl>, deflate <int>, shuffle <lgl>,
#> #   big_endian <lgl>, fletcher32 <lgl>, szip_options <int>, szip_bits <int>,
#> #   filter_id <list>, filter_params <list>
nc_dim(f, 0)
#> # A tibble: 1 × 4
#>      id name  length unlim
#>   <int> <chr>  <dbl> <lgl>
#> 1     0 lat     2160 FALSE

nc_vars(f)
#> # A tibble: 4 × 5
#>      id name    type     ndims natts
#>   <int> <chr>   <chr>    <int> <int>
#> 1     0 chlor_a NC_FLOAT     2    12
#> 2     1 lat     NC_FLOAT     1     5
#> 3     2 lon     NC_FLOAT     1     5
#> 4     3 palette NC_UBYTE     2     0
nc_dims(f)
#> # A tibble: 4 × 4
#>      id name          length unlim
#>   <int> <chr>          <dbl> <lgl>
#> 1     0 lat             2160 FALSE
#> 2     1 lon             4320 FALSE
#> 3     2 rgb                3 FALSE
#> 4     3 eightbitcolor    256 FALSE
```
