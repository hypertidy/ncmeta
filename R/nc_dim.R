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
  nc <- nc_connection(x)
  on.exit(nc_cleanup(nc), add = TRUE)
  nc_dim(nc, i)
}

#'@name nc_dim
#'@export
nc_dim.NetCDF <- function(x, i, ...) {
  tibble::as_tibble(RNetCDF::dim.inq.nc(x, i))
}
#'@name nc_dim
#'@export
nc_dim.ncdf4 <- function(x, i, ...) {
  if (is.numeric(i)) i <- i + 1
  tibble::tibble(id = x$dim[[i]]$id, name = x$dim[[i]]$name, length = x$dim[[i]]$len, unlim = x$dim[[i]]$unlim)
}

