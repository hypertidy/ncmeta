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
  nc <- nc_connection(x)
  on.exit(nc_cleanup(nc), add = TRUE)
  nc_dims(nc)
}
#' @name nc_dims
#' @export
nc_dims.default <- function(x, ...) {
  dplyr::bind_rows(lapply(seq_len(nc_inq(x)$ndims), function(i) nc_dim(x, i-1)))
}

nc_dims_internal <- function(x, ndims, ...) {
  dplyr::bind_rows(lapply(seq_len(ndims), function(i) nc_dim(x, i-1)))
  
}