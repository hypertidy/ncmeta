#' Top level NetCDF metadata. 
#' 
#' This function exists to maintain the open connection
#' while all dimension, variable, and attribute metadata is extracted. 
#'
#' @param ... ignored
#' @param x data source address, file name or handle
#'
#' @export
#' @examples 
#' f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
#' nc_meta(f)
#' \donttest{
#' \dontrun{
#' u <- "https://upwell.pfeg.noaa.gov/erddap/tabledap/FRDCPSTrawlLHHaulCatch"
#' nc_meta(u)
#' }}
nc_meta <- function(x, ...) {
 UseMethod("nc_meta")   
}

#' @name nc_meta
#' @export
nc_meta.NetCDF <- function(x, ...) {
  inq <- nc_inq(x)
  dims <- nc_dims_internal(x, inq[["ndims"]])
 
  vars <- nc_vars_internal(x, inq$nvars)
  axis <- nc_axes(x, vars$name)
  ## does a dimension have dim-vals?
  if (nrow(dims) > 0) dims[["coord_dim"]] <- dims[["name"]] %in% vars[["name"]]
  ## is a variable a dim-val?
  
  if (nrow(vars) > 0) vars[["dim_coord"]] <- vars[["ndims"]] == 1L & vars[["name"]] %in% dims[["name"]]
  
  structure(list(dimension = dims, 
       variable = vars, 
       attribute = nc_atts_internal(x, inq$ngatts, vars), 
       axis = axis,
       grid = nc_grids_dimvar(dims, vars, axis)),
       class = "ncmeta")
}

#' @name nc_meta
#' @export
nc_meta.character <- function(x, ...) {
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  
  out <- nc_meta(nc)
  out$source <- nc_sources(x)
  out
}