# Top level NetCDF metadata.

This function exists to maintain the open connection while all
dimension, variable, and attribute metadata is extracted.

## Usage

``` r
nc_meta(x, ...)

# S3 method for class 'NetCDF'
nc_meta(x, ...)

# S3 method for class 'character'
nc_meta(x, ...)
```

## Arguments

- x:

  data source address, file name or handle

- ...:

  ignored

## Details

This function is pretty ambitious, and will send nearly any string to
the underlying NetCDF library other than "", which immediately generates
an error. This should be robust, but might present fairly obscure error
messages from the underlying library.

## Examples

``` r
f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
nc_meta(f)
#> $dimension
#> # A tibble: 4 × 5
#>      id name          length unlim coord_dim
#>   <int> <chr>          <dbl> <lgl> <lgl>    
#> 1     0 lat             2160 FALSE TRUE     
#> 2     1 lon             4320 FALSE TRUE     
#> 3     2 rgb                3 FALSE FALSE    
#> 4     3 eightbitcolor    256 FALSE FALSE    
#> 
#> $variable
#> # A tibble: 4 × 6
#>      id name    type     ndims natts dim_coord
#>   <int> <chr>   <chr>    <int> <int> <lgl>    
#> 1     0 chlor_a NC_FLOAT     2    12 FALSE    
#> 2     1 lat     NC_FLOAT     1     5 TRUE     
#> 3     2 lon     NC_FLOAT     1     5 TRUE     
#> 4     3 palette NC_UBYTE     2     0 FALSE    
#> 
#> $attribute
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
#> 
#> $extended
#> # A tibble: 4 × 3
#>   dimension name          time     
#>       <int> <chr>         <list>   
#> 1         0 lat           <lgl [1]>
#> 2         1 lon           <lgl [1]>
#> 3         2 rgb           <lgl [1]>
#> 4         3 eightbitcolor <lgl [1]>
#> 
#> $axis
#> # A tibble: 6 × 3
#>    axis variable dimension
#>   <int> <chr>        <int>
#> 1     1 chlor_a          1
#> 2     2 chlor_a          0
#> 3     3 lat              0
#> 4     4 lon              1
#> 5     5 palette          3
#> 6     6 palette          2
#> 
#> $grid
#> # A tibble: 4 × 4
#>   grid  ndims variables        nvars
#>   <chr> <int> <list>           <int>
#> 1 D1,D0     2 <tibble [1 × 1]>     1
#> 2 D3,D2     2 <tibble [1 × 1]>     1
#> 3 D0        1 <tibble [1 × 1]>     1
#> 4 D1        1 <tibble [1 × 1]>     1
#> 
#> $source
#> # A tibble: 1 × 2
#>   access              source                                                    
#>   <dttm>              <chr>                                                     
#> 1 2026-07-28 23:22:21 /home/runner/work/_temp/Library/ncmeta/extdata/S2008001.L…
#> 
#> attr(,"class")
#> [1] "ncmeta"
# \donttest{
if (FALSE) { # \dontrun{
u <- "https://upwell.pfeg.noaa.gov/erddap/tabledap/FRDCPSTrawlLHHaulCatch"
nc_meta(u)
} # }# }
```
