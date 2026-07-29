## Create inst/extdata/dims_only.nc: a classic-model file with dimensions
## and a global attribute but zero variables. Some sources present this
## shape through the classic RNetCDF inquiry (e.g. NASA ocean colour L3 bin
## files whose variables live in groups/compound types), and nc_meta() in
## ncmeta 0.4.0 errored on them via distinct() on a zero-column table.
## Regression test lives in tests/testthat/test-novars.R.
f <- file.path("inst", "extdata", "dims_only.nc")
nc <- RNetCDF::create.nc(f, format = "classic")
RNetCDF::dim.def.nc(nc, "x", 4)
RNetCDF::dim.def.nc(nc, "y", 3)
RNetCDF::att.put.nc(nc, "NC_GLOBAL", "title", "NC_CHAR",
                    "dims-only fixture, zero variables (regression for nc_meta with nvars == 0)")
RNetCDF::close.nc(nc)
