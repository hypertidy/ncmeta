#' NetCDF axes
#' 
#' An `axis` is an instance of a dimension. 
#' 
#' Each data source has a set of dimensions available for use by variables. Each axis is
#' a 1-dimensional instance. 
#'
#' @param x NetCDF source 
#' @param i index of axis (1-based, 0 is "empty")
#'
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
  nc_axes(x) %>% dplyr::filter(.data$axis == i)
}


