
#' NetCDF variables
#'
#' Generate a table of all variables. 
#' @param x filename or handle
#' @param ... ignored currently
#'
#' @return data frame of variable information
#' @export
#'
nc_vars <- function(x, ...)  {
  UseMethod("nc_vars")
}
#' @name nc_vars
#' @export
nc_vars.character <- function(x, ...) {
  nc <- RNetCDF::open.nc(x)
  on.exit(RNetCDF::close.nc(nc), add  = TRUE)
  nc_vars(nc)
}
#' @name nc_vars
#' @export
#' @importFrom dplyr %>% 
nc_vars.NetCDF <- function(x, ...) {
  dplyr::bind_rows(lapply(seq_len(nc_inq(x)$nvars), function(i) nc_var(x, i-1))) %>% 
    distinct(id, name, type, ndims, natts)
  
}
