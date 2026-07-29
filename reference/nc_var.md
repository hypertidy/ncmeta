# NetCDF variable

Return a data frame about the variable at index `i`.

## Usage

``` r
nc_var(x, i)

# S3 method for class 'character'
nc_var(x, i)

# S3 method for class 'NetCDF'
nc_var(x, i)
```

## Arguments

- x:

  file name or handle

- i:

  variable index (zero based)

## Value

data frame of variable information

## See also

`nc_vars` to obtain information about all variables, `nc_inq` for an
overview of the file

## Examples

``` r
f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
nc_var(f, 0)
#> # A tibble: 1 × 18
#>      id name    type     ndims dimids natts chunksizes cache_bytes cache_slots
#>   <int> <chr>   <chr>    <int> <list> <int> <list>           <dbl>       <dbl>
#> 1     0 chlor_a NC_FLOAT     2 <int>     12 <dbl [2]>     16777216        4133
#> # ℹ 9 more variables: cache_preemption <dbl>, deflate <int>, shuffle <lgl>,
#> #   big_endian <lgl>, fletcher32 <lgl>, szip_options <int>, szip_bits <int>,
#> #   filter_id <list>, filter_params <list>
```
