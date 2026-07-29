#' NetCDF dimension
#'
#' Obtain information about a single dimension by index. 
#' @param x filename or handle
#' @param ... ignored
#' @param i index of dimension (zero based)
#'
#' @return data frame of dimension information, with columns 'id', 'name', 'length', 'unlim'
#' @examples
#' f <- system.file("extdata", "S2008001.L3m_DAY_CHL_chlor_a_9km.nc", package = "ncmeta")
#' nc_dim(f, 0)
#' @name nc_dim
#' @seealso `nc_dims` to obtain information about all dimensions, `nc_inq` for an
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
  tibble::as_tibble(RNetCDF::dim.inq.nc(x, i))
}
#'@name nc_dim
#'@export
nc_dim.ncdf4 <- function(x, i, ...) {
  nc_dim(x$filename, i, ...)
}

