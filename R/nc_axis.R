
#' @name nc_axis
#' @export
nc_axis <- function(x, i) {
  UseMethod("nc_axis")
}
#' @name nc_axis
#' @export
nc_axis.character <- function(x, i) {
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  nc_axis(nc, i)
}
#' @name nc_axis
#' @export
nc_axis.NetCDF <- function(x, i) {
  nc_axes(x) %>% dplyr::filter(axis == i)
}


