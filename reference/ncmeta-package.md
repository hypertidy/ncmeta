# ncmeta: Straightforward 'NetCDF' Metadata

Extract metadata from 'NetCDF' data sources, these can be files, file
handles or servers. This package leverages and extends the lower level
functions of the 'RNetCDF' package providing a consistent set of
functions that all return data frames. We introduce named concepts of
'grid', 'axis' and 'source' which are all meaningful entities without
formal definition in the 'NetCDF' library
<https://www.unidata.ucar.edu/software/netcdf/>. 'RNetCDF' matches the
library itself with only the named concepts of 'variables', 'dimensions'
and 'attributes'.

`ncmeta` provides a consistent set of tools to obtain metadata from
NetCDF. NetCDF is 'Network Common Data Form'
https://www.unidata.ucar.edu/software/netcdf/. These functions are
generics, allowing methods to be written for various providers so that
everything can work from a common basis. All functions return a data
frame.

## Details

Each function responds to a character file name or data source (i.e.
URL) or to a connection of a given class, this is so a source connection
may be created a minimal number of times and kept open while a number of
entities are queried.

Each "given" entity may be referred to by index (0-based) or name, just
as it would be by the NetCDF API and by the two R wrapper providers
`RNetCDF` and `ncdf4`.

|  |  |
|----|----|
| [`nc_att`](https://hypertidy.github.io/ncmeta/reference/nc_att.md) | find the given attribute of a given variable |
| [`nc_atts`](https://hypertidy.github.io/ncmeta/reference/nc_atts.md) | find all attributes, of all variables and globals |
| [`nc_axes`](https://hypertidy.github.io/ncmeta/reference/nc_axes.md) | find all the instances of dimensions |
| [`nc_axis`](https://hypertidy.github.io/ncmeta/reference/nc_axis.md) | find given instance of a dimension (1-based) |
| [`nc_dim`](https://hypertidy.github.io/ncmeta/reference/nc_dim.md) | find the given dimension of a source (0-based) |
| [`nc_dims`](https://hypertidy.github.io/ncmeta/reference/nc_dims.md) | find all the dimensions of a source |
| [`nc_grids`](https://hypertidy.github.io/ncmeta/reference/nc_grids.md) | find the grids (sets of dimensions) of a source |
| [`nc_inq`](https://hypertidy.github.io/ncmeta/reference/nc_inq.md) | inquire about a source (i.e. number of dimensions, number of variables, number of global attributes and presence of unlimited dimension |
| [`nc_meta`](https://hypertidy.github.io/ncmeta/reference/nc_meta.md) | find all metadata for a source (runs all other functions) |
| [`nc_sources`](https://hypertidy.github.io/ncmeta/reference/nc_sources.md) | tags a record of a source and its "access time" |
| [`nc_var`](https://hypertidy.github.io/ncmeta/reference/nc_var.md) | find a given variable (0-based) |
| [`nc_vars`](https://hypertidy.github.io/ncmeta/reference/nc_vars.md) | find the variables of a source |

## See also

Useful links:

- <https://github.com/hypertidy/ncmeta>

- <https://hypertidy.github.io/ncmeta/>

- Report bugs at <https://github.com/hypertidy/ncmeta/issues>

## Author

**Maintainer**: Michael Sumner <mdsumner@gmail.com>

Authors:

- Michael Sumner <mdsumner@gmail.com>

Other contributors:

- Tomas Remenyi \[contributor\]

- Ben Raymond \[contributor\]

- David Blodgett \[contributor\]

- Milton Woods \[contributor\]

- Patrick Van Laake \[contributor\]
