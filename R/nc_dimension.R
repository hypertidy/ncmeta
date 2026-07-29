#' NetCDF dimension
#' 
#' Get information about the dimensions in a NetCDF source. 
#' @param x file address or handle
#' @param ... ignored
#'
#' @return data frame of dimension information, one row per dimension, with columns
#' 'id', 'name', 'length', 'unlim'
#' @examples
#' f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
#' nc_dims(f)
#' @name nc_dims
#' @export
nc_dims <- function(x, ...)  {
  UseMethod("nc_dims")
}
#' @name nc_dims
#' @export
nc_dims.character <- function(x, ...) {
  if (nchar(x) < 1) stop("NetCDF source cannot be empty string")
  
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  nc_dims(nc)
}
#' @name nc_dims
#' @export
nc_dims.NetCDF <- function(x, ...) {
  dplyr::bind_rows(lapply(seq_len(nc_inq(x)$ndims), function(i) nc_dim(x, i-1)))
}
nc_dims_internal <- function(x, ndims, ...) {
  dplyr::bind_rows(lapply(seq_len(ndims), function(i) nc_dim(x, i-1)))
  
}
#' @name nc_dims
#' @export
nc_dims.ncdf4 <- function(x, ...) {
  nc_dims(x$filename)
}
