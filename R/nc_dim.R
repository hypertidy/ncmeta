#' NetCDF variables
#' Obtain information about a single dimension by index. 
#' @param x filename or handle
#' @param ... ignored
#' @param i index of dimension (zero based)
#'
#' @name nc_dim
#' @seealso `nc_vars` to obtain information about all dimensions, `nc_inq` for an 
#' overview of the file
#' @export
nc_dim <- function(x, i, ...) {
  UseMethod("nc_dim")
}
#'@name nc_dim
#'@export
nc_dim.character <- function(x, i, ...) {
  if (nchar(x) < 1) stop("NetCDF source cannot be empty string")
  
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  nc_dim(nc, i)
}

#'@name nc_dim
#'@export
nc_dim.NetCDF <- function(x, i, ...) {
  faster_as_tibble(RNetCDF::dim.inq.nc(x, i))
}
#'@name nc_dim
#'@export
nc_dim.ncdf4 <- function(x, i, ...) {
  nc_dim(x$filename, i, ...)
}

