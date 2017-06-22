
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
  ## note this is a bit weird, but we have to ensure
  ## we work relative to all axes, so use the hidden function nc_axis_var
  nc_axes(x) %>% dplyr::filter(id == i)
}



nc_axis_var <- function(x, i) {
  as_tibble(RNetCDF::var.inq.nc(x, i))
}
