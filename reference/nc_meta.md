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

## Value

a list of data frames, with class 'ncmeta', named 'dimension',
'variable' (NULL if the source has no variables), 'attribute',
'extended', 'axis', 'grid', 'source'

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
#> 1 2026-07-29 02:41:21 /home/runner/work/_temp/Library/ncmeta/extdata/S2008001.L…
#> 
#> attr(,"class")
#> [1] "ncmeta"
# \donttest{
## remote server, not run in checks
u <- "https://upwell.pfeg.noaa.gov/erddap/tabledap/FRDCPSTrawlLHHaulCatch"
nc_meta(u)
#> $dimension
#> # A tibble: 2 × 5
#>      id name        length unlim coord_dim
#>   <int> <chr>        <dbl> <lgl> <lgl>    
#> 1     0 maxStrlen64     64 FALSE FALSE    
#> 2     1 s               36 FALSE FALSE    
#> 
#> $variable
#> # A tibble: 19 × 6
#>       id name                     type      ndims natts dim_coord
#>    <int> <chr>                    <chr>     <int> <int> <lgl>    
#>  1     0 s.cruise                 NC_INT        1     4 FALSE    
#>  2     1 s.ship                   NC_CHAR       2     3 FALSE    
#>  3     2 s.haul                   NC_INT        1     4 FALSE    
#>  4     3 s.collection             NC_INT        1     4 FALSE    
#>  5     4 s.latitude               NC_FLOAT      1     8 FALSE    
#>  6     5 s.longitude              NC_FLOAT      1     8 FALSE    
#>  7     6 s.stop_latitude          NC_FLOAT      1     4 FALSE    
#>  8     7 s.stop_longitude         NC_FLOAT      1     4 FALSE    
#>  9     8 s.time                   NC_DOUBLE     1     9 FALSE    
#> 10     9 s.haulback_time          NC_DOUBLE     1     6 FALSE    
#> 11    10 s.surface_temp           NC_FLOAT      1     5 FALSE    
#> 12    11 s.surface_temp_method    NC_CHAR       2     3 FALSE    
#> 13    12 s.ship_spd_through_water NC_FLOAT      1     5 FALSE    
#> 14    13 s.itis_tsn               NC_INT        1     4 FALSE    
#> 15    14 s.scientific_name        NC_CHAR       2     3 FALSE    
#> 16    15 s.subsample_count        NC_INT        1     4 FALSE    
#> 17    16 s.subsample_weight       NC_FLOAT      1     5 FALSE    
#> 18    17 s.remaining_weight       NC_FLOAT      1     5 FALSE    
#> 19    18 s.presence_only          NC_CHAR       2     3 FALSE    
#> 
#> $attribute
#> # A tibble: 128 × 4
#>       id name          variable value       
#>    <int> <chr>         <chr>    <named list>
#>  1     0 actual_range  s.cruise <dbl [2]>   
#>  2     1 description   s.cruise <chr [1]>   
#>  3     2 ioos_category s.cruise <chr [1]>   
#>  4     3 long_name     s.cruise <chr [1]>   
#>  5     0 description   s.ship   <chr [1]>   
#>  6     1 ioos_category s.ship   <chr [1]>   
#>  7     2 long_name     s.ship   <chr [1]>   
#>  8     0 actual_range  s.haul   <dbl [2]>   
#>  9     1 description   s.haul   <chr [1]>   
#> 10     2 ioos_category s.haul   <chr [1]>   
#> # ℹ 118 more rows
#> 
#> $extended
#> # A tibble: 2 × 3
#>   dimension name        time     
#>       <int> <chr>       <list>   
#> 1         0 maxStrlen64 <lgl [1]>
#> 2         1 s           <lgl [1]>
#> 
#> $axis
#> # A tibble: 23 × 3
#>     axis variable         dimension
#>    <int> <chr>                <int>
#>  1     1 s.cruise                 1
#>  2     2 s.ship                   0
#>  3     3 s.ship                   1
#>  4     4 s.haul                   1
#>  5     5 s.collection             1
#>  6     6 s.latitude               1
#>  7     7 s.longitude              1
#>  8     8 s.stop_latitude          1
#>  9     9 s.stop_longitude         1
#> 10    10 s.time                   1
#> # ℹ 13 more rows
#> 
#> $grid
#> # A tibble: 2 × 4
#>   grid  ndims variables         nvars
#>   <chr> <int> <list>            <int>
#> 1 D0,D1     2 <tibble [4 × 1]>      4
#> 2 D1        1 <tibble [15 × 1]>    15
#> 
#> $source
#> # A tibble: 1 × 2
#>   access              source                                                    
#>   <dttm>              <chr>                                                     
#> 1 2026-07-29 02:41:23 https://upwell.pfeg.noaa.gov/erddap/tabledap/FRDCPSTrawlL…
#> 
#> attr(,"class")
#> [1] "ncmeta"
# }
```
