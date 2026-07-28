# NetCDF grids

A `grid` is a discretized space, defined by a set of dimensions. These
are the spaces used by one or more variables in a source. Traditional
summaries are organized by variable, but when organized by space or grid
we can treat multiple variables together using standard database
techniques.

## Usage

``` r
nc_grids(x, ...)

# S3 method for class 'character'
nc_grids(x, ...)

# S3 method for class 'NetCDF'
nc_grids(x, ...)

# S3 method for class 'tidync'
nc_grids(x, ...)
```

## Arguments

- x:

  NetCDF source

- ...:

  ignored

## Details

Each data source has a set of dimensions available for use by variables.
Each grid is an n-dimensional space available for use by 0, 1 or more
variables. A grid only really exists if variable is defined for it, and
'grid' is an implicit entity not an explicit part of the NetCDF API
definition. The Unidata pages refer to "shape", which is more or less
what we mean by "grid".
