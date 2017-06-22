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
#' u <- "https://upwell.pfeg.noaa.gov/erddap/tabledap/FRDCPSTrawlLHHaulCatch"
nc_meta <- function(x, ...) {
 UseMethod("nc_meta")   
}

#' @name nc_meta
#' @export
nc_meta.NetCDF <- function(x, ...) {
  structure(list(dimension = nc_dims(x), 
       variable = nc_vars(x), 
       attribute = nc_atts(x), 
       axes = nc_axes(x)), 
       class = "ncmeta")
}

#' @name nc_meta
#' @export
nc_meta.character <- function(x, ...) {
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  
  nc_meta(nc)
}