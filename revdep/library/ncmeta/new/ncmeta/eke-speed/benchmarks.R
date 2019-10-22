

f <- raadtools::sstfiles()$fullname[1:100]
#l <- purrr::map(f, ncmeta::nc_meta)

x <- RNetCDF::open.nc(f[1])
library(ncmeta)
library(rbenchmark)
vars <- nc_vars(x)
inq <- nc_inq(x)
axis <- nc_axes(x, variables = vars$name)
dims <- nc_dims(x)
benchmark(
          nc_atts_internal = nc_atts_internal(x, inq$ngatts, vars), 
          nc_inq = nc_inq(x), 
          nc_dims = nc_dims_internal(x, inq[["ndims"]]), 
          nc_vars = nc_vars_internal(x, nrow(vars)), 
          nc_axes = nc_axes(x, variables = vars$name), 
          nc_grid = nc_grids_dimvar(dims, vars, axis),
          nc_meta = nc_meta(x), 
          ncdf4 = ncdf4::nc_open(f),
          replications = 100)


##nc_meta calls

##  nc_dims is good
##  nc_vars calls
##   nc_inq is good
##  nc_atts calls
##   nc_inq for ngatts
##   nc_vars for natts


# meta is dims, vars, atts, axes, grids
## grids is dims, vars, axes
## axes is nc_vars, but only to get the variable names
## atts is inq, vars
## inq is file.inq.nc
## vars is inq, only to get nvars
## dims is nc_inq, nc_dim - only needs ndims

## dims is already fast
