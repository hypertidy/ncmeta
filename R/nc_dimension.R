#' NetCDF dimension
#' 
#' Get information about the dimensions in a NetCDF source. 
#' @param x file address or handle
#' @param ... ignored
#'
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
