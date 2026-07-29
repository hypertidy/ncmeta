# NetCDF sources

A record of file, URL, or any data source with NetCDF.

## Usage

``` r
nc_sources(x, ...)

# S3 method for class 'character'
nc_sources(x, ...)
```

## Arguments

- x:

  data source string

- ...:

  ignored

## Value

data frame with columns 'access' (time of access), 'source' (the source
string)

## Examples

``` r
f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
nc_sources(f)
#> # A tibble: 1 × 2
#>   access              source                                                    
#>   <dttm>              <chr>                                                     
#> 1 2026-07-29 03:08:14 /home/runner/work/_temp/Library/ncmeta/extdata/S2008001.L…
```
